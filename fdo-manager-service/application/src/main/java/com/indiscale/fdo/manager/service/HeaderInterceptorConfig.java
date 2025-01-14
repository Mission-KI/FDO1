package com.indiscale.fdo.manager.service;

import com.indiscale.fdo.manager.service.authentication.AuthenticationInterceptor;
import com.indiscale.fdo.manager.service.authentication.AuthenticatorProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class HeaderInterceptorConfig implements WebMvcConfigurer {

  @Override
  public void addInterceptors(final InterceptorRegistry registry) {
    registry.addInterceptor(authenticationInterceptor());
  }

  @Bean
  AuthenticationInterceptor authenticationInterceptor() {
    return new AuthenticationInterceptor(authenticator());
  }

  @Bean
  @Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
  AuthenticatorProvider authenticator() {
    return new AuthenticatorProvider();
  }
}
