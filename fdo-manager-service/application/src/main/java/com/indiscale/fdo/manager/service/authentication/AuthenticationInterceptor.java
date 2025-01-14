package com.indiscale.fdo.manager.service.authentication;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthenticationInterceptor implements HandlerInterceptor {
  private AuthenticatorProvider authenticator;

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {
    String header = request.getHeader("authorization");
    if (header != null && header.startsWith("Bearer ")) {
      authenticator.setAuthenticator(new AuthenticationToken(header.substring(7)));
    } else if (header != null && header.startsWith("Basic ")) {
      authenticator.setAuthenticator(new BasicCredentials(header.substring(6)));
    }
    return true;
  }

  public AuthenticationInterceptor(AuthenticatorProvider authenticator) {
    this.authenticator = authenticator;
  }

  @Bean
  @Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
  AuthenticatorProvider authenticator() {
    return new AuthenticatorProvider();
  }
}
