package com.indiscale.fdo.manager.api;

public class TokenAuthenticationInfo {

  private String token;

  public TokenAuthenticationInfo(String token) {
    this.token = token;
  }

  public String getToken() {
    return token;
  }
}
