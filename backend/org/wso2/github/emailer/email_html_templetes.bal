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

public const string GROUP_EMAIL_HTML_HEADER = "<!DOCTYPE html>" +
                                              "<html>" +
                                              "<head>" +
                                              "<title></title>" +
                                              "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />" +
                                              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
                                              "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />" +
                                              "<style type=\"text/css\">" +
                                              "/* CLIENT-SPECIFIC STYLES */" +
                                              "body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }" +
                                              "table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }" +
                                              "img { -ms-interpolation-mode: bicubic; }" +
                                              "/* RESET STYLES */" +
                                              "img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }" +
                                              "table { border-collapse: collapse !important; }" +
                                              "body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }" +
                                              "/* iOS BLUE LINKS */" +
                                              "a[x-apple-data-detectors] {" +
                                              "    color: inherit !important;" +
                                              "    text-decoration: none !important;" +
                                              "    font-size: inherit !important;" +
                                              "    font-family: inherit !important;" +
                                              "    font-weight: inherit !important;" +
                                              "    line-height: inherit !important;" +
                                              "}" +
                                              "/* MEDIA QUERIES */" +
                                              "@media screen and (max-width: 480px) {" +
                                              "    .mobile-hide {" +
                                              "        display: none !important;" +
                                              "    }" +
                                              "    .mobile-center {" +
                                              "        text-align: center !important;" +
                                              "    }" +
                                              "}" +
                                              "/* ANDROID CENTER FIX */" +
                                              "div[style*=\"margin: 16px 0;\"] { margin: 0 !important; }" +
                                              "</style>" +
                                              "<body style=\"margin: 0 !important; padding: 0 !important; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "<!-- HIDDEN PREHEADER TEXT -->" +
                                              "<div style=\"display: none; font-size: 1px; color: #fefefe; line-height: 1px; font-family: Open Sans, Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;\">" +
                                              "Weekly Update of GitHub Open Pull Request on WSO2 Organization " +
                                              "</div>" +
                                              "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                                              "    <tr>" +
                                              "        <td align=\"center\" style=\"background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "        <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                              "            <tr>" +
                                              "                <td align=\"center\" valign=\"top\" style=\"font-size:0; padding: 12px;\" bgcolor=\"#044767\">" +
                                              "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\">" +
                                              "                    <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:500px;\">" +
                                              "                        <tr>" +
                                              "                            <td align=\"left\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 36px; font-weight: 800; line-height: 48px;\" class=\"mobile-center\">" +
                                              "                                <h1 style=\"font-size: 22px; font-weight: 600; margin: 0; color: #ffffff;\">" +
                                              "GitHub Open Pull Request Analyzer</h1>" +
                                              "                            </td>" +
                                              "                        </tr>" +
                                              "                    </table>" +
                                              "                </div>" +
                                              "             " +
                                              "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\" class=\"mobile-hide\">" +
                                              "                    <table align=\"right\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:300px;\">" +
                                              "                        <tr>" +
                                              "                            <td align=\"right\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 48px; font-weight: 400; line-height: 48px;\">" +
                                              "                                <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"right\">" +
                                              "                                    <tr>" +
                                              "                                        " +
                                              "                                        <td style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 24px;\">" +
                                              "                                            <a href=\"http://github.com\" target=\"_blank\" style=\"color: #ffffff; text-decoration: none;\"><img src=\"http://www.pvhc.net/img207/jmvvtirrrkqqavzhvkpa.png\" width=\"60\" height=\"53\" style=\"display: block; border: 0px;\"/></a>" +
                                              "                                        </td>" +
                                              "                                    </tr>" +
                                              "                                </table>" +
                                              "                            </td>" +
                                              "                        </tr>" +
                                              "                    </table>" +
                                              "                </div>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "            <tr>" +
                                              "                <td align=\"center\" style=\"padding: 35px 35px 20px 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:600px;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 15px; padding-top: 0px;\">" +
                                              "                            <p style=\"font-size: 18px; font-weight: 400; line-height: 15px; color: #777777;\">" +
                                              "                                Daily Update of GitHub Open Pull Requests on WSO2 Organization " +
                                              "                            </p>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                    <tr>" +
                                              "                        <td align=\"left\" style=\"padding-top: 10px;\">";
