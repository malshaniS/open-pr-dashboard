package org.wso2.outsiders_contributions.serverlets;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.wso2.outsiders_contributions.msf4jhttp.HttpHandler;

@WebServlet(
        name = "pullRequests",
        urlPatterns = "/pullRequests"
)
public class PullRequests extends HttpServlet {
    private static final Logger logger = Logger.getLogger(PullRequests.class);

    @Override
        protected void doGet(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse){
        try {
            HttpHandler httpHandler  = new HttpHandler();
            logger.info("Request backend to fetch pull requests");
            String strProjectName = httpServletRequest.getParameter("productName");
            String response = httpHandler.httpsGet("/openPRSystem/table?productName=" + strProjectName);
            logger.info("Got: " + response);
            httpServletResponse.setContentType("application/json;charset=UTF-8");
            ServletOutputStream out = httpServletResponse.getOutputStream();
            out.print(response);
        }catch (IOException e){
            logger.error("The response output stream failed");
        } catch (CertificateException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (KeyStoreException e) {
            e.printStackTrace();
        } catch (KeyManagementException e) {
            e.printStackTrace();
        }
    }
}
