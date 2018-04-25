//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package org.wso2.github.githubDatabase;

import ballerina.data.sql;
import ballerina.config;
import ballerina.net.http;
import ballerina.log;
import ballerina.time;
import org.wso2.github.logFile;
import ballerina.runtime;
import ballerina.io;

const string GIT_ACCESS_TOKEN = config:getGlobalValue("GITHUB_TOKEN");
const string DB_HOST = config:getGlobalValue("DB_HOST");
const string DB_NAME = config:getGlobalValue("DB_NAME");
const string DB_USER_NAME = config:getGlobalValue("DB_USER_NAME");
const string DB_PASSWORD = config:getGlobalValue("DB_PASSWORD");
const int DB_PORT = getDatabasePort();

sql:ClientConnector sqlHttpClient = create sql:ClientConnector(sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});

@Description {value:"Get all oprn pr of an organization from Github API"}
@Param {value:"organization: Name of the organization given in Github"}
@Return {value:"PullRequest[]:Array of open PRs"}
@Return {value:"OpenPRUpdateError: Error"}
public function getOpenPullRequests (string organization) (PullRequest[], OpenPRUpdateError) {
    endpoint<http:HttpClient> gitClient {
        create http:HttpClient(GIT_API_URL, {});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError httpError;

    boolean hasNextPage = true;
    //boolean hasNextPagePR = true;
    string lastCommittedDate;
    string repositoryName;
    OpenPRUpdateError updateError;

    PullRequest[] openPullRequestsArray = [];

    if (organization == null) {
        updateError = {message:["Error at identifing organization name: organization cannot be null"]};
        return [], updateError;
    }

    string stringQuery = string `{"{{GIT_VARIABLES}}":{"{{GIT_ORGANIZATION}}":"{{organization}}"},"{{GIT_QUERY}}":
                                                                                          "{{GET_REPOSITORIES}}"}`;
    var query, _ = <json>stringQuery;

    //Set headers and payload to the request
    constructRequest(request, query);
    int i = 0;

    //Iterate through multiple pages of results
    while (hasNextPage) {

        response, httpError = gitClient.post("", request);
        if (httpError != null) {
            updateError = {message:[httpError.message], statusCode:httpError.statusCode};
            return [], updateError;
        }

        json validatedResponse;
        //Check for empty payloads and errors
        validatedResponse, updateError = validateResponse(response, GIT_REPOSITORIES);
        if (updateError != null) {
            return [], updateError;
        }

        var githubRepositoriesJson, _ = (json[])validatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORIES]
                                                [GIT_NODES];
        foreach repositoryJson in githubRepositoriesJson {

            lastCommittedDate = selectLastCommittedDate(repositoryJson);
            repositoryName = repositoryJson[GIT_NAME].toString();

            var githubPullRequestJson, _ = (json[])repositoryJson[GIT_PULL_REQUESTS][GIT_NODES];
            foreach pullRequestJson in githubPullRequestJson {
                pullRequestJson[GIT_LAST_COMMITTED_DATE] = lastCommittedDate;
                pullRequestJson[GIT_REPOSITORY_NAME] = repositoryName;
                pullRequestJson[GIT_ORGANIZATION] = organization;
                openPullRequestsArray[i], _ = <PullRequest>pullRequestJson;
                i = i + 1;
            }

            var hasNextPagePR, _ = (boolean)repositoryJson[GIT_PULL_REQUESTS][GIT_PAGE_INFO][GIT_HAS_NEXT_PAGE];

            if (hasNextPagePR) {

                var endCursorPR, _ = (string)repositoryJson[GIT_PULL_REQUESTS][GIT_PAGE_INFO][GIT_END_CURSOR];

                while (hasNextPagePR) {

                    string stringQueryOpenPrNextPage = string `{"{{GIT_VARIABLES}}":{"{{GIT_ORGANIZATION}}":"{{organization}}","{{GIT_REPOSITORY_NAME_QUERY}}":"{{repositoryName}}","{{GIT_END_CURSOR}}":"{{endCursorPR}}"},"{{GIT_QUERY}}":"{{GET_OPEN_PR_NEXT_PAGE}}"}`;
                    var queryOpenPrNextPage, _ = <json>stringQueryOpenPrNextPage;
                    request = {};
                    constructRequest(request, queryOpenPrNextPage);

                    response, httpError = gitClient.post("", request);
                    if (httpError != null) {
                        updateError = {message:[httpError.message], statusCode:httpError.statusCode};
                        return [], updateError;
                    }

                    json validatedOpenPrResponse;
                    validatedOpenPrResponse, updateError = validateResponse(response, GIT_REPOSITORY);
                    var githubOpenPrJson, _ = (json[])validatedOpenPrResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORY][GIT_PULL_REQUESTS]
                                                      [GIT_NODES];
                    foreach pullRequestJson in githubOpenPrJson {
                        pullRequestJson[GIT_LAST_COMMITTED_DATE] = lastCommittedDate;
                        pullRequestJson[GIT_REPOSITORY_NAME] = repositoryName;
                        pullRequestJson[GIT_ORGANIZATION] = organization;
                        openPullRequestsArray[i], _ = <PullRequest>pullRequestJson;
                        i = i + 1;
                    }
                    endCursorPR, _ = (string)validatedOpenPrResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORY][GIT_PULL_REQUESTS][GIT_PAGE_INFO][GIT_END_CURSOR];
                    hasNextPagePR, _ = (boolean)validatedOpenPrResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORY][GIT_PULL_REQUESTS][GIT_PAGE_INFO][GIT_HAS_NEXT_PAGE];
                }
            }
        }

        hasNextPage, _ = (boolean)validatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORIES][GIT_PAGE_INFO]
                                  [GIT_HAS_NEXT_PAGE];
        log:printInfo("Received new page data from Github");
        logFile:logInfo("Received new page data from Github", runtime:getCallStack()[1].packageName);
        if (hasNextPage) {
            var endCursor, _ = (string)validatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORIES][GIT_PAGE_INFO][GIT_END_CURSOR];
            string stringQueryNextPage = string `{"{{GIT_VARIABLES}}":{"{{GIT_ORGANIZATION}}":"{{organization}}","{{GIT_END_CURSOR}}":"{{endCursor}}"},"{{GIT_QUERY}}":"{{GET_REPOSITORIES_NEXT_PAGE}}"}`;
            var queryNextPage, _ = <json>stringQueryNextPage;
            request = {};
            constructRequest(request, queryNextPage);
        }
    }

    return openPullRequestsArray, updateError;
}