public const string BALLERINA_GROUP_EMAIL_HTML_HEADER = "<!DOCTYPE html>" +
                                              "<html>" +
                                              "<head>" +
                                              "<title></title>" +
                                              "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />" +
                                              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
                                              "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />" +
                                              "<style type=\"text/css\">" +
                                              "/* CLIENT-SPECIFIC STYLES */" +
                                              "body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }" +
                                              "table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }" +
                                              "img { -ms-interpolation-mode: bicubic; }" +
                                              "/* RESET STYLES */" +
                                              "img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }" +
                                              "table { border-collapse: collapse !important; }" +
                                              "body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }" +
                                              "/* iOS BLUE LINKS */" +
                                              "a[x-apple-data-detectors] {" +
                                              "    color: inherit !important;" +
                                              "    text-decoration: none !important;" +
                                              "    font-size: inherit !important;" +
                                              "    font-family: inherit !important;" +
                                              "    font-weight: inherit !important;" +
                                              "    line-height: inherit !important;" +
                                              "}" +
                                              "/* MEDIA QUERIES */" +
                                              "@media screen and (max-width: 480px) {" +
                                              "    .mobile-hide {" +
                                              "        display: none !important;" +
                                              "    }" +
                                              "    .mobile-center {" +
                                              "        text-align: center !important;" +
                                              "    }" +
                                              "}" +
                                              "/* ANDROID CENTER FIX */" +
                                              "div[style*=\"margin: 16px 0;\"] { margin: 0 !important; }" +
                                              "</style>" +
                                              "<body style=\"margin: 0 !important; padding: 0 !important; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "<!-- HIDDEN PREHEADER TEXT -->" +
                                              "<div style=\"display: none; font-size: 1px; color: #efefef; line-height: 1px; font-family: Open Sans, Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;\">" +
                                              "Daily Update of GitHub Open Pull Request on WSO2 Organization : Ballerina" +
                                              "</div>" +
                                              "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                                              "    <tr>" +
                                              "        <td align=\"center\" style=\"background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "        <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                              "            <tr>" +
                                              "                <td align=\"center\" valign=\"top\" style=\"font-size:0; padding: 12px;\" bgcolor=\"#044767\">" +
                                              "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\">" +
                                              "                    <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:500px;\">" +
                                              "                        <tr>" +
                                              "                            <td align=\"left\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 36px; font-weight: 800; line-height: 48px;\" class=\"mobile-center\">" +
                                              "                                <h1 style=\"font-size: 22px; font-weight: 600; margin: 0; color: #ffffff;\">" +
                                              "GitHub Open Pull Request Analyzer</h1>" +
                                              "                            </td>" +
                                              "                        </tr>" +
                                              "                    </table>" +
                                              "                </div>" +
                                              "             " +
                                              "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\" class=\"mobile-hide\">" +
                                              "                    <table align=\"right\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:300px;\">" +
                                              "                        <tr>" +
                                              "                            <td align=\"right\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 48px; font-weight: 400; line-height: 48px;\">" +
                                              "                                <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"right\">" +
                                              "                                    <tr>" +
                                              "                                        " +
                                              "                                        <td style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 24px;\">" +
                                              "                                            <a href=\"http://github.com\" target=\"_blank\" style=\"color: #ffffff; text-decoration: none;\"><img src=\"http://www.pvhc.net/img207/jmvvtirrrkqqavzhvkpa.png\" width=\"60\" height=\"53\" style=\"display: block; border: 0px;\"/></a>" +
                                              "                                        </td>" +
                                              "                                    </tr>" +
                                              "                                </table>" +
                                              "                            </td>" +
                                              "                        </tr>" +
                                              "                    </table>" +
                                              "                </div>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "            <tr>" +
                                              "                <td align=\"center\" style=\"padding: 15px 15px 10px 15px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 15px; padding-top: 0px;\">" +
                                              "                            <p style=\"font-size: 24px; font-weight: 600; line-height: 26px; color: #000000;\">" +
                                              "                                Daily Update of GitHub Open Pull Requests on Ballerina" +
                                              "                            </p>" +
                                              "                        </td>" +
                                              "                    </tr>" + "</table>";
                                              //"                    <tr>" +
                                              //"                        <td align=\"left\" style=\"padding-top: 10px;\">";

