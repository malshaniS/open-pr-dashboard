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

import ballerina.net.http;
import ballerina.log;
import ballerina.config;
import org.wso2.github.logFile;
import ballerina.runtime;
import ballerina.data.sql;
import ballerina.io;

@Description {value:"Construct the request headers"}
@Param {value:"request: The http request object"}
@Param {value:"query: GraphQL API query"}
function constructRequest (http:OutRequest request, json query) {

    request.removeAllHeaders();
    request.addHeader("Authorization", "Bearer " + GIT_ACCESS_TOKEN);
    request.setJsonPayload(query);

}

@Description {value:"Validate the http response"}
@Param {value:"http:InResponse: The http response object"}
@Param {value:"validateComponent: Component name for validation"}
@Return {value:"json: The JSON payload in the response"}
@Return {value:"OpenPRUpdateError: Error"}
function validateResponse (http:InResponse response, string validateComponent) (json, OpenPRUpdateError) {

    json responsePayload;
    OpenPRUpdateError updateError;

    try {
        responsePayload = response.getJsonPayload();
        string[] payLoadKeys = responsePayload.getKeys();

        //Check all the keys in the payload to see if an error object is returned.
        foreach key in payLoadKeys {
            if (GIT_ERRORS.equalsIgnoreCase(key)) {
                string[] errors = [];
                var errorList, _ = (json[])responsePayload[GIT_ERRORS];
                int i = 0;
                foreach singleError in errorList {
                    errors[i], _ = (string)singleError[GIT_MESSAGE];
                    i = i + 1;
                }
                updateError = {message:errors, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
                return null, updateError;
            }
        }

        //If no error object is returned, then check if the response contains the requested data.
        if (null == responsePayload[GIT_DATA][GIT_ORGANIZATION][validateComponent]) {
            string[] errorMessage = [GIT_ERROR_WHILE_RETRIEVING_DATA];
            responsePayload = null;
            updateError = {message:errorMessage, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
        }
    } catch (error e) {
        string[] errorMessage = [GIT_ERROR_WHILE_RETRIEVING_PAYLOAD];
        responsePayload = null;
        updateError = {message:errorMessage, statusCode:response.statusCode, reasonPhrase:response.reasonPhrase, server:response.server};
    }

    return responsePayload, updateError;
}

@Description {value:"Get last committed date of the repository"}
@Param {value:"repositoryJson: The repository data json"}
@Return {value:"string: The last commited date"}
function selectLastCommittedDate (json repositoryJson) (string) {

    string lastCommittedDate;

    try {
        lastCommittedDate = repositoryJson[GIT_REFERENCE][GIT_TARGET][GIT_HISTORY][GIT_EDGES][GIT__LAST_COMMITTED_DATE_INDEX_ZERO][GIT_NODE][GIT_COMMITTED_DATE].toString();
        if (repositoryJson[GIT_REFERENCE][GIT_TARGET][GIT_HISTORY][GIT_EDGES][GIT__LAST_COMMITTED_DATE_INDEX_ZERO][GIT_NODE][GIT_LAST_COMMITTED_DATE_TITLE].toString() == GIT_LAST_COMMITTED_DATE_AVOID_TITLE) {
            lastCommittedDate = repositoryJson[GIT_REFERENCE][GIT_TARGET][GIT_HISTORY][GIT_EDGES][GIT__LAST_COMMITTED_DATE_INDEX_THIRD][GIT_NODE][GIT_COMMITTED_DATE].toString();
        }
        lastCommittedDate = lastCommittedDate.split("T")[0];

    } catch (error e) {
        lastCommittedDate = "not defined";
    }

    return lastCommittedDate;
}

@Description {value:"Calculate total days from begining for given date"}
@Param {value:"year: Year of the date"}
@Param {value:"month: Month of the date"}
@Param {value:"day: Day of the date"}
@Return {value:"int: Number of days"}
function calTotalDays (int year, int month, int day) (int) {
    if (year > 0 && month > 0 && day > 0 && month < 13 && day < 32) {
        month = (month + 9) % 12;
        year = year - month / 10;
        return (365 * year + year / 4 - year / 100 + year / 400 + (month * 306 + 5) / 10 + (day - 1));
    } else {
        log:printError("Error at calculating total days from given date: given date values are not acceptable");
        logFile:logError("Error at calculating total days from given date: given date values are not acceptable", runtime:getCallStack()[1].packageName);
        return 0;
    }
}

@Description {value:"Check the status of open duration"}
@Param {value:"durationDays: Number of days pull rquest is open"}
@Return {value:"string: NStatus of open duration"}
function filterDuration (int durationDays) (string) {
    if (durationDays > 14) {
        return "Late";
    }
    else {
        return "Normal";
    }
}

@Description {value:"Get databse port value from configuration file"}
@Return {value:"int: Database Port Number"}
function getDatabasePort () (int) {
    string dbPort = config:getGlobalValue("DB_PORT");
    var IntDbPort, _ = <int>dbPort;
    return IntDbPort;
}

//>>>>>>>>>>>>>>

function getJNKSData () (json, OpenPRUpdateError) {
    endpoint<sql:ClientConnector> sqlJNKSClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, JNKS_DB_HOST, JNKS_DB_PORT, (JNKS_DB_NAME + "?useSSL=false"), JNKS_DB_USER_NAME, JNKS_DB_PASSWORD, {maximumPoolSize:5});
    }

    table JNKSProductTable;
    OpenPRUpdateError updateError;

    try {
        JNKSProductTable = sqlJNKSClient.select("select * from JNKS_COMPONENTPRODUCT", null, null);
    } catch (error errDatabase) {
        updateError = {message:["Error at retrieving data from database table - sql JNKS client connector: " + errDatabase.message]};
        sqlJNKSClient.close();
        return null, updateError;
    }
    var jsonJNKSProductArray, err = <json>JNKSProductTable;
    if (err != null) {
        updateError = {message:["Error at json conversion - JNKS Products table to JNKS Products json: " + err.message]};
        sqlJNKSClient.close();
        return null, updateError;
    }

    if (jsonJNKSProductArray[0] == null) {
        updateError = {message:["No entries avaliable"]};
    }
    sqlJNKSClient.close();
    return jsonJNKSProductArray, updateError;
}