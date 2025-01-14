package com.indiscale.fdo.manager.service.authentication;

import com.indiscale.fdo.manager.api.CredentialsAuthenticationInfo;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import java.util.Base64;

public class BasicCredentials implements Authenticator {

  private String username;
  private String password;

  private static String[] decodeAndSplit(String encoded) {
    return new String(Base64.getDecoder().decode(encoded.getBytes())).split(":", 2);
  }

  public BasicCredentials(String encoded) {
    this(decodeAndSplit(encoded));
  }

  private BasicCredentials(String... components) {
    this.username = components[0];
    this.password = components[1];
  }

  @Override
  public void authenticateWith(RepositoryConnection repository) {
    repository.setCredentialsAuthenticationInfo(
        new CredentialsAuthenticationInfo(username, password));
  }
}