public const string GROUP_EMAIL_HTML_TABLE_TITLE = "</td>" +
                                                   "    </tr>" +
                                                   "        <td align=\"center\" style=\"font-family: Helvetica, Arial, Open Sans, sans-serif; font-size: 16px; font-weight: 400; line-height: 40px; padding-top: 25px;\">" +
                                                   "            <h2 style=\"font-size: 20px; font-weight: 700; line-height: 28px; color: #333333; margin: 0;\">" +
                                                   "                Details of Open Pull Requests" +
                                                   "            </h2>" +
                                                   "        </td>" +
                                                   "    </tr>" + "</br>" + "</br>" +
                                                   "</table>" +
                                                   "</td>" +
                                                   "</tr>" + "<tr>";

public const string GROUP_EMAIL_HTML_UPDATED_DATE = "</tr>" +
                                                    "   <tr>" +
                                                    "       <td align=\"center\" height=\"100%\" valign=\"top\" width=\"100%\" style=\"padding: 0 35px 35px 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                                    "           <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                                    "               <tr>" +
                                                    "                   <td align=\"center\" valign=\"top\" style=\"font-size:0;\">" +
                                                    "                       <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                    "                           <tr>" +
                                                    "                               <td align=\"center\" valign=\"top\" width=\"300\">" +
                                                    "                                   <div style=\"display:inline-block; max-width:50%; min-width:240px; vertical-align:top; width:100%;\">" +
                                                    "                                   <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                                    "                                       <tr>" +
                                                    "                                           <td align=\"center\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px;\">" +
                                                    "                                            <p align=\"center\" font-size: 30px; font-weight: 600; line-height: 24px;> Updated date </p>"+
                                                    "                                            <p>";

public const string GROUP_EMAIL_HTML_FOOTER = "</p>" +
                                              "                                        </td>" +
                                              "                                    </tr>" +
                                              "                                </table>" +
                                              "                            </div>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "            <tr>" +
                                              "                <td align=\"center\" style=\" padding: 10px; background-color: #044767;\" bgcolor=\"#1b9ba3\">" +
                                              "                " +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding-top: 15px;\">" +
                                              "                            <h2 style=\"font-size: 20px; font-weight: 800; line-height: 24px; color: #ffffff; margin: 0;\">" +
                                              "                                 Check WSO2 GitHub Open Pull Requests" +
                                              "                            </h2>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"padding: 12px 0 12px 0;\">" +
                                              "                            <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                                              "                                <tr>" +
                                              "                                    <td align=\"center\" style=\"border-radius: 5px;\" bgcolor=\"#66b3b7\">" +
                                              "                                      <a href=\"https://identity-gateway.cloud.wso2.com/t/wso2internal928/gitopenprdashboard/\" target=\"_blank\" style=\"font-size: 16px; font-family: Open Sans, Helvetica, Arial, sans-serif; color: #000000; text-decoration: none; border-radius: 5px; background-color: #eeeeee; padding: 15px 30px; border: 1px solid #66b3b7; display: block;\">GitHub Dashboard</a>" +
                                              "                                    </td>" +
                                              "                                </tr>" +
                                              "                            </table>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "            <tr>" +
                                              "                <td align=\"center\" style=\"padding: 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:600px;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\">" +
                                              "                            <img src=\"https://upload.wikimedia.org/wikipedia/en/5/56/WSO2_Software_Logo.png\" width=\"90\" height=\"37\" style=\"display: block; border: 0px;\"/>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 24px;\">" +
                                              "                            <p style=\"font-size: 14px; font-weight: 400; line-height: 20px; color: #777777;\">" +
                                              "                                Copyright (c) 2018 | WSO2 Inc.<br/>All Right Reserved. " +
                                              "                            </p>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "                </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "        </table>" +
                                              "        </td>" +
                                              "        </tr>" +
                                              "        </table>" +
                                              "        </td>" +
                                              "    </tr>" +
                                              "</table>" +
                                              "</body>" +
                                              "</html>";

