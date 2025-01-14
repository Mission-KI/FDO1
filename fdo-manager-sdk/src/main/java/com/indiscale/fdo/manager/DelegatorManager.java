package com.indiscale.fdo.manager;

import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.InvalidRecordContentException;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.PidUnresolvableException;
import com.indiscale.fdo.manager.api.ProfileRegistry;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryRegistry;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;

public class DelegatorManager implements Manager {

  private Manager delegate;

  public DelegatorManager(Manager delegate) {
    this.delegate = delegate;
  }

  @Override
  public FDO createFDO(
      FdoProfile profile,
      FdoType type,
      RepositoryConnection repository,
      Data data,
      Metadata metadata)
      throws ValidationException {
    return delegate.createFDO(profile, type, repository, data, metadata);
  }

  @Override
  public String purgeFDO(String pid) throws PidUnresolvableException, UnknownRepositoryException {
    return delegate.purgeFDO(pid);
  }

  @Override
  public String deleteFDO(String pid, boolean deleteMD)
      throws PidUnresolvableException, UnknownRepositoryException, UnsuccessfulOperationException {
    return delegate.deleteFDO(pid);
  }

  @Override
  public String deleteFDO(String pid)
      throws PidUnresolvableException, UnknownRepositoryException, UnsuccessfulOperationException {
    return deleteFDO(pid, false);
  }

  @Override
  public RepositoryRegistry getRepositoryRegistry() {
    return delegate.getRepositoryRegistry();
  }

  @Override
  public DigitalObject resolvePID(String pid) throws PidUnresolvableException {
    return delegate.resolvePID(pid);
  }

  @Override
  public String getCurrentRepository(String pid)
      throws PidUnresolvableException, InvalidRecordContentException {
    return delegate.getCurrentRepository(pid);
  }

  @Override
  public ProfileRegistry<FdoProfile> getProfileRegistry() {
    return delegate.getProfileRegistry();
  }

  @Override
  public void close() {
    delegate.close();
  }

  @Override
  public FDO moveFdoData(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository) {
    return delegate.moveFdoData(fdo, fdoRepository, sourceRepository, targetRepository);
  }

  @Override
  public FDO moveFdoMetadata(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository) {
    return delegate.moveFdoMetadata(fdo, fdoRepository, sourceRepository, targetRepository);
  }

  @Override
  public FdoProfile getDefaultProfile() {
    return delegate.getDefaultProfile();
  }
}
