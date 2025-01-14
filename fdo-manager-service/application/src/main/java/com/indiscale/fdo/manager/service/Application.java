package com.indiscale.fdo.manager.service;

import org.apache.catalina.connector.Connector;
import org.apache.tomcat.util.buf.EncodedSolidusHandling;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.embedded.tomcat.TomcatWebServer;
import org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext;

@SpringBootApplication
public class Application {

  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(Application.class);
    AnnotationConfigServletWebServerApplicationContext context =
        (AnnotationConfigServletWebServerApplicationContext) app.run();
    TomcatWebServer webServer = (TomcatWebServer) context.getWebServer();
    org.apache.catalina.startup.Tomcat tomcat = webServer.getTomcat();
    Connector connector = tomcat.getConnector();
    connector.setEncodedSolidusHandling(EncodedSolidusHandling.PASS_THROUGH.getValue());
  }
}
