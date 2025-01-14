package com.indiscale.fdo.manager.mock;

import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryConnectionFactory;
import com.indiscale.fdo.manager.api.RepositoryType;
import java.util.Map;

public class MockRepositoryFactory implements RepositoryConnectionFactory {

  static class MockRepositoryConfig implements RepositoryConfig {

    private final String id;

    public MockRepositoryConfig(String id) {
      this.id = id;
    }

    @Override
    public String getId() {
      return id;
    }

    @Override
    public RepositoryType getType() {
      return TYPE;
    }

    @Override
    public String get(String key) {
      return null;
    }

    @Override
    public String getDescription() {
      return "This is not real.";
    }

    @Override
    public String getMaintainer() {
      return "Mocking Institute of Technology";
    }
  }

  public static final RepositoryType TYPE =
      new RepositoryType("MockDOIP").description("A mock-up for a DOIP repository.");
  private final Map<String, MockHandleRecord> registry;

  public MockRepositoryFactory(Map<String, MockHandleRecord> registry) {
    this.registry = registry;
  }

  @Override
  public RepositoryConnection createConnection(RepositoryConfig config) {
    return new MockRepository(config, this.registry);
  }

  @Override
  public RepositoryType getType() {
    return TYPE;
  }

  public RepositoryConfig createMockConfig(String id) {
    return new MockRepositoryConfig(id);
  }
}
