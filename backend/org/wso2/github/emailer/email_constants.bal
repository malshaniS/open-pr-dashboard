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

//String constants
public const string BACKGROUND_COLOR_GRAY = "#dedede";
public const string BACKGROUND_COLOR_WHITE = "#efefef";
public const string DB_MAIL_WSO2MAIL_COLUMN = "WSO2MAIL";
public const string EMAIL_SENDER = "sananthanak@gmail.com";
public const string EMAIL_PRIVATE_TITLE = "[Open Pr's] Open Pull Requests - User Reminder: ";
public const string EMAIL_PRIVATE_CC = "rohan@wso2.com";
public const string GMAIL_MESSAGE = "message";
public const string GMAIL_LABEL_IDS = "labelIds";
public const string GMAIL_SENT = "SENT";
public const string GMAIL_API_ACCESS_TOKEN_URL = "https://www.googleapis.com/oauth2/v4";
public const string GMAIL_API_EMAIL_SEND_URL = "https://www.googleapis.com/gmail";
public const string GMAIL_API_ACCESS_TOKEN = "access_token";

//Integer constants
public const int DB_INDEX_ZERO = 0;
public const int GMAIL_INDEX_ZERO = 0;
public const int OPEN_PR_LATE_THRESHOLD = 0;

//Errors
public const string GMAIL_ERRORS = "errors";
public const string GMAIL_ERROR_WHILE_RETRIEVING_DATA = "Error while retrieving data.";
public const string GMAIL_ERROR_WHILE_RETRIEVING_PAYLOAD = "Error while obtaining payload.";