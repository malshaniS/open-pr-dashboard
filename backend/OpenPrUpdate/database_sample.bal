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

package OpenPrUpdate;

import org.wso2.github.githubDatabase;
import org.wso2.github.logFile;
import ballerina.io;
import ballerina.runtime;
import ballerina.config;



public function main (string[] args) {

    logFile:clearLogRecords(["01-01","04-01","07-01","10-01"]);
    logFile:logDate("OpenPrUpdate");

    string orgs = config:getGlobalValue("ORGANIZATIONS");
    string[] orgArr= orgs.split(";");
    if (lengthof orgArr == 0){
        logFile:logError("organizations not found", runtime:getCallStack()[1].packageName);
        return;
    }

    io:println("Update process started.");
    logFile:logInfo("Update process started.",runtime:getCallStack()[1].packageName);

    githubDatabase:PullRequest[] openPrData;
    githubDatabase:OpenPRUpdateError errGetData;

    githubDatabase:OpenPRUpdateError initializeError = githubDatabase:initializeTable();

    if (initializeError != null) {
        io:println(initializeError);
        logFile:logError(initializeError.message[0],runtime:getCallStack()[1].packageName);
        return;
    }

    //errGetData = githubDatabase:updateProductTable();
    //if (errGetData != null) {
    //    io:println(errGetData);
    //    logFile:logError(errGetData.message[0],runtime:getCallStack()[1].packageName);
    //    return;
    //}

    foreach organization in orgArr {
        //get data from organizations
        openPrData, errGetData = githubDatabase:getOpenPullRequests(organization);
        if (errGetData != null) {
            io:println(errGetData);
            logFile:logError(errGetData.message[0], runtime:getCallStack()[1].packageName);
            return;
        }
        errGetData = githubDatabase:insertOpenPullRequestsDatabase(openPrData);
        if (errGetData != null) {
            io:println(errGetData);
            logFile:logError(errGetData.message[0], runtime:getCallStack()[1].packageName);
            return;
        }
    }

    io:println("Update process finished successfully.");
    logFile:logInfo("Update process finished successfully.",runtime:getCallStack()[1].packageName);
}
