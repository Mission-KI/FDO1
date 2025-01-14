package com.indiscale.fdo.manager.api;

import com.google.gson.JsonObject;
import java.io.InputStream;
import java.util.List;

public interface RepositoryConnection extends AutoCloseable {

  public void setTokenAuthenticationInfo(TokenAuthenticationInfo authentication);

  public void setCredentialsAuthenticationInfo(CredentialsAuthenticationInfo authentication);

  public String getId();

  public RepositoryType getType();

  @Override
  public void close();

  public boolean isOnline();

  public FDO createFDO(FDO fdo) throws ValidationException;

  /**
   * Performs the Operation "0.DOIP/Op.Delete" on the FDO or FDO component (Data or Metadata),
   * resulting in the Object being deleted from the repository and handle system.
   *
   * @param pid persistent identifier of object to be deleted
   * @throws UnsuccessfulOperationException if the operation is aborted. The status of the record is
   *     unknown.
   */
  public void purgeDO(String pid) throws UnsuccessfulOperationException;

  /**
   * Deletes all files contained in the payload of a Digital Object.
   *
   * @param pid persistent identifier of object from which file will be deleted
   * @return List of deleted InputStreams, null if no InputStreams were deleted
   * @throws UnsuccessfulOperationException if the operation is aborted. The status of the record is
   *     unknown.
   */
  public List<InputStream> deleteFilesFromDo(String pid) throws UnsuccessfulOperationException;

  /**
   * Adds files to a Digital Object.
   *
   * @param pid persistent identifier of object to which the files will be added
   * @param files List of files to be added
   * @throws UnsuccessfulOperationException if the operation is aborted. The status of the record is
   *     unknown.
   */
  public void addFilesToDo(String pid, List<InputStream> files)
      throws UnsuccessfulOperationException;

  /**
   * Retrieves the files contained in the payload of a Digital Object. Does not modify the record.
   *
   * @param pid persistent identifier of object from which files will be retrieved
   * @return List of InputStreams
   * @throws UnsuccessfulOperationException if the operation is aborted.
   */
  public List<InputStream> retrieveFilesFromDo(String pid) throws UnsuccessfulOperationException;

  /**
   * Deletes an attribute from a Digital Object.
   *
   * @param pid persistent identifier of object to change
   * @param key Key of the attribute to delete
   * @return String of the previous value, null if the key did not exist
   * @throws UnsuccessfulOperationException if the operation is aborted. The status of the record is
   *     unknown.
   */
  public String deleteDoAttribute(String pid, String key) throws UnsuccessfulOperationException;

  /**
   * Adds an attribute to a Digital Object or updates an existing one.
   *
   * @param pid persistent identifier of object to change
   * @param key Key of the attribute to add or modify
   * @param value Key of the attribute to add or modify
   * @return String of the previous value, null if the key has been newly created
   * @throws UnsuccessfulOperationException if the operation is aborted. The status of the record is
   *     unknown.
   */
  public String createUpdateDoAttribute(String pid, String key, String value)
      throws UnsuccessfulOperationException;

  /**
   * Retrieves the attributes of a Digital Object. Does not modify the record.
   *
   * @param pid persistent identifier of object from which attributes will be retrieved
   * @return JsonObject of record attributes
   * @throws UnsuccessfulOperationException if the operation is aborted.
   */
  public JsonObject retrieveAttributesFromDo(String pid) throws UnsuccessfulOperationException;

  /**
   * Copy the FDO component (Data or Metadata) to the current repository.
   *
   * @param <T>
   * @param component
   * @return The new component
   */
  public <T extends FdoComponent> T copyFdoComponent(T component);

  /**
   * Update the FDO (Repository-Representation and PID Record).
   *
   * <p>This is only type, profile, and attributes. Data and Metadata will not be touched.
   *
   * @param fdo
   * @return updated FDO
   */
  public FDO updateFdo(FdoUpdate fdo);

  /**
   * Delete the old component (Data or Metadata).
   *
   * <p>Note: Deletion only means deletion from the repository. The handle must stay intact. If the
   * repository supports this, an HS_ALIAS should be set, pointing to the new PID.
   *
   * @param oldComponent
   * @param newPid
   */
  public void deleteFdoComponent(FdoComponent oldComponent, String newPid);
}
