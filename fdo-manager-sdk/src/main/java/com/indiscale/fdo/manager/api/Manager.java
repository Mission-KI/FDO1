package com.indiscale.fdo.manager.api;

/**
 * The FDO Manager.
 *
 * <p>This is the central API for creating, updating, and deleting FDOs.
 *
 * <p>The Manager has two important subcomponents:
 *
 * <ul>
 *   <li>The repository registry, {@link RepositoryRegistry}, which contains all repositories known
 *       by this manager. That is the list of repositories this manager can interact with.
 *   <li>The profile registry, {@link ProfileRegistry}, which contains all profiles known by this
 *       manager. The manager is capable to validate FDOs (existing or those which are yet to be
 *       created) against these profiles.
 * </ul>
 *
 * <p>Also, the manager can resolve PIDs --- at least those which have been created by this manager
 * instance. Whether or not a PID can be resolved depends on the nature of the PID (is it from a
 * private handle system or the well-known public handle system) and the implementation, whether it
 * is for testing only or for usage with an actual handle system.
 */
public interface Manager extends AutoCloseable {

  /**
   * Create an FDO in the given repository.
   *
   * <p>The main FDO object, as well as the two components (data, metadata), are created in the same
   * repository.
   *
   * <p>The data and metadata objects must validate against the profile.
   *
   * <p>The returned FDO object has a newly minted and valid PID. The PID will resolve without
   * errors using the {@link #resolvePID(String)} method. Whether or not the PID is actually
   * registered with a handle service or can be resolved by {@link https://hdl.handle.net/} depends
   * on the implementation of this class, whether it is for testing only, for usage with actual
   * repositories, in a private handle system or the well-known public handle system.
   *
   * @param profile The FDO profile.
   * @param repository
   * @param data
   * @param metadata
   * @return
   * @throws ValidationException if data or metadata do not validate against the profile.
   */
  public FDO createFDO(
      FdoProfile profile,
      FdoType type,
      RepositoryConnection repository,
      Data data,
      Metadata metadata)
      throws ValidationException;

  public RepositoryRegistry getRepositoryRegistry();

  /**
   * Resolve a pid and return a {@link DigitalObject}.
   *
   * <p>The pid is expected to be valid (i.e. it has been registered in a pid system) and resolvable
   * (i.e. the managers implementation can resolve pid belonging to said pid system).
   *
   * <p>The resolved object is not necessarily an FDO (because the pid could refer to an arbitrary
   * PID Record, an FDO Metadata PID record, an FDO Data PID record, or an actual FDO PID record).
   * Use {@link DigitalObject#isFDO()} to determine whether or not it is in fact an FDO.
   *
   * @param pid persistent identifier.
   * @return Resolved digital object
   * @throws PidUnresolvableException if the pid cannot be resolved.
   */
  public DigitalObject resolvePID(String pid) throws PidUnresolvableException;

  /**
   * Completely delete a {@link DigitalObject}. Only allowed for specific management operations.
   *
   * <p>The pid is expected to be valid (i.e. it has been registered in a pid system) and deletable
   * (i.e. the managers implementation can delete objects belonging to said pid system).
   *
   * @param pid persistent identifier.
   * @return ID of repository the FDO was deleted from, or null if deletion was not successful
   * @throws PidUnresolvableException if the pid cannot be resolved.
   * @throws UnknownRepositoryException if the repo the pid belongs to is unknown.
   */
  public String purgeFDO(String pid) throws PidUnresolvableException, UnknownRepositoryException;

  /**
   * Archive a {@link DigitalObject}. Deletes the data and potentially metadata bit-sequences of an
   * FDO and creates a tombstone note in the Record.
   *
   * @param pid persistent identifier.
   * @param deleteMD indicates whether metadata bit-sequence should also be deleted
   * @return ID of repository the FDO was deleted from, or null if deletion was not successful
   * @throws PidUnresolvableException if the pid cannot be resolved.
   * @throws UnknownRepositoryException if the repo the pid belongs to is unknown.
   */
  public String deleteFDO(String pid, boolean deleteMD)
      throws PidUnresolvableException, UnknownRepositoryException, UnsuccessfulOperationException;

  /** Overload of public String deleteFDO(String pid, boolean deleteMD) with deleteMD = false. */
  public String deleteFDO(String pid)
      throws PidUnresolvableException, UnknownRepositoryException, UnsuccessfulOperationException;

  /**
   * Retrieve the current repository of a {@link DigitalObject}.
   *
   * @param pid persistent identifier.
   * @return ServiceID of repository the FDO currently belongs to.
   * @throws PidUnresolvableException if the pid cannot be resolved.
   * @throws InvalidRecordContentException if the handle record does not have an entry containing a
   *     ServiceID.
   */
  public String getCurrentRepository(String pid)
      throws PidUnresolvableException, InvalidRecordContentException;

  public ProfileRegistry<FdoProfile> getProfileRegistry();

  /**
   * Move the data of an FDO from on repository to another.
   *
   * <p>This is still work-in-progress. Don't expect anything.
   *
   * @param fdo
   * @param fdoRepository
   * @param sourceRepository
   * @param targetRepository
   * @return
   */
  public FDO moveFdoData(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository);

  /**
   * Move the metadata of an FDO from on repository to another.
   *
   * @param fdo
   * @param fdoRepository
   * @param sourceRepository
   * @param targetRepository
   * @return
   */
  public FDO moveFdoMetadata(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository);

  @Override
  public void close();

  /**
   * Return the default profile for this manager.
   *
   * <p>This is still work-in-progress. Don't expect anything.
   *
   * @return
   */
  public FdoProfile getDefaultProfile();
}
