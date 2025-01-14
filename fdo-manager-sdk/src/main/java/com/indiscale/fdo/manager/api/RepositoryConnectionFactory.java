package com.indiscale.fdo.manager.api;

/**
 * Reusable factory for creating {@link RepositoryConnection} object from {@link RepositoryConfig}.
 *
 * <p>Each factory only works for a single {@link RepositoryType}.
 *
 * <p>This abstraction is mainly used to facilitate the implementation of a pool of reusable
 * connection objects.
 */
public interface RepositoryConnectionFactory {

  /** Factory method for creating a new (or */
  public RepositoryConnection createConnection(RepositoryConfig config);

  /** The factory work for this repository type only. */
  public RepositoryType getType();
}
