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

package org.wso2.github.emailer;

import ballerina.data.sql;
import ballerina.log;
import ballerina.config;
import ballerina.net.http;
import org.wso2.github.logFile;
import ballerina.runtime;


const string DB_HOST = config:getGlobalValue("DB_HOST");
const string DB_NAME = config:getGlobalValue("DB_NAME");
const string DB_USER_NAME = config:getGlobalValue("DB_USER_NAME");
const string DB_PASSWORD = config:getGlobalValue("DB_PASSWORD");
const int DB_PORT = getDatabasePort();

@Description {value:"Generate product summary from database"}
@Return {value:"SummaryRow[]: Array of summary for open PRs count and product"}
@Return {value:"GmailSendError: Error"}
public function generateProductSummary () (ProductSummaryRow[], GmailSendError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:OPEN_PR_LATE_THRESHOLD};
    params = [para1];

    table summaryTable;
    ProductSummaryRow[] openPrSummary = [];
    GmailSendError gmailError;

    try {
        summaryTable = sqlClient.select("SELECT productName, COUNT(*) as openPrCount FROM openPullRequestsTable WHERE durationDays > ? GROUP BY productName ORDER BY COUNT(*) DESC", params, null);
    } catch (error errDatabase) {
        gmailError = {message:["Error at selecting product summary data from database table - sql client connector: " + errDatabase.message]};
        sqlClient.close();
        return null, gmailError;
    }
    var jsonOpenPrSummary, err = <json>summaryTable;
    if (err != null) {
        gmailError = {message:["Error at json conversion - Summary Table table to Summary table json: " + err.message]};
        sqlClient.close();
        return null, gmailError;
    }
    int i = 0;
    foreach row in jsonOpenPrSummary {
        openPrSummary[i], err = <ProductSummaryRow>row;
        if (err != null) {
            gmailError = {message:["Error at Product Summary Row struct conversion - Summary Row json to Summary Row struct: " + err.message]};
            sqlClient.close();
            return null, gmailError;
        }
        i = i + 1;
    }

    sqlClient.close();
    return openPrSummary, gmailError;
}

@Description {value:"Select late open pull requests from database"}
@Return {value:"LateOpenPullRequest[]: Array of late open pull request details"}
@Return {value:"GmailSendError: Error"}
public function generateLateOpenPrTable (int openPrThreshold, string[] orgArray ,string[] repoArr) (LateOpenPullRequest[], GmailSendError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:openPrThreshold};
    params = [para1];

    table lateOpenPrTable;
    LateOpenPullRequest[] lateOpenPullRequestArray = [];
    GmailSendError gmailError;

    string sqlRepoQuery = "";
    foreach repo in repoArr{
        sqlRepoQuery = sqlRepoQuery + " repository = '" + repo + "' OR";
    }
    sqlRepoQuery = sqlRepoQuery.subString(0,(lengthof sqlRepoQuery)-2);


    string sqlQuery = "SELECT * FROM openPullRequestsTable WHERE durationDays > ? AND (" + sqlRepoQuery +" ) AND (";
    foreach org in orgArray{
        sqlQuery = sqlQuery + " organization = '" + org + "' OR";
    }
    sqlQuery = sqlQuery.subString(0,(lengthof sqlQuery)-2) + ") ORDER BY durationDays DESC";

    try {
        lateOpenPrTable = sqlClient.select(sqlQuery, params, null);
    } catch (error errDatabase) {
        gmailError = {message:["Error at selecting late open pull requests data from database table - sql client connector: " + errDatabase.message]};
        sqlClient.close();
        return null, gmailError;
    }
    var jsonLateOpenPrArray, err = <json>lateOpenPrTable;
    if (err != null) {
        gmailError = {message:["Error at json conversion - Late Open Pull Request table to Late Open Pull Request json: " + err.message]};
        sqlClient.close();
        return null, gmailError;
    }
    int i = 0;
    foreach lateOpenPr in jsonLateOpenPrArray {
        lateOpenPullRequestArray[i], err = <LateOpenPullRequest>lateOpenPr;
        if (err != null) {
            gmailError = {message:["Error at Late Open Pull Request struct conversion - Late Open Pull Request json to Late Open Pull Request struct: " + err.message]};
            sqlClient.close();
            return null, gmailError;
        }
        i = i + 1;
    }

    sqlClient.close();
    return lateOpenPullRequestArray, gmailError;
}

