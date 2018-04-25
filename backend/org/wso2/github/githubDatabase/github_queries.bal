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

public const string GET_REPOSITORIES = "query ($organization: String!){
                                                        organization(login:$organization) {
                                                            repositories(first: 100) {
                                                                pageInfo {
                                                                    hasNextPage
                                                                    endCursor
                                                                }
                                                                nodes {
                                                                    name
                                                                    ref(qualifiedName: \\\"master\\\") {
                                                                        target {
                                                                            ... on Commit {
                                                                                history(first: 3) {
                                                                                    edges {
                                                                                        node {
                                                                                            oid
                                                                                            messageHeadline
                                                                                            committedDate
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    pullRequests(first:100, states:OPEN){
                                                                        pageInfo {
                                                                            hasNextPage
                                                                            endCursor
                                                                        }
                                                                        nodes{
                                                                            title
                                                                            createdAt
                                                                            url
                                                                            headRepository {
                                                                                name
                                                                            }
                                                                            author{
                                                                                login
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }";

public const string GET_REPOSITORIES_NEXT_PAGE = "query ($organization: String!,$endCursor:String!){
                                                        organization(login:$organization) {
                                                            repositories(first: 100, after:$endCursor) {
                                                                pageInfo {
                                                                    hasNextPage
                                                                    endCursor
                                                                }
                                                                nodes {
                                                                    name
                                                                    ref(qualifiedName: \\\"master\\\") {
                                                                        target {
                                                                            ... on Commit {
                                                                                history(first: 3) {
                                                                                    edges {
                                                                                        node {
                                                                                            oid
                                                                                            messageHeadline
                                                                                            committedDate
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    pullRequests(first:100, states:OPEN){
                                                                        pageInfo {
                                                                            hasNextPage
                                                                            endCursor
                                                                        }
                                                                        nodes{
                                                                            title
                                                                            createdAt
                                                                            url
                                                                            headRepository {
                                                                                name
                                                                            }
                                                                            author{
                                                                                login
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }";

public const string GET_OPEN_PR_NEXT_PAGE = "query ($organization: String!,$repoName:String!,$endCursor:String!){
                                                        organization(login:$organization) {
                                                            repository(name:$repoName){
                                                                pullRequests(first:100 states:OPEN after:$endCursor){
                                                                pageInfo {
                                                                    hasNextPage
                                                                    endCursor
                                                                }
                                                                nodes{
                                                                        title
                                                                        createdAt
                                                                        url
                                                                    headRepository {
                                                                        name
                                                                    }
                                                                    author{
                                                                        login
                                                                    }
                                                                    }
                                                                }
                                                             }
                                                        }
                                        }";