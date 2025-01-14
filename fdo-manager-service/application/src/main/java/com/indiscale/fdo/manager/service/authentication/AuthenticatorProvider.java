package com.indiscale.fdo.manager.service.authentication;

public class AuthenticatorProvider {
  private Authenticator authenticator;

  public Authenticator getAuthenticator() {
    return authenticator;
  }

  public void setAuthenticator(Authenticator authenticator) {
    this.authenticator = authenticator;
  }
}
