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

import ballerina.config;
import ballerina.net.http;
import ballerina.log;
import ballerina.util;
import ballerina.time;
import org.wso2.github.logFile;
import ballerina.runtime;

const string GMAIL_REFRESH_TOKEN = config:getGlobalValue("GMAIL_REFRESH_TOKEN");
const string GMAIL_CLIENT_ID = config:getGlobalValue("GMAIL_CLIENT_ID");
const string GMAIL_CLIENT_SECRET = config:getGlobalValue("GMAIL_CLIENT_SECRET");

@Description {value:"Generate access token for gmail API"}
@Return {value:"string: Access token"}
@Return {value:"GmailSendError: Error"}
public function getGmailNewAccessToken () (string, GmailSendError) {

    endpoint<http:HttpClient> gmailClient {
        create http:HttpClient(GMAIL_API_ACCESS_TOKEN_URL, {});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError httpError;
    GmailSendError gmailError;

    if (GMAIL_REFRESH_TOKEN == null || GMAIL_CLIENT_ID == null || GMAIL_CLIENT_SECRET == null) {
        gmailError = {message:["Error at identifing tokens: Refresh token or Client Id or Client secret can not be null."]};
        return null, gmailError;
    }

    string stringRequestBody = string `grant_type=refresh_token&client_id={{GMAIL_CLIENT_ID}}&client_secret={{GMAIL_CLIENT_SECRET}}&refresh_token={{GMAIL_REFRESH_TOKEN}}`;

    //construct headers for http request
    constructAccessTokenRequest(request, stringRequestBody);

    response, httpError = gmailClient.post("/token", request);
    if (httpError != null) {
        gmailError = {message:["Http error at generating new access token: " + httpError.message], statusCode:httpError.statusCode};
        return null, gmailError;
    }

    json validatedResponse;
    validatedResponse, gmailError = validateResponse(response, GMAIL_API_ACCESS_TOKEN);
    if (gmailError != null) {
        return null, gmailError;
    }

    var newAccessToken, err = (string)validatedResponse[GMAIL_API_ACCESS_TOKEN];
    if (err != null) {
        gmailError = {message:["Error at string conversion - Access Token json to Access Token string: " + err.message]};
        return null, gmailError;
    }

    log:printInfo("New Gmail access token genereted.");
    logFile:logInfo("New Gmail access token genereted.",runtime:getCallStack()[1].packageName);
    return newAccessToken, gmailError;
}

@Description {value:"Send email through gmail API."}
@Param {value:"accessToken: gmail API access token"}
@Param {value:"emailTo: email receiver address"}
@Param {value:"emailFrom: email sender address"}
@Param {value:"emailCc: email cc address"}
@Param {value:"emailSubject: email subject"}
@Param {value:"emailContent: email html content"}
@Return {value:"GmailSendError: Error"}
public function sendMail (string accessToken, string emailTo, string emailFrom, string emailCc, string emailSubject, string emailContent) (GmailSendError) {

    endpoint<http:HttpClient> gmailClient {
        create http:HttpClient(GMAIL_API_EMAIL_SEND_URL, {});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError httpError;
    GmailSendError gmailError;

    if (accessToken == null) {
        gmailError = {message:["Error at identifing access token: Access token is not found."]};
        return gmailError;
    }

    if (emailTo == null || emailFrom == null) {
        gmailError = {message:["Error at identifing email sender and receiver: sender email or receiver email can not be null."]};
        return gmailError;
    }

    string stringRequestBody = string `to:{{emailTo}}\nsubject:{{emailSubject}}\nfrom:{{emailFrom}}\ncc:{{emailCc}}\ncontent-type:text/html;charset=iso-8859-1\n` + string `\n{{emailContent}}\n`;

    //encode email content using base64 encode method
    string encodedRequestBody = util:base64Encode(stringRequestBody);
    encodedRequestBody = encodedRequestBody.replace("+", "-");
    encodedRequestBody = encodedRequestBody.replace("/", "_");
    json jsonRequestBody = {"raw":encodedRequestBody};

    //construct headers for http request
    constructSendMailRequest(request, accessToken, jsonRequestBody);
    response, httpError = gmailClient.post("/v1/users/me/messages/send", request);

    if (httpError != null) {
        gmailError = {message:[httpError.message], statusCode:httpError.statusCode};
        return gmailError;
    }

    json validatedResponse;
    validatedResponse, gmailError = validateResponse(response, GMAIL_LABEL_IDS);
    if (gmailError != null) {
        return gmailError;
    }

    var emailStatus, err = (string)validatedResponse[GMAIL_LABEL_IDS][GMAIL_INDEX_ZERO];
    if (err != null) {
        gmailError = {message:["Error at string conversion - Email status json to email status string: " + err.message]};
        return gmailError;
    }

    if (GMAIL_SENT.equalsIgnoreCase(emailStatus)) {
        log:printInfo("Email sent successfully.");
        logFile:logInfo("Email sent successfully.",runtime:getCallStack()[1].packageName);
        return gmailError;
    } else {
        log:printInfo("Email sent. Sent response from Gmail not found.");
        logFile:logInfo("Email sent. Sent response from Gmail not found.",runtime:getCallStack()[1].packageName);
        return gmailError;
    }
}

@Description {value:"Generate html based group email content."}
@Param {value:"htmlSummaryContent: html content for product summary"}
@Return {value:"htmlTableContent: html content for open pr table"}
@Return {value:"GmailSendError: Error"}
public function generateGroupEmail (string htmlSummaryContent, string htmlTableContent) (string) {

    int year;
    int month;
    int day;

    time:Time time = time:currentTime();
    year, month, day = time.getDate();
    string lastUpdatedDate = <string>(year + " : " + month + " : " + day);

    string groupEmailHtmlContent = GROUP_EMAIL_HTML_HEADER + htmlSummaryContent + GROUP_EMAIL_HTML_TABLE_TITLE + htmlTableContent + GROUP_EMAIL_HTML_UPDATED_DATE +lastUpdatedDate+ GROUP_EMAIL_HTML_FOOTER;
    return groupEmailHtmlContent;
}

@Description {value:"Generate html based group email content for ballerina."}
@Param {value:"htmlSummaryContent: html content for product summary"}
@Return {value:"htmlTableContent: html content for open pr table"}
@Return {value:"GmailSendError: Error"}
public function generateBallerinaGroupEmail (string htmlTableContent) (string) {

    string groupEmailHtmlContent = BALLERINA_GROUP_EMAIL_HTML_HEADER + htmlTableContent + BALLERINA_EMAIL_HTML_FOOTER;
    return groupEmailHtmlContent;
}

@Description {value:"Send private email to each wso2 git user."}
@Param {value:"accessToken: gmail API access token"}
@Return {value:"GmailSendError: Error"}
public function sendPrivateEmails (string accessToken) (GmailSendError) {

    int year;
    int month;
    int day;
    string gitId;
    string repository;
    string prTitle;
    string prURL;
    string emailTo;
    string emailContent;
    GmailSendError gmailError;

    time:Time time = time:currentTime();
    year, month, day = time.getDate();

    var strYear = <string>year;
    var strMonth = <string>month;
    var strDay = <string>day;

    string emailTitleDate = strDay +"-"+strMonth+"-"+strYear;

    LateOpenPullRequest[] lateOpenPullRequestArray = [];


    string orgs = config:getGlobalValue("ORGANIZATIONS");
    string[] orgArr= orgs.split(";");
    if (lengthof orgArr == 0){
        logFile:logError("organizations not found", runtime:getCallStack()[1].packageName);
    }
    lateOpenPullRequestArray, gmailError = generateLateOpenPrTable(OPEN_PR_LATE_THRESHOLD,orgArr,["ballerina-lang"]);

    foreach lateOpenPullRequest in lateOpenPullRequestArray {
        gitId = lateOpenPullRequest["gitId"];
        repository = lateOpenPullRequest["repository"];
        prTitle = lateOpenPullRequest["prTitle"];
        prURL = lateOpenPullRequest["prURL"];

        //select email address from database
        emailTo, gmailError = getEmailAddress(gitId);
        emailContent = PRIVATE_EMAIL_HTML_HEADER + repository + PRIVATE_EMAIL_HTML_TITLE + prTitle + PRIVATE_EMAIL_HTML_URL + prURL + PRIVATE_EMAIL_HTML_FOOTER;

        if (emailTo != null) {
            gmailError = sendMail(accessToken, emailTo, EMAIL_SENDER, EMAIL_PRIVATE_CC, (EMAIL_PRIVATE_TITLE+emailTitleDate), emailContent);
            if (gmailError != null) {
                return gmailError;
            }
        }
    }
    return gmailError;
}