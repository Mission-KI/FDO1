package com.indiscale.fdo.manager.api;

/**
 * Description and configuration of a particular repository, e.g. the LinkAhaed-based repository of
 * the FDO test bed.
 *
 * <p>The actual configuration is to be stored as key-value pairs and to be retrieved via {@link
 * #get(String)}. The keys which are expected to be present implicitly depend on implementation of
 * the {@link RepositoryConnectionFactory} for this type.
 */
public interface RepositoryConfig {

  /**
   * The id of this configuration. This needs to be a unique string for every repository registry
   * because it is used to identify the repositories.
   */
  public String getId();

  /**
   * Short description of repository intended for human readers.
   *
   * @return
   */
  public String getDescription();

  /**
   * Name and possibly contact info for the repository's responsible administrator, maintainer,
   * service provider, or the like.
   */
  public String getMaintainer();

  /** The repository type, e.g. DOIP. */
  public RepositoryType getType();

  /**
   * Getter for the key-value-based configuration. This is used by a @link {@link
   * RepositoryConnectionFactory} to create a {@link RepositoryConnection} object. Typical keys are
   * "host", "port", "publicKey".
   *
   * @param key
   * @return
   */
  public String get(String key);

  /**
   * Getter for the key-value-based configuration with fallback option.
   *
   * <p>This is used by a @link {@link RepositoryConnectionFactory} to create a {@link
   * RepositoryConnection} object. Typical keys are "host", "port", "publicKey".
   *
   * @param key
   * @param fallback return this when value would be null
   * @return
   */
  public default String get(String key, String fallback) {
    String value = get(key);
    if (value != null) {
      return value;
    }
    return fallback;
  }
}
