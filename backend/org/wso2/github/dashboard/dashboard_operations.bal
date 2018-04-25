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

package org.wso2.github.dashboard;

import ballerina.data.sql;
import ballerina.config;

const string DB_HOST = config:getGlobalValue("DB_HOST");
const string DB_NAME = config:getGlobalValue("DB_NAME");
const string DB_USER_NAME = config:getGlobalValue("DB_USER_NAME");
const string DB_PASSWORD = config:getGlobalValue("DB_PASSWORD");
const int DB_PORT = getDatabasePort();

@Description {value:"Select open pull requests from database."}
@Return {value:"OpenPullRequest[]: Array of open pull requests with details"}
@Return {value:"DashboardServerError: Error"}
public function fetchOpenPullRequests (string productName) (OpenPullRequest[], DashboardServerError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }

    table OpenPrTable;
    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.VARCHAR, value:productName};
    params = [para1];

    OpenPullRequest[] OpenPullRequestArray = [];
    DashboardServerError dashboardError;

    if(productName == "undefined" || productName == "All"){
        try {
            OpenPrTable = sqlClient.select("SELECT * FROM openPullRequestsTable ORDER BY durationDays DESC", null, null);
        } catch (error errDashboard) {
            dashboardError = {message:["Sql connector - select operation error: " + errDashboard.message]};
            sqlClient.close();
            return null, dashboardError;
        }
    }
    else{
        try {
            OpenPrTable = sqlClient.select("SELECT * FROM openPullRequestsTable WHERE productName = ? ORDER BY durationDays DESC", params, null);
        } catch (error errDashboard) {
            dashboardError = {message:["Sql connector - select operation error: " + errDashboard.message]};
            sqlClient.close();
            return null, dashboardError;
        }
    }


    var jsonOpenPrArray, err = <json>OpenPrTable;
    if (err != null) {
        dashboardError = {message:["Json conversion error - open pr detail select operation: " + err.message]};
        sqlClient.close();
        return null, dashboardError;
    }

    int i = 0;
    foreach OpenPr in jsonOpenPrArray {
        OpenPullRequestArray[i], err = <OpenPullRequest>OpenPr;
        if (err != null) {
            dashboardError = {message:["Open pull Request struct conversion error - open pr fetching: " + err.message]};
            sqlClient.close();
            return null, dashboardError;
        }
        i = i + 1;

    }

    sqlClient.close();
    return OpenPullRequestArray, dashboardError;
}

@Description {value:"Count number of open pull requests and number of late open pull requests from database"}
@Return {value:"int: Number of open pull requests"}
@Return {value:"int: Number of late open pull requests"}
@Return {value:"DashboardServerError: Error"}
public function countOpenPullRequests () (int, int, DashboardServerError) {
    endpoint<sql:ClientConnector> sqlClient {
        create sql:ClientConnector(
        sql:DB.MYSQL, DB_HOST, DB_PORT, (DB_NAME + "?useSSL=false"), DB_USER_NAME, DB_PASSWORD, {maximumPoolSize:5});
    }

    sql:Parameter[] params = [];
    sql:Parameter para1 = {sqlType:sql:Type.INTEGER, value:OPEN_PR_LATE_THRESHOLD};
    params = [para1];

    table lateOpenPrCountTable;
    table OpenPrCountTable;
    int openPullRequestCount = 0;
    int lateOpenPullRequestCount = 0;
    DashboardServerError dashboardError;

    try {
        lateOpenPrCountTable = sqlClient.select("SELECT COUNT(*) as lateOpenPrCount FROM openPullRequestsTable WHERE durationDays > ? ", params, null);
    } catch (error errDashboard) {
        dashboardError = {message:["Error at selecting count of late open pull requests from database table - sql client connector: " + errDashboard.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }

    var jsonLateOpenPrCount, err = <json>lateOpenPrCountTable;
    if (err != null) {
        dashboardError = {message:["Error at json conversion - Late Open PR Count table to  Late Open PR Count json: " + err.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }
    lateOpenPullRequestCount, err = (int)jsonLateOpenPrCount[DASHBOARD_INDEX_ZERO]["lateOpenPrCount"];
    if (err != null) {
        dashboardError = {message:["Error at int conversion - Late Open PR Count json to  Late Open PR Count int: " + err.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }

    try {
        OpenPrCountTable = sqlClient.select("SELECT COUNT(*) as OpenPrCount FROM openPullRequestsTable", null, null);
    } catch (error errDashboard) {
        dashboardError = {message:["Error at selecting count of open pull requests from database table - sql client connector: " + errDashboard.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }

    var jsonOpenPrCount, _ = <json>OpenPrCountTable;
    if (err != null) {
        dashboardError = {message:["Error at json conversion - Open PR Count table to Open PR Count json: " + err.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }
    openPullRequestCount, _ = (int)jsonOpenPrCount[DASHBOARD_INDEX_ZERO]["OpenPrCount"];
    if (err != null) {
        dashboardError = {message:["Error at int conversion - Open PR Count json to Open PR Count int: " + err.message]};
        sqlClient.close();
        return 0, 0, dashboardError;
    }

    sqlClient.close();
    return openPullRequestCount, lateOpenPullRequestCount, dashboardError;
}

@Description {value:"Get databse port value from configuration file"}
@Return {value:"int: Database Port Number"}
function getDatabasePort () (int) {
    string dbPort = config:getGlobalValue("DB_PORT");
    var IntDbPort,_ = <int>dbPort;
    return IntDbPort;
}