public const string BALLERINA_EMAIL_HTML_FOOTER = "<div width=\"100%\"><table width=\"100%\"><tr>" +
                                              "                <td align=\"center\" width=\"100%\" style=\" padding: 10px; max-width:100%; background-color: #044767;\" bgcolor=\"#1b9ba3\">" +
                                              "                " +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding-top: 15px;\">" +
                                              "                            <h2 style=\"font-size: 20px; font-weight: 800; line-height: 24px; color: #ffffff; margin: 0;\">" +
                                              "                                 Check WSO2 GitHub Open Pull Requests" +
                                              "                            </h2>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"padding: 12px 0 12px 0;\">" +
                                              "                            <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                                              "                                <tr>" +
                                              "                                    <td align=\"center\" style=\"border-radius: 5px;\" bgcolor=\"#66b3b7\">" +
                                              "                                      <a href=\"https://identity-gateway.cloud.wso2.com/t/wso2internal928/gitopenprdashboard/\" target=\"_blank\" style=\"font-size: 16px; font-family: Open Sans, Helvetica, Arial, sans-serif; color: #000000; text-decoration: none; border-radius: 5px; background-color: #eeeeee; padding: 15px 30px; border: 1px solid #66b3b7; display: block;\">GitHub Dashboard</a>" +
                                              "                                    </td>" +
                                              "                                </tr>" +
                                              "                            </table>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "            </tr>" +
                                              "            <tr>" +
                                              "                <td align=\"center\" style=\"padding: 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                                              "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:600px;\">" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\">" +
                                              "                            <img src=\"https://upload.wikimedia.org/wikipedia/en/5/56/WSO2_Software_Logo.png\" width=\"90\" height=\"37\" style=\"display: block; border: 0px;\"/>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                    <tr>" +
                                              "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 24px;\">" +
                                              "                            <p style=\"font-size: 14px; font-weight: 400; line-height: 20px; color: #777777;\">" +
                                              "                                Copyright (c) 2018 | WSO2 Inc.<br/>All Right Reserved. " +
                                              "                            </p>" +
                                              "                        </td>" +
                                              "                    </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "                </tr>" +
                                              "                </table>" +
                                              "                </td>" +
                                              "            </tr>" + "</table></div>" +
                                              "        </table>" +
                                              "        </td>" +
                                              "        </tr>" +
                                              "        </table>" +
                                              "        </td>" +
                                              "    </tr>" +
                                              "</table>" +
                                              "</body>" +
                                              "</html>";


