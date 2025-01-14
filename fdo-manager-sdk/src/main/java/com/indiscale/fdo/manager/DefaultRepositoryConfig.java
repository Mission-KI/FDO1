package com.indiscale.fdo.manager;

import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryType;
import java.util.Map;
import java.util.Objects;

public class DefaultRepositoryConfig implements RepositoryConfig {

  private final RepositoryType type;
  private final String id;
  private final Map<String, String> attributes;
  private String description;
  private String maintainer;

  public DefaultRepositoryConfig(
      RepositoryType type, String id, String description, String maintainer) {
    this(type, id, description, maintainer, null);
  }

  public DefaultRepositoryConfig(
      RepositoryType type,
      String id,
      String description,
      String maintainer,
      Map<String, String> attributes) {
    this.type = type;
    this.id = id;
    this.description = description;
    this.maintainer = maintainer;
    this.attributes = attributes;
  }

  public DefaultRepositoryConfig(RepositoryType repositoryType, String id) {
    this(repositoryType, id, null, null);
  }

  public DefaultRepositoryConfig(
      RepositoryType repositoryType, String id, Map<String, String> attr) {
    this(repositoryType, id, null, null, attr);
  }

  @Override
  public String getId() {
    return id;
  }

  @Override
  public RepositoryType getType() {
    return this.type;
  }

  @Override
  public String get(String key) {
    if (attributes == null) {
      return null;
    }
    return attributes.get(key);
  }

  @Override
  public boolean equals(Object obj) {
    if (obj == this) {
      return true;
    }
    if (obj != null && obj instanceof DefaultRepositoryConfig) {
      DefaultRepositoryConfig that = (DefaultRepositoryConfig) obj;
      return Objects.equals(that.id, this.id)
          && Objects.equals(that.type, this.type)
          && Objects.equals(that.attributes, this.attributes);
    }
    return this == obj;
  }

  @Override
  public String getDescription() {
    return description;
  }

  @Override
  public String getMaintainer() {
    return maintainer;
  }
}
