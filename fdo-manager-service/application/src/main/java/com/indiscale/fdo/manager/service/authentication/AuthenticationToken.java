package com.indiscale.fdo.manager.service.authentication;

import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.TokenAuthenticationInfo;

public class AuthenticationToken implements Authenticator {

  public AuthenticationToken(String token) {
    this.token = token;
  }

  private String token;

  @Override
  public String toString() {
    return "AuthToken[" + token + "]";
  }

  @Override
  public void authenticateWith(RepositoryConnection repository) {
    repository.setTokenAuthenticationInfo(new TokenAuthenticationInfo(token));
  }
}
