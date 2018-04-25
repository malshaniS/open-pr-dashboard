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

package dashboardServices;

import ballerina.net.http;
import org.wso2.github.dashboard;
import ballerina.log;
import org.wso2.github.logFile;
import ballerina.runtime;
import ballerina.config;
import ballerina.util;

const string keystorePath = config:getGlobalValue("KEY_STORE_PATH");
const string keystorePassword = config:getGlobalValue("KEY_STORE_PASSWORD");
const string certificatePassword = config:getGlobalValue("CERT_PASSWORD");
const string serviceUsername = config:getGlobalValue("SERVICE_USERNAME");
const string servicePassword = config:getGlobalValue("SERVICE_PASSWORD");
const int httpsPort = getPortNumber();

@Description {value:"Backend system for github open pull request analyzer"}
@http:configuration {basePath:"/openPRSystem",httpsPort:httpsPort, keyStoreFile: keystorePath, keyStorePassword:keystorePassword, certPassword: certificatePassword}

service<http> dashboardBackend {

    @http:resourceConfig {
        methods:["GET"],
        path:"/table"
    }
    resource fetchOpenPullRequestTable (http:Connection conn, http:InRequest request) {

        http:OutResponse response = {};
        dashboard:DashboardServerError dashboardError;
        json[] jsonOpenPullRequestArray = [];
        int i = 0;
        error err;

        boolean auth = authenticate(request);
        if(auth) {

            var productNameStr = <string>request.getQueryParams()["productName"];
            productNameStr = productNameStr.replaceAll("_", " ");


            dashboard:OpenPullRequest[] openPullRequestArray;
            openPullRequestArray, dashboardError = dashboard:fetchOpenPullRequests(productNameStr);  //productNameStr

            if (openPullRequestArray == null) {
                response.addHeader("Access-Control-Allow-Origin", "*");
                response.setJsonPayload(null);
                log:printError(dashboardError.message[0]);
                logFile:logError(dashboardError.message[0], runtime:getCallStack()[1].packageName);
                _ = conn.respond(response);
            }
            else {
                foreach openPullRequest in openPullRequestArray {
                    jsonOpenPullRequestArray[i], err = <json>openPullRequest;
                    if (err != null) {
                        log:printError(err.message);
                        logFile:logError(err.message, runtime:getCallStack()[1].packageName);
                        response.addHeader("Access-Control-Allow-Origin", "*");
                        response.setJsonPayload(null);
                        _ = conn.respond(response);
                    }
                    i = i + 1;
                }

                response.addHeader("Access-Control-Allow-Origin", "*");
                response.setJsonPayload(jsonOpenPullRequestArray);
                _ = conn.respond(response);
            }
        }else{
            log:printError(dashboardError.message[0]);
            logFile:logError(dashboardError.message[0], runtime:getCallStack()[1].packageName);
            response.addHeader("Access-Control-Allow-Origin", "*");
            response.setJsonPayload(null);
            _ = conn.respond(response);
        }

    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/count"
    }
    resource fetchOpenPullRequestCount (http:Connection conn, http:InRequest request) {

        http:OutResponse response = {};
        dashboard:DashboardServerError dashboardError;

        boolean auth = authenticate(request);
        if(auth) {
            int openPullRequestCount = 0;
            int lateOpenPullRequestCount = 0;
            json jsonOpenPullRequestCount = {"total":openPullRequestCount, "late":lateOpenPullRequestCount};
            openPullRequestCount, lateOpenPullRequestCount, dashboardError = dashboard:countOpenPullRequests();

            if (dashboardError == null) {
                jsonOpenPullRequestCount["total"] = openPullRequestCount;
                jsonOpenPullRequestCount["late"] = lateOpenPullRequestCount;

                response.addHeader("Access-Control-Allow-Origin", "*");
                response.setJsonPayload(jsonOpenPullRequestCount);
                _ = conn.respond(response);
            } else {
                log:printError(dashboardError.message[0]);
                logFile:logError(dashboardError.message[0], runtime:getCallStack()[1].packageName);
                response.addHeader("Access-Control-Allow-Origin", "*");
                response.setJsonPayload(null);
                _ = conn.respond(response);
            }
        }else{
            log:printError(dashboardError.message[0]);
            logFile:logError(dashboardError.message[0], runtime:getCallStack()[1].packageName);
            response.addHeader("Access-Control-Allow-Origin", "*");
            response.setJsonPayload(null);
            _ = conn.respond(response);
        }
    }
}

function getPortNumber()(int){
    var portNumber , _ = <int> config:getGlobalValue("HTTPS_PORT");
    return portNumber;
}

function authenticate(http:InRequest inRequest)(boolean){
    boolean result = false;
    var basicAuthHeader = inRequest.getHeader("Authorization");
    if (basicAuthHeader == null) {
        log:printError("401: No Authentication header found in the request");
    }
    if(basicAuthHeader.hasPrefix("Basic")){
        string authHeaderValue = basicAuthHeader.subString(5, basicAuthHeader.length()).trim();
        string decodedBasicAuthHeader = util:base64Decode(authHeaderValue);
        string[] decodedCredentials = decodedBasicAuthHeader.split(":");
        if(lengthof decodedCredentials != 2){
            log:printError("401: Incorrect Basic Authentication header");
        }
        else{
            if(decodedCredentials[0] == serviceUsername && decodedCredentials[1] == servicePassword){
                result = true;
            }
            else{
                log:printError("Error in credentials");
            }
        }
    }
    else{
        log:printError("Unsupported authentication scheme, only Basic auth is supported");
    }
    return result;
}