public const string PRIVATE_EMAIL_HTML_HEADER = "<!DOCTYPE html>" +
                                                "<html>" +
                                                "<head>" +
                                                "<title></title>" +
                                                "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />" +
                                                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
                                                "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />" +
                                                "<style type=\"text/css\">" +
                                                "    /* FONTS */" +
                                                "    @media screen {" +
                                                "        @font-face {" +
                                                "          font-family: 'Lato';" +
                                                "          font-style: normal;" +
                                                "          font-weight: 400;" +
                                                "          src: local('Lato Regular'), local('Lato-Regular'), url(https://fonts.gstatic.com/s/lato/v11/qIIYRU-oROkIk8vfvxw6QvesZW2xOQ-xsNqO47m55DA.woff) format('woff');" +
                                                "        }" +
                                                "        " +
                                                "        @font-face {" +
                                                "          font-family: 'Lato';" +
                                                "          font-style: normal;" +
                                                "          font-weight: 700;" +
                                                "          src: local('Lato Bold'), local('Lato-Bold'), url(https://fonts.gstatic.com/s/lato/v11/qdgUG4U09HnJwhYI-uK18wLUuEpTyoUstqEm5AMlJo4.woff) format('woff');" +
                                                "        }" +
                                                "        " +
                                                "        @font-face {" +
                                                "          font-family: 'Lato';" +
                                                "          font-style: italic;" +
                                                "          font-weight: 400;" +
                                                "          src: local('Lato Italic'), local('Lato-Italic'), url(https://fonts.gstatic.com/s/lato/v11/RYyZNoeFgb0l7W3Vu1aSWOvvDin1pK8aKteLpeZ5c0A.woff) format('woff');" +
                                                "        }" +
                                                "        " +
                                                "        @font-face {" +
                                                "          font-family: 'Lato';" +
                                                "          font-style: italic;" +
                                                "          font-weight: 700;" +
                                                "          src: local('Lato Bold Italic'), local('Lato-BoldItalic'), url(https://fonts.gstatic.com/s/lato/v11/HkF_qI1x_noxlxhrhMQYELO3LdcAZYWl9Si6vvxL-qU.woff) format('woff');" +
                                                "        }" +
                                                "    }" +
                                                "    " +
                                                "    /* CLIENT-SPECIFIC STYLES */" +
                                                "    body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }" +
                                                "    table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }" +
                                                "    img { -ms-interpolation-mode: bicubic; }" +
                                                "    /* RESET STYLES */" +
                                                "    img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }" +
                                                "    table { border-collapse: collapse !important; }" +
                                                "    body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }" +
                                                "    /* iOS BLUE LINKS */" +
                                                "    a[x-apple-data-detectors] {" +
                                                "        color: inherit !important;" +
                                                "        text-decoration: none !important;" +
                                                "        font-size: inherit !important;" +
                                                "        font-family: inherit !important;" +
                                                "        font-weight: inherit !important;" +
                                                "        line-height: inherit !important;" +
                                                "    }" +
                                                "    " +
                                                "    /* MOBILE STYLES */" +
                                                "    @media screen and (max-width:600px){" +
                                                "        h1 {" +
                                                "            font-size: 32px !important;" +
                                                "            line-height: 32px !important;" +
                                                "        }" +
                                                "    }" +
                                                "    /* ANDROID CENTER FIX */" +
                                                "    div[style*=\"margin: 16px 0;\"] { margin: 0 !important; }" +
                                                "</style>" +
                                                "</head>" +
                                                "<body style=\"background-color: #f4f4f4; margin: 0 !important; padding: 0 !important;\">" +
                                                "<!-- HIDDEN PREHEADER TEXT -->" +
                                                "<div style=\"display: none; font-size: 1px; color: #fefefe; line-height: 1px; font-family: 'Lato', Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;\">" +
                                                "    Weekly WSO2 GitHub Open Pull Request analizer" +
                                                "</div>" +
                                                "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                                                "    <!-- LOGO -->" +
                                                "    <tr>" +
                                                "        <td bgcolor=\"#b5b2b1\" align=\"center\">" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                "            <tr>" +
                                                "            <td align=\"center\" valign=\"top\" width=\"600\">" +
                                                "            <![endif]-->" +
                                                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\" >" +
                                                "                <tr>" +
                                                "                    <td align=\"center\" valign=\"top\" style=\"padding: 40px 10px 40px 10px;\">" +
                                                "                        <a href=\"http://wso2.com\" target=\"_blank\">" +
                                                "                            <img alt=\"Logo\" src=\"https://upload.wikimedia.org/wikipedia/en/5/56/WSO2_Software_Logo.png\" width=\"100\" height=\"100\" style=\"display: block; width: 200px; max-width: 200px; min-width: 40px; font-family: 'Lato', Helvetica, Arial, sans-serif; color: #ffffff; font-size: 18px;\" border=\"0\">" +
                                                "                        </a>" +
                                                "                    </td>" +
                                                "                </tr>" +
                                                "            </table>" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            </td>" +
                                                "            </tr>" +
                                                "            </table>" +
                                                "            <![endif]-->" +
                                                "        </td>" +
                                                "    </tr>" +
                                                "    <!-- HERO -->" +
                                                "    <tr>" +
                                                "        <td bgcolor=\"#b5b2b1\" align=\"center\" style=\"padding: 0px 10px 0px 10px;\">" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                "            <tr>" +
                                                "            <td align=\"center\" valign=\"top\" width=\"600\">" +
                                                "            <![endif]-->" +
                                                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\" >" +
                                                "                <tr>" +
                                                "                    <td bgcolor=\"#ffffff\" align=\"center\" valign=\"top\" style=\"padding: 40px 20px 20px 20px; border-radius: 4px 4px 0px 0px; color: #111111; font-family: Helvetica, Arial, sans-serif,'Lato'; font-size: 48px; font-weight: 400; letter-spacing: 4px; line-height: 48px;\">" +
                                                "                      <h1 style=\"font-size: 30px; font-weight: 400; margin: 0;\">Your Pull Request is Still Open</h1>" +
                                                "                    </td>" +
                                                "                </tr>" +
                                                "            </table>" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            </td>" +
                                                "            </tr>" +
                                                "            </table>" +
                                                "            <![endif]-->" +
                                                "        </td>" +
                                                "    </tr>" +
                                                "    <!-- COPY BLOCK -->" +
                                                "    <tr>" +
                                                "        <td bgcolor=\"#f4f4f4\" align=\"center\" style=\"padding: 0px 10px 0px 10px;\">" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                "            <tr>" +
                                                "            <td align=\"center\" valign=\"top\" width=\"600\">" +
                                                "            <![endif]-->" +
                                                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\" >" +
                                                "              <!-- COPY -->" +
                                                "              <tr>" +
                                                "                <td bgcolor=\"#ffffff\" align=\"center\" style=\"padding: 20px 30px 40px 30px; color: #111111; font-family: Helvetica, Arial, sans-serif,'Lato'; font-size: 18px; font-weight: 400; line-height: 25px;\" >" +
                                                "                  <p style=\"margin: 0;\">This is an auto-generated message from wso2 Inc. to inform that your Github  pull requst is still open.<br/><br/>Repository: ";

