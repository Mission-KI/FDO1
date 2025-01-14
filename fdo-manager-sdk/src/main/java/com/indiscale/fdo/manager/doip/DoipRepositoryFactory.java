package com.indiscale.fdo.manager.doip;

import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryConnectionFactory;
import com.indiscale.fdo.manager.api.RepositoryType;

public class DoipRepositoryFactory implements RepositoryConnectionFactory {

  public static final RepositoryType TYPE =
      new RepositoryType("DOIP").description("A repository with DOIP interface.");

  @Override
  public RepositoryConnection createConnection(RepositoryConfig config) {
    return new DoipRepository(config);
  }

  @Override
  public RepositoryType getType() {
    return TYPE;
  }
}
