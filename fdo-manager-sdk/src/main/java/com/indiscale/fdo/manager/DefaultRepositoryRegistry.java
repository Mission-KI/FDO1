package com.indiscale.fdo.manager;

import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryConnectionFactory;
import com.indiscale.fdo.manager.api.RepositoryRegistry;
import com.indiscale.fdo.manager.api.RepositoryType;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnknownRepositoryTypeException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class DefaultRepositoryRegistry implements RepositoryRegistry {

  private Map<String, RepositoryConnectionFactory> repositoryTypes = new HashMap<>();

  public static class RepositoryConfigWithFactory implements RepositoryConfig {

    private RepositoryConfig config;
    private RepositoryConnectionFactory factory;

    public RepositoryConfigWithFactory(
        RepositoryConfig config, RepositoryConnectionFactory factory) {
      this.config = config;
      this.factory = factory;
    }

    @Override
    public String getId() {
      return config.getId();
    }

    public RepositoryConnection createConnection() {
      return this.factory.createConnection(config);
    }

    @Override
    public RepositoryType getType() {
      return this.config.getType();
    }

    @Override
    public String get(String key) {
      return this.config.get(key);
    }

    @Override
    public String getDescription() {
      return this.config.getDescription();
    }

    @Override
    public String getMaintainer() {
      return this.config.getMaintainer();
    }
  }

  private Map<String, RepositoryConfigWithFactory> registryMap = new HashMap<>();

  public DefaultRepositoryRegistry() {}

  public DefaultRepositoryRegistry(RepositoryConnectionFactory repositoryFactory) {
    this.registerRepositoryType(repositoryFactory);
  }

  public void registerRepositoryType(RepositoryConnectionFactory factory) {
    if (this.repositoryTypes.containsKey(factory.getType().id)) {
      throw new IllegalArgumentException("Repostory type is alread registered.");
    }
    this.repositoryTypes.put(factory.getType().id, factory);
  }

  public void registerRepository(RepositoryConfig config) throws UnknownRepositoryTypeException {
    if (this.registryMap.containsKey(config.getId())) {
      throw new IllegalArgumentException("Repository ID is already registered.");
    }
    if (config.getType() == null) {
      throw new IllegalArgumentException("config.getType() returned null");
    }
    if (!this.repositoryTypes.containsKey(config.getType().id)) {
      throw new UnknownRepositoryTypeException();
    }
    this.registryMap.put(
        config.getId(),
        new RepositoryConfigWithFactory(config, repositoryTypes.get(config.getType().id)));
  }

  @Override
  public RepositoryConfigWithFactory getRepositoryConfig(String id)
      throws UnknownRepositoryException {
    if (id == null) {
      throw new NullPointerException("id was null");
    }
    RepositoryConfigWithFactory config = this.registryMap.get(id);
    if (config == null) {
      // ToDo: This is a workaround to retrieve RepositoryConfigs by serviceIds.
      //       Alternatively, registryMap might also use serviceIds as keys
      //       or a second registryMap might be added
      for (DefaultRepositoryRegistry.RepositoryConfigWithFactory conf : this.registryMap.values()) {
        if (id.equals(conf.get("serviceId"))) {
          // Matched ServiceId instead of Id
          return conf;
        }
      }
      throw new UnknownRepositoryException();
    }
    return config;
  }

  @Override
  public RepositoryConnection createRepositoryConnection(String id)
      throws UnknownRepositoryException {
    return getRepositoryConfig(id).createConnection();
  }

  @Override
  public List<RepositoryConfig> listRepositories() {
    List<RepositoryConfig> list = new ArrayList<>(this.registryMap.values());
    list.sort(
        new Comparator<RepositoryConfig>() {

          @Override
          public int compare(RepositoryConfig arg0, RepositoryConfig arg1) {
            return arg0.getId().compareTo(arg1.getId());
          }
        });
    return list;
  }

  @Override
  public Set<RepositoryType> getRepositoryTypes() {
    Set<RepositoryType> result = new HashSet<>();
    this.repositoryTypes.forEach((key, value) -> result.add(value.getType()));
    return result;
  }

  @Override
  public RepositoryType getRepositoryType(String type) throws UnknownRepositoryTypeException {
    if (type == null) {
      throw new NullPointerException("type was null");
    }
    if (!this.repositoryTypes.containsKey(type)) {
      throw new UnknownRepositoryTypeException();
    }
    return this.repositoryTypes.get(type).getType();
  }
}