//*****************************************************************
// DATABASE FUNCTIONS
//*****************************************************************

@Description {value:"Detele table content if exist or create table in database if not"}
@Return {value:"OpenPRUpdateError: Error"}
public function initializeTable () (OpenPRUpdateError) {
    endpoint<sql:ClientConnector> sqlClient {
        sqlHttpClient;
    }

    OpenPRUpdateError updateError;

    try {
        string responseDelete = <string>sqlClient.update("TRUNCATE openPullRequestsTable", null);
        log:printInfo("Database existed table deleted - status: " + responseDelete);
        logFile:logInfo("Database existed table deleted - status: " + responseDelete, runtime:getCallStack()[1].packageName);
    } catch (error errDelete) {
        log:printInfo("Error at deteting database table - Given table not found");
        try {
            string responseCreate = <string>sqlClient.update("CREATE TABLE openPullRequestsTable
                                                                           (id INT AUTO_INCREMENT,
                                                                            productName VARCHAR(255),
                                                                            repository VARCHAR(255),
                                                                            prTitle VARCHAR(255),
                                                                            gitId VARCHAR(255),
                                                                            organization  VARCHAR(255),
                                                                            durationWeeks VARCHAR(255),
                                                                            durationDays INT,
                                                                            prStatus VARCHAR(255),
                                                                            prURL VARCHAR(255),
                                                                            lastCommitDay VARCHAR(255),
                                                                            PRIMARY KEY (id))", null);
            log:printInfo("New database table created - status: " + responseCreate);
            logFile:logInfo("New database table created - status: " + responseCreate, runtime:getCallStack()[1].packageName);
        } catch (error errCreate) {
            updateError = {message:["Error at creating new database table - sql client connector: " + errCreate.message]};
            sqlClient.close();
        }
    }

    return updateError;
}

@Description {value:"Get wso2 product name for repository"}
@Param {value:"repository: Repository name"}
@Return {value:"string: Name of the wso2 product"}
@Return {value:"OpenPRUpdateError: Error"}
public function getProductName (string repository) (string, OpenPRUpdateError) {
    endpoint<sql:ClientConnector> sqlClient {
        sqlHttpClient;
    }

    string productName;
    table productTable;
    OpenPRUpdateError updateError;

    sql:Parameter[] params = [];
    sql:Parameter paraRepository = {sqlType:sql:Type.VARCHAR, value:repository};
    params = [paraRepository];

    try {
        productTable = sqlClient.select("SELECT * FROM JNKS_PRODUCT WHERE RepoName = ?", params, null);
    } catch (error errDatabase) {
        updateError = {message:["Error at retrieving data from database table - sql client connector: " + errDatabase.message]};
        sqlClient.close();
        return null, updateError;
    }

    var productTableJson, err = <json>productTable;
    if (err != null) {
        updateError = {message:["Error at json conversion - Product Name table to Product Name json: " + err.message]};
        sqlClient.close();
        return null, updateError;
    }

    if (lengthof productTableJson != 0) {
        var productString, err = (string)productTableJson[DB_INDEX_ZERO][DB_PRODUCT_NAME_COLUMN];
        productName = productString;
        if (err != null) {
            updateError = {message:["Error at string conversion - Product Name json to Product Name string: " + err.message]};
            return null, updateError;
        }
    } else {
        productName = "unknown";
    }

    return productName, updateError;
}

@Description {value:"Store pull request data in database."}
@Param {value:"pullRequestArray: Array of open pull requests"}
@Return {value:"OpenPRUpdateError: Error"}
public function insertOpenPullRequestsDatabase (PullRequest[] openPullRequestArray) (OpenPRUpdateError) {
    endpoint<sql:ClientConnector> sqlClient {
        sqlHttpClient;
    }

    int durationDays; int count = 1;
    string durationWeeks;
    string productName;
    string statusDuration;
    OpenPRUpdateError updateError;
    sql:Parameter[] params;

    log:printInfo("Received " + <string>lengthof openPullRequestArray + " open pull requests");
    logFile:logInfo("Received " + <string>lengthof openPullRequestArray + " open pull requests", runtime:getCallStack()[1].packageName);

    foreach openPullRequest in openPullRequestArray {
        var openPullRequestJson, err = <json>openPullRequest;
        if (err != null) {
            updateError = {message:["Error at json conversion - Product Name table to Product Name json: " + err.message]};
            return updateError;
        }

        //calculate open duration of the pull request
        durationDays, statusDuration, updateError = calOpenDuration(openPullRequestJson[GIT_CREATED_AT].toString());
        if (updateError != null) {
            return updateError;
        }

        durationWeeks = <string>(durationDays / 7);

        //choose product name for each repository
        productName, updateError = getProductName(openPullRequestJson[GIT_REPOSITORY_NAME].toString());
        if (updateError != null) {
            return updateError;
        }

        try {

            string title = openPullRequestJson[GIT_PULL_REQUEST_TITLE].toString();
            title = title.replace("…", ".");
            sql:Parameter paraProduct = {sqlType:sql:Type.VARCHAR, value:productName};
            sql:Parameter paraRepository = {sqlType:sql:Type.VARCHAR, value:openPullRequestJson[GIT_REPOSITORY_NAME].toString()};
            sql:Parameter paraTitle = {sqlType:sql:Type.VARCHAR, value:title};
            sql:Parameter paraGitId = {sqlType:sql:Type.VARCHAR, value:openPullRequestJson[GIT_PULL_REQUEST_AUTHOR][GIT_PULL_REQUEST_LOGIN].toString()};
            sql:Parameter paraOrganization = {sqlType:sql:Type.VARCHAR, value:openPullRequestJson[GIT_ORGANIZATION].toString()};
            sql:Parameter paraDurationWeeks = {sqlType:sql:Type.VARCHAR, value:durationWeeks};
            sql:Parameter paraDurationDays = {sqlType:sql:Type.INTEGER, value:durationDays};
            sql:Parameter paraDurationStatus = {sqlType:sql:Type.VARCHAR, value:statusDuration};
            sql:Parameter paraUrl = {sqlType:sql:Type.VARCHAR, value:openPullRequestJson[GIT_PULL_REQUEST_URL].toString()};
            sql:Parameter paraLastCommittedDay = {sqlType:sql:Type.VARCHAR, value:openPullRequestJson[GIT_LAST_COMMITTED_DATE].toString()};   //special
            params = [paraProduct, paraRepository, paraTitle, paraGitId, paraOrganization, paraDurationWeeks, paraDurationDays, paraDurationStatus, paraUrl, paraLastCommittedDay];

        } catch (error errAccessData) {
            updateError = {message:["Error at retrieving data from open pull request json - sql parameter declaration: " + errAccessData.message]};
            sqlClient.close();
            return updateError;
        }
        try {
            string response = <string>sqlClient.update("INSERT INTO openPullRequestsTable (productName,repository,prTitle,gitId,organization,durationWeeks,durationDays,prStatus,prURL,lastCommitDay) VALUES (?,?,?,?,?,?,?,?,?,?)", params);
            log:printInfo("Database updated with " + response + " row. Total no of rows:" + <string>count + " " + productName + " " + openPullRequestJson[GIT_REPOSITORY_NAME].toString());
            logFile:logInfo("Database updated with " + response + " row. Total no of rows:" + <string>count, runtime:getCallStack()[1].packageName);
            count = count + 1;
        } catch (error errInsert) {
            updateError = {message:["Error at inserting data to database table - sql client connector: " + errInsert.message]};
            sqlClient.close();
            return updateError;
        }
    }

    return updateError;
}

//****************************************************************
//Date and Time Functions
//***************************************************************


@Description {value:"Calculate open duration of pull request."}
@Param {value:"createdDate: Pull request created date"}
@Return {value:"int: Duration in days"}
@Return {value:"string: Status for late or not"}
@Return {value:"OpenPRUpdateError: Error"}
public function calOpenDuration (string prCreatedDate) (int, string, OpenPRUpdateError) {

    int createdYear;
    int createdMonth;
    int createdDay;
    int presentYear;
    int presentMonth;
    int presentDay;
    int daysDuration;
    string statusDuration;
    OpenPRUpdateError updateError;

    time:Time presentTime = time:currentTime();
    presentYear, presentMonth, presentDay = presentTime.getDate();

    time:Time createdTime = time:parse(prCreatedDate, "yyyy-MM-dd'T'HH:mm:ss'Z'");
    createdYear, createdMonth, createdDay = createdTime.getDate();

    try {
        daysDuration = (calTotalDays(presentYear, presentMonth, presentDay)) - (calTotalDays(createdYear, createdMonth, createdDay));
    } catch (error errTime) {
        updateError = {message:["Error at calculating total days from open pull request created date:  " + errTime.message]};
        daysDuration = -1;
        statusDuration = "not defined";
    }
    if (daysDuration >= 0 && (calTotalDays(createdYear, createdMonth, createdDay)) > 0) {
        statusDuration = filterDuration(daysDuration);
    } else {
        updateError = {message:["Open pull request created date is not valid"]};
        daysDuration = -1;
        statusDuration = "not defined";
    }

    return daysDuration, statusDuration, updateError;
}

//>>>>>>>
public function updateProductTable () (OpenPRUpdateError) {
    endpoint<sql:ClientConnector> sqlClient {
        sqlHttpClient;
    }

    sql:Parameter[] params;
    json jsonJNKSProductArray;
    OpenPRUpdateError updateError;

    jsonJNKSProductArray, updateError = getJNKSData();
    if (updateError != null) {
        return updateError;
    }

    try {
        string responseDelete = <string>sqlClient.update("TRUNCATE product", null);
        log:printInfo("Database JNKS existed table deleted - status: " + responseDelete);
        logFile:logInfo("Database JNKS existed table deleted - status: " + responseDelete, runtime:getCallStack()[1].packageName);
    } catch (error errDelete) {
        log:printError("Error at deteting database JNKS table - Given table not found");
        logFile:logError("Error at deteting database JNKS table - Given table not found : " + errDelete.message, runtime:getCallStack()[1].packageName);
    }


    foreach item in jsonJNKSProductArray {
        try {
            sql:Parameter paraProduct = {sqlType:sql:Type.VARCHAR, value:item["Product"].toString()};
            sql:Parameter paraRepository = {sqlType:sql:Type.VARCHAR, value:item["Component"].toString()};
            params = [paraProduct, paraRepository];

            string response = <string>sqlClient.update("INSERT INTO product (Product,RepoName) VALUES (?,?)", params);

        } catch (error errInsert) {
            updateError = {message:["Error at inserting data to database JNKS product table - sql client connector: " + errInsert.message]};
            sqlClient.close();
            return updateError;
        }
    }
    log:printInfo("JNKS Update status: DONE");
    return updateError;

}