public const string PRIVATE_EMAIL_HTML_TITLE = "<br/><br/>Title: ";

public const string PRIVATE_EMAIL_HTML_URL = "                   </p>" +
                                             "                </td>" +
                                             "              </tr>" +
                                             "              <tr>" +
                                             "                <td bgcolor=\"#ffffff\" align=\"left\">" +
                                             "                  <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                                             "                    <tr>" +
                                             "                      <td bgcolor=\"#ffffff\" align=\"center\" style=\"padding: 20px 30px 60px 30px;\">" +
                                             "                        <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                                             "                          <tr>" +
                                             "                              <td align=\"center\" style=\"border-radius: 3px;\" bgcolor=\"#ec6d64\"><a href=\"";

public const string PRIVATE_EMAIL_HTML_FOOTER = "\" target=\"_blank\" style=\"font-size: 20px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; color: #ffffff; text-decoration: none; padding: 15px 25px; border-radius: 2px; border: 1px solid #ec6d64; display: inline-block;\">Go to Open PR</a></td>" +
                                                "                          </tr>" +
                                                "                        </table>" +
                                                "                      </td>" +
                                                "                    </tr>" +
                                                "                  </table>" +
                                                "                </td>" +
                                                "              </tr>" +
                                                "            </table>" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            </td>" +
                                                "            </tr>" +
                                                "            </table>" +
                                                "            <![endif]-->" +
                                                "        </td>" +
                                                "    </tr>" +
                                                "    <!-- COPY CALLOUT -->" +
                                                "    <tr>" +
                                                "        <td bgcolor=\"#f4f4f4\" align=\"center\" style=\"padding: 0px 10px 0px 10px;\">" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                "            <tr>" +
                                                "            <td align=\"center\" valign=\"top\" width=\"600\">" +
                                                "            <![endif]-->" +
                                                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\" >" +
                                                "                <!-- HEADLINE -->" +
                                                "            </table>" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            </td>" +
                                                "            </tr>" +
                                                "            </table>" +
                                                "            <![endif]-->" +
                                                "        </td>" +
                                                "    </tr>" +
                                                "    </tr>" +
                                                "    <!-- FOOTER -->" +
                                                "    <tr>" +
                                                "        <td bgcolor=\"#f4f4f4\" align=\"center\" style=\"padding: 0px 10px 0px 10px;\">" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                                                "            <tr>" +
                                                "            <td align=\"center\" valign=\"top\" width=\"600\">" +
                                                "            <![endif]-->" +
                                                "            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width: 600px;\" >" +
                                                "              <!-- NAVIGATION -->" +
                                                "              <tr>" +
                                                "                <td bgcolor=\"#f4f4f4\" align=\"center\" style=\"padding: 30px 30px 30px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 18px;\" >" +
                                                "                  <p style=\"margin: 0;\">" +
                                                "                    <a href=\"http://github.com\" target=\"_blank\" style=\"color: #1BB2F8; font-weight: 700;\"> GitHub</a> |" +
                                                "                    <a href=\"http://wso2.com\" target=\"_blank\" style=\"color: #1BB2F8; font-weight: 700;\"> WSO2</a> " +
                                                "                  </p>" +
                                                "                </td>" +
                                                "              </tr>" +
                                                "              <tr>" +
                                                "                <td bgcolor=\"#f4f4f4\" align=\"center\" style=\"padding: 0px 30px 30px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 18px;\" >" +
                                                "                  <p style=\"margin: 0;\">Copyright (c) 2018</p>" +
                                                "					<p style=\"margin: 0;\">All Right Reserved</p>" +
                                                "                </td>" +
                                                "              </tr>" +
                                                "            </table>" +
                                                "            <!--[if (gte mso 9)|(IE)]>" +
                                                "            </td>" +
                                                "            </tr>" +
                                                "            </table>" +
                                                "            <![endif]-->" +
                                                "        </td>" +
                                                "    </tr>" +
                                                "</table>" +
                                                "</body>" +
                                                "</html>";