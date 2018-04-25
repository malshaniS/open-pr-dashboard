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

//String constants
public const string DB_PRODUCT_NAME_COLUMN = "Product";
public const string GIT_API_URL = "https://api.github.com/graphql";
public const string GIT_COMMITTED_DATE = "committedDate";
public const string GIT_CREATED_AT = "createdAt";
public const string GIT_DATA = "data";
public const string GIT_EDGES = "edges";
public const string GIT_END_CURSOR = "endCursor";
public const string GIT_HAS_NEXT_PAGE = "hasNextPage";
public const string GIT_HISTORY = "history";
public const string GIT_MESSAGE = "message";
public const string GIT_NAME = "name";
public const string GIT_NODE = "node";
public const string GIT_NODES = "nodes";
public const string GIT_ORGANIZATION = "organization";
public const string GIT_PAGE_INFO = "pageInfo";
public const string GIT_PULL_REQUESTS = "pullRequests";
public const string GIT_PULL_REQUEST_TITLE = "title";
public const string GIT_PULL_REQUEST_AUTHOR = "author";
public const string GIT_PULL_REQUEST_LOGIN = "login";
public const string GIT_LAST_COMMITTED_DATE = "lastCommittedDate";
public const string GIT_LAST_COMMITTED_DATE_TITLE = "messageHeadline";
public const string GIT_LAST_COMMITTED_DATE_AVOID_TITLE = "Adding Pull Request Template";
public const string GIT_PULL_REQUEST_URL = "url";
public const string GIT_QUERY = "query";
public const string GIT_REPOSITORIES = "repositories";
public const string GIT_REPOSITORY = "repository";
public const string GIT_REPOSITORY_NAME = "repositoryName";
public const string GIT_REPOSITORY_NAME_QUERY = "repoName";
public const string GIT_REFERENCE = "ref";
public const string GIT_TARGET = "target";
public const string GIT_VARIABLES = "variables";

//Integer constants
public const int DB_INDEX_ZERO = 0;
public const int GIT__LAST_COMMITTED_DATE_INDEX_ZERO = 0;
public const int GIT__LAST_COMMITTED_DATE_INDEX_THIRD = 2;

//Errors
public const string GIT_ERRORS = "errors";
public const string GIT_ERROR_WHILE_RETRIEVING_DATA = "Error at retrieving data.";
public const string GIT_ERROR_WHILE_RETRIEVING_PAYLOAD = "Error at obtaining payload.";

//JNKS DB
public const string JNKS_DB_HOST ="ss-apps.private.wso2.com";
public const int JNKS_DB_PORT =3306;
public const string JNKS_DB_NAME ="UnifiedDashboards";
public const string JNKS_DB_USER_NAME ="gitopenpruser";
public const string JNKS_DB_PASSWORD ="sfJXXPsvb9pqhXtj";