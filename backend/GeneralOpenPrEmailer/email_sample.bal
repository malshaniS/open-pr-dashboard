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

package GeneralOpenPrEmailer;

import ballerina.io;
import org.wso2.github.emailer;
import ballerina.time;
import org.wso2.github.logFile;
import ballerina.runtime;
import ballerina.config;

const int LATE_THRESHOLD = 0;

public function main (string[] args) {

    string sender = config:getGlobalValue("ENG_GRP_EMAIL_SENDER");
    sender = sender.subString(1,(lengthof sender)-1);
    string receiver = config:getGlobalValue("ENG_GRP_EMAIL_RECEIVER");
    receiver = receiver.subString(1,(lengthof receiver)-1);
    string cc = config:getGlobalValue("ENG_GRP_EMAIL_CC");
    cc = cc.subString(1,(lengthof cc)-1);
    string title = config:getGlobalValue("ENG_GRP_EMAIL_EMAIL_TITLE");
    title = title.subString(1,(lengthof title)-1);
    string orgs = config:getGlobalValue("ENG_GRP_EMAIL_ORGS");
    string[] orgArr= orgs.split(";");
    if (lengthof orgArr == 0){
        logFile:logError("organizations not found", runtime:getCallStack()[1].packageName);
        return;
    }

    logFile:logDate("GeneralOpenPrEmailer");

    string accessToken;
    int year;
    int month;
    int day;

    emailer:GmailSendError errEmail;
    emailer:GmailSendError accessError;

    time:Time time = time:currentTime();
    year, month, day = time.getDate();

    var strYear = <string>year;
    var strMonth = <string>month;
    var strDay = <string>day;

    title = title + strDay +"-"+strMonth+"-"+strYear;

    emailer:ProductSummaryRow[] resProductSummary;
    resProductSummary, errEmail = emailer:generateProductSummary();
    if (errEmail != null) {
        io:println(errEmail);
        logFile:logError(errEmail.message[0],runtime:getCallStack()[1].packageName);
        return;
    }

    emailer:RepoSummaryRow[] repoSummary;
    repoSummary, errEmail = emailer:generateRepositorySummary();
    string tableContent="";

    string[] repoArr=[];
    int i = 0;
    boolean flag = false;

    foreach repository in repoSummary {
        if (repository["openPrCount"] > 2){
            repoArr[0] = repository["repository"];
            emailer:LateOpenPullRequest[] resPrTable;
            resPrTable, errEmail = emailer:generateLateOpenPrTable(LATE_THRESHOLD, orgArr, repoArr);

            if (errEmail != null) {
                io:println(errEmail);
                logFile:logError(errEmail.message[0], runtime:getCallStack()[1].packageName);
                return;
            }

            if ((lengthof resPrTable) != 0) {
                tableContent = tableContent + emailer:generateHtmlTableContent(resPrTable, repository["repository"]);
            }
        }else {
            repoArr[i] = repository["repository"];
            i=i+1;
            flag = true;
        }
    }

    if(flag){
        emailer:LateOpenPullRequest[] resPrTable;
        resPrTable, errEmail = emailer:generateLateOpenPrTable(LATE_THRESHOLD, orgArr, repoArr);

        if (errEmail != null) {
            io:println(errEmail);
            logFile:logError(errEmail.message[0], runtime:getCallStack()[1].packageName);
            return;
        }

        if ((lengthof resPrTable) != 0) {
            tableContent = tableContent + emailer:generateHtmlTableContent(resPrTable, "others");
        }
    }

    string summaryContent = emailer:generateHtmlSummaryContent(resProductSummary);
    string emailContent = emailer:generateGroupEmail(summaryContent, tableContent);

    accessToken, accessError = emailer:getGmailNewAccessToken();

    if (null == accessError) {
        emailer:GmailSendError sendGroupError = emailer:sendMail(accessToken, receiver, sender, cc, title, emailContent);
        if (sendGroupError != null) {
            io:println(sendGroupError);
            logFile:logError(sendGroupError.message[0],runtime:getCallStack()[1].packageName);
            return;
        }

        //emailer:GmailSendError sendPrivateError = emailer:sendPrivateEmails(accessToken);
        //if (sendPrivateError != null) {
        //    io:println(sendPrivateError);
        //    logFile:logError(sendPrivateError.message[0],runtime:getCallStack()[1].packageName);
        //    return;
        //}

    } else {
        io:println(accessError);
        logFile:logError(accessError.message[0],runtime:getCallStack()[1].packageName);
    }
}