@Description {value:"Get email address of github user"}
@Param {value:"gitId: Github id of the user"}
@Return {value:"string: Email address of the user"}
@Return {value:"GmailSendError: Error"}
public function getEmailAddress (string gitID) (string, GmailSendError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }

    sql:Parameter[] params = [];
    sql:Parameter paraGitID = {sqlType:sql:Type.VARCHAR, value:gitID};
    string emailAddress;
    table emailTable;
    params = [paraGitID];
    GmailSendError gmailError;

    try {
        emailTable = sqlClient.select("SELECT * FROM MAIL_TABLE WHERE GITID = ?", params, null);
    } catch (error errDatabase) {
        gmailError = {message:["Error at selecting user emails data from database table - sql client connector: " + errDatabase.message]};
        sqlClient.close();
        return null, gmailError;
    }

    var emailTableJson, err = <json>emailTable;
    if (err != null) {
        gmailError = {message:["Error at json conversion - Email table to Email json: " + err.message]};
        sqlClient.close();
        return null, gmailError;
    }


    if (lengthof emailTableJson != 0) {
        var emailString, err = (string)emailTableJson[DB_INDEX_ZERO][DB_MAIL_WSO2MAIL_COLUMN];
        emailAddress = emailString;
        if (err != null) {
            gmailError = {message:["Error at string conversion - Email json to Email string: " + err.message]};
            sqlClient.close();
            return null, gmailError;
        }
    } else {
        emailAddress = null;
    }

    sqlClient.close();
    return emailAddress, gmailError;
}

//***********************************************************
//HTML content generate functions
//***********************************************************


@Description {value:"Generate html content for open pull request-product summary in email."}
@Param {value:"ProductSummaryRow[]: Array of product summary for each product"}
@Return {value:"String: html content for open pull request-product summary"}
public function generateHtmlSummaryContent (ProductSummaryRow[] openPrSummary) (string) {

    string htmlSummaryContent = "<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"100%\">" +
                                "<tr>" +
                                "<td width=\"70%\" align=\"center\" color=\"#044767\" bgcolor=\"#cecece\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 15px; font-weight: 600; line-height: 20px; padding: 10px;\">" +
                                "WSO2 Product" +
                                "</td>" +
                                "<td width=\"30%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 15px; font-weight: 600; line-height: 20px; padding: 10px;\">" +
                                "No of Open PRs" +
                                "</tr>";

    boolean toggleFlag = true;
    string backgroundColor;

    foreach row in openPrSummary {
        if (toggleFlag) {
            backgroundColor = BACKGROUND_COLOR_WHITE;
            toggleFlag = false;
        }
        else {
            backgroundColor = BACKGROUND_COLOR_GRAY;
            toggleFlag = true;
        }
        htmlSummaryContent = htmlSummaryContent + "<tr>";
        htmlSummaryContent = htmlSummaryContent + "<td width=\"" + "70%" + "\" align=\"left\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 15px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                             row["productName"];
        htmlSummaryContent = htmlSummaryContent + "<td width=\"" + "30%" + "\" align=\"center\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 15px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                             <string>row["openPrCount"];
    }
    htmlSummaryContent = htmlSummaryContent + "</table>";

    log:printInfo("Html product summary for group email generated successfully.");
    logFile:logInfo("Html product summary for group email generated successfully.",runtime:getCallStack()[1].packageName);
    return htmlSummaryContent;
}

@Description {value:"Generate html content for open pull request detailed table in email"}
@Param {value:"LateOpenPullRequest[]: Array of product summary for each product"}
@Return {value:"String: html content for open pull request detailed table"}
public function generateHtmlTableContent (LateOpenPullRequest[] openPrTable, string repository) (string) {

    string htmlTableContent = "<div width=\"100%\">"+
                              "<br/><h2 style=\"font-family: Helvetica, Open Sans, Arial, sans-serif; font-size: 20px; font-weight: 600; line-height:24px; color: #121212; margin: 0;\" align=\"center\">" +
                              repository +
                              "</h2>" +
                              "<table align=\"center\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" width=\"95%\">" +
                              "<tr>" +
                              " <td width=\"12%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "WSO2 Product" +
                              " </td>" +
                              "<td width=\"28%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "Title" +
                              "</td>" +
                              "<td width=\"30%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "URL" +
                              "</td>" +
                              "<td width=\"10%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "Git ID" +
                              "</td>" +
                              " <td width=\"6%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "Open Days" +
                              "</td>" +
                              "<td width=\"6%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "Open Weeks" +
                              "</td>" +
                              "<td width=\"8%\" align=\"center\" color=\"#044767\" bgcolor=\"#bebebe\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 800; line-height: 20px; padding: 10px;\">" +
                              "Last Commited at" +
                              "</td>" +
                              "</tr>";

    boolean toggleFlag = true;
    string backgroundColor;

    foreach row in openPrTable {
        if (toggleFlag) {
            backgroundColor = BACKGROUND_COLOR_WHITE;
            toggleFlag = false;
        }
        else {
            backgroundColor = BACKGROUND_COLOR_GRAY;
            toggleFlag = true;
        }

        htmlTableContent = htmlTableContent + "<tr>";
        htmlTableContent = htmlTableContent + "<td width=\"" + "12%" + "\" align=\"center\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["productName"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "28%" + "\" align=\"left\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["prTitle"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "30%" + "\" align=\"left\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["prURL"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "10%" + "\" align=\"left\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["gitId"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "6%" + "\" align=\"center\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           <string>row["durationDays"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "6%" + "\" align=\"center\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["durationWeeks"];
        htmlTableContent = htmlTableContent + "<td width=\"" + "8%" + "\" align=\"left\" bgcolor=" + backgroundColor + " style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 20px; padding: 15px 10px 5px 10px;\">" +
                           row["lastCommitDay"];
    }
    htmlTableContent = htmlTableContent + "</table>" + "<p/><br/></div>";

    log:printInfo("Html open pr table for group email generated successfully. Repository : " + repository);
    logFile:logInfo("Html open pr table for group email generated successfully. Repository : " + repository ,runtime:getCallStack()[1].packageName);
    return htmlTableContent;
}

