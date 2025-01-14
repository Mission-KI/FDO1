package com.indiscale.fdo.manager.service.authentication;

import com.indiscale.fdo.manager.api.RepositoryConnection;

public interface Authenticator {
  public void authenticateWith(RepositoryConnection repository);
}
