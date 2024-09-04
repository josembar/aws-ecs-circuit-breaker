package com.javaapp.javaapp;

import org.springframework.boot.web.server.ConfigurableWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.stereotype.Component;
import org.apache.commons.lang3.ObjectUtils;

@Component
public class Server implements WebServerFactoryCustomizer<ConfigurableWebServerFactory> {

    static Integer getPort() {
        String port = System.getenv("PORT");
        return ObjectUtils.allNull(port) ? 3000 : Integer.parseInt(port);
    }

    @Override
    public void customize(ConfigurableWebServerFactory factory) {
          // Setting the port number
        factory.setPort(getPort());
    }
}