//*******************************************************
//Gmail API functions
//*******************************************************

@Description {value:"Construct the request headers"}
@Param {value:"request: The http request object"}
@Param {value:"stringRequestBody: Gmail API requst body"}
function constructAccessTokenRequest (http:OutRequest request, string stringRequestBody) {

    request.removeAllHeaders();
    request.setHeader("Content-Type", "application/x-www-form-urlencoded");
    request.setStringPayload(stringRequestBody);

}

@Description {value:"Construct the request headers"}
@Param {value:"request: The http request object"}
@Param {value:"accessToken: Gmail API access token"}
@Param {value:"jsonRequestBody: Gmail API request body"}
function constructSendMailRequest (http:OutRequest request, string accessToken, json jsonRequestBody) {

    request.removeAllHeaders();
    request.setHeader("Authorization", "Bearer " + accessToken);
    request.setHeader("Content-Type", "application/json");
    request.setJsonPayload(jsonRequestBody);

}

@Description {value:"Validate the http response"}
@Param {value:"http:InResponse: The http response object"}
@Param {value:"validateComponent: component that need validation"}
@Return {value:"json: The JSON payload in the response"}
@Return {value:"GmailSendError: Error"}
function validateResponse (http:InResponse response, string validateComponent) (json, GmailSendError) {

    json responsePayload;
    GmailSendError gmailError;

    try {
        responsePayload = response.getJsonPayload();
        string[] payLoadKeys = responsePayload.getKeys();
        //Check all the keys in the payload to see if an error object is returned.
        foreach key in payLoadKeys {
            if (GMAIL_ERRORS.equalsIgnoreCase(key)) {
                string[] errors = [];
                var errorList, _ = (json[])responsePayload[GMAIL_ERRORS];
                int i = 0;
                foreach singleError in errorList {
                    errors[i], _ = (string)singleError[GMAIL_MESSAGE];
                    i = i + 1;
                }
                gmailError = {message:errors, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
                return null, gmailError;
            }
        }
        //If no error object is returned, then check if the response contains the requested data.
        if (null == responsePayload[validateComponent]) {
            string[] errorMessage = [GMAIL_ERROR_WHILE_RETRIEVING_DATA];
            responsePayload = null;
            gmailError = {message:errorMessage, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
        }
    } catch (error e) {
        string[] errorMessage = [GMAIL_ERROR_WHILE_RETRIEVING_PAYLOAD];
        responsePayload = null;
        gmailError = {message:errorMessage, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
    }

    return responsePayload, gmailError;
}

@Description {value:"Get databse port value from configuration file"}
@Return {value:"int: Database Port Number"}
function getDatabasePort () (int) {
    string dbPort = config:getGlobalValue("DB_PORT");
    var IntDbPort,_ = <int>dbPort;
    return IntDbPort;
}


@Description {value:"Generate repository summary from database"}
@Return {value:"RepoSummaryRow[]: Array of repositories order by duration"}
@Return {value:"GmailSendError: Error"}
public function generateRepositorySummary () (RepoSummaryRow[], GmailSendError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }



    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:OPEN_PR_LATE_THRESHOLD};
    params = [para1];

    table summaryTable;
    RepoSummaryRow[] openPrSummary = [];
    GmailSendError gmailError;

    try {
        summaryTable = sqlClient.select("SELECT repository, COUNT(*) as openPrCount FROM openPullRequestsTable WHERE durationDays > ? GROUP BY repository ORDER BY COUNT(*) DESC", params, null);
    } catch (error errDatabase) {
        gmailError = {message:["Error at selecting product summary data from database table - sql client connector: " + errDatabase.message]};
        sqlClient.close();
        return null, gmailError;
    }
    var jsonOpenPrSummary, err = <json>summaryTable;
    if (err != null) {
        gmailError = {message:["Error at json conversion - Summary Table table to Summary table json: " + err.message]};
        sqlClient.close();
        return null, gmailError;
    }
    int i = 0;
    foreach row in jsonOpenPrSummary {
        openPrSummary[i], err = <RepoSummaryRow>row;
        if (err != null) {
            gmailError = {message:["Error at Product Summary Row struct conversion - Summary Row json to Summary Row struct: " + err.message]};
            sqlClient.close();
            return null, gmailError;
        }
        i = i + 1;
    }

    sqlClient.close();
    return openPrSummary, gmailError;
}