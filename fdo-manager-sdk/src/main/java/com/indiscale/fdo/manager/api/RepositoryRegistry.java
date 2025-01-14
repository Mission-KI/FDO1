package com.indiscale.fdo.manager.api;

import java.util.List;
import java.util.Set;

/**
 * The repository registry contains a collection of <em>known</em> or even <em>trusted</em>
 * repositories and can create a {@link RepositoryConnection} for those.
 *
 * <p>The repository registry also contains a set of repository types, {@link RepositoryType}. These
 * are types of repositories (e.g. DOIP-Repositories) which are known by or implemented for this
 * registry. The registry is able to create {@link RepositoryConnection} objects for those type (and
 * only for those).
 */
public interface RepositoryRegistry {

  /**
   * Create a repository connection.
   *
   * <p>The connection object is used by the {@link Manager} to interact with repositories.
   *
   * @param id
   * @return
   * @throws UnknownRepositoryException
   */
  public RepositoryConnection createRepositoryConnection(String id)
      throws UnknownRepositoryException;

  /**
   * Return the configuration object for the given repository id.
   *
   * @param id the id of the repository, e.g. "testbed-linkahead".
   * @return
   * @throws UnknownRepositoryException if the id is not known.
   */
  public RepositoryConfig getRepositoryConfig(String id) throws UnknownRepositoryException;

  /** List all known repositories. */
  public List<RepositoryConfig> listRepositories();

  /**
   * Return the repository type for the given repository type id.
   *
   * @param type the id of the repository type, e.g. "doip"
   * @return repository type
   * @throws UnknownRepositoryTypeException if the id is not known.
   */
  public RepositoryType getRepositoryType(String type) throws UnknownRepositoryTypeException;

  /** List all known/understood/implemented repository types (e.g. DOIP-Repositories). */
  public Set<RepositoryType> getRepositoryTypes();
}
