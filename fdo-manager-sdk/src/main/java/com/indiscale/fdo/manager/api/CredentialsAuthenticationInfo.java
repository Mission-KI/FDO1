package com.indiscale.fdo.manager.api;

public class CredentialsAuthenticationInfo {

  private String username;
  private String password;

  public CredentialsAuthenticationInfo(String username, String password) {
    this.username = username;
    this.password = password;
  }

  public String getUsername() {
    return username;
  }

  public String getPassword() {
    return password;
  }
}
