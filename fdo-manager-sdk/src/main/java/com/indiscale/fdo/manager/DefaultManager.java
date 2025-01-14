package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.FdoUpdate;
import com.indiscale.fdo.manager.api.InvalidRecordContentException;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.PidUnresolvableException;
import com.indiscale.fdo.manager.api.ProfileValidator;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.UnknownProfileException;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import java.io.InputStream;
import java.util.List;
import net.handle.api.HSAdapter;
import net.handle.api.HSAdapterFactory;
import net.handle.hdllib.HandleException;
import net.handle.hdllib.HandleValue;

class DefaultFdoUpdate extends DelegatorFdo implements FdoUpdate {

  private boolean isUpdateData = false;
  private Data data;
  private boolean isUpdateMetadata = false;
  private Metadata metadata;

  private DefaultFdoUpdate(FDO original) {
    super(original);
  }

  public static FdoUpdate createUpdateFdo(FDO fdo, Data updateData) {
    return new DefaultFdoUpdate(fdo).updateData(updateData);
  }

  private FdoUpdate updateData(Data updateData) {
    this.isUpdateData = true;
    this.data = updateData;
    return this;
  }

  @Override
  public Data getData() {
    if (data != null) {
      return data;
    }
    return super.getData();
  }

  public boolean isUpdateData() {
    return isUpdateData;
  }

  public static FdoUpdate createUpdateFdo(FDO fdo, Metadata updateMetadata) {
    return new DefaultFdoUpdate(fdo).updateMetadata(updateMetadata);
  }

  private FdoUpdate updateMetadata(Metadata updateMetadata) {
    this.isUpdateMetadata = true;
    this.metadata = updateMetadata;
    return this;
  }

  @Override
  public Metadata getMetadata() {
    if (metadata != null) {
      return metadata;
    }
    return super.getMetadata();
  }

  public boolean isUpdateMetadata() {
    return isUpdateMetadata;
  }
}

class UnknownFdoProfile implements FdoProfile {

  private String id;
  private String pid;

  public UnknownFdoProfile(String id, String pid) {
    this.id = id;
    this.pid = pid;
  }

  @Override
  public String getId() {
    return id;
  }

  @Override
  public String getDescription() {
    return "Unknown profile. This profile cannot be validated by the FDO Manager";
  }

  @Override
  public String getPID() {
    return pid;
  }

  @Override
  public ProfileValidator<FDO> getValidator() {
    return null;
  }

  @Override
  public JsonObject getAttributes() {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public boolean isFDO() {
    // TODO Auto-generated method stub
    return false;
  }

  @Override
  public FDO toFDO() {
    // TODO Auto-generated method stub
    return null;
  }
}

public class DefaultManager implements Manager {

  private DefaultRepositoryRegistry repositoryRegistry;
  private DefaultProfileRegistry<FdoProfile> profileRegistry;
  private FdoProfile defaultProfile = null;

  public DefaultManager() {
    this(new DefaultRepositoryRegistry(), new DefaultProfileRegistry<FdoProfile>());
  }

  public DefaultManager(
      DefaultRepositoryRegistry registry, DefaultProfileRegistry<FdoProfile> profileRegistry) {
    this.repositoryRegistry = registry;
    this.profileRegistry = profileRegistry;
  }

  @Override
  public FdoProfile getDefaultProfile() {
    return this.defaultProfile;
  }

  public void setDefaultProfile(String profile) throws UnknownProfileException {
    if (profileRegistry.getProfile(profile) != null) {
      this.defaultProfile = profileRegistry.getProfile(profile);
    } else {
      throw new UnknownProfileException(profile);
    }
  }

  public DefaultManager defaultProfile(String profile) throws UnknownProfileException {
    this.setDefaultProfile(profile);
    return this;
  }

  @Override
  public DefaultRepositoryRegistry getRepositoryRegistry() {
    return repositoryRegistry;
  }

  @Override
  public void close() {
    // TODO close open connections
  }

  @Override
  public DigitalObject resolvePID(String pid) throws PidUnresolvableException {
    HSAdapter hs = HSAdapterFactory.newInstance();
    try {
      HandleValue[] handle = hs.resolveHandle(pid, null, null);
      return createDigitalObject(pid, handle);

    } catch (HandleException e) {
      if (e.getCode() == HandleException.HANDLE_DOES_NOT_EXIST) {
        throw new PidUnresolvableException(pid);
      } else if (e.getCause() != null && e.getCause().toString().contains("SERVICE_NOT_FOUND")) {
        throw new PidUnresolvableException(pid);
      } else e.printStackTrace();
    }
    return null;
  }

  @Override
  public String getCurrentRepository(String pid)
      throws PidUnresolvableException, InvalidRecordContentException {
    HSAdapter hs = HSAdapterFactory.newInstance();
    try {
      String[] types = {"0.TYPE/DOIPService"};
      HandleValue[] handle = hs.resolveHandle(pid, types, null);
      for (HandleValue val : handle) {
        if ("0.TYPE/DOIPService".equals(val.getTypeAsString())) {
          return val.getDataAsString();
        }
      }
      throw new InvalidRecordContentException("Repository not saved in Handle record.");
    } catch (HandleException e) {
      if (e.getCode() == HandleException.HANDLE_DOES_NOT_EXIST) {
        throw new PidUnresolvableException(pid);
      } else if (e.getCause() != null && e.getCause().toString().contains("SERVICE_NOT_FOUND")) {
        throw new PidUnresolvableException(pid);
      } else {
        e.printStackTrace();
        throw new PidUnresolvableException(pid);
      }
    }
  }

  private DigitalObject createDigitalObject(String pid, HandleValue[] handle) {
    String doipServiceRef = null;
    String dataRefs = null;
    String metadataRefs = null;
    String profileRefs = null;
    String typeRef = null;
    JsonObject attributes = new JsonObject();
    for (HandleValue val : handle) {
      attributes.add(val.getTypeAsString(), new JsonPrimitive(val.getDataAsString()));
      switch (val.getTypeAsString()) {
        case "0.TYPE/DOIPService":
          doipServiceRef = val.getDataAsString();
          break;
        case "FDO_Profile_Ref":
          profileRefs = val.getDataAsString();
          break;
        case "FDO_Data_Refs":
          dataRefs = val.getDataAsString().replaceFirst("^\\[", "").replaceFirst("]$", "");
          break;
        case "FDO_MD_Refs":
          metadataRefs = val.getDataAsString().replaceFirst("^\\[", "").replaceFirst("]$", "");
          break;
        case "FDO_Type_Ref":
          typeRef = val.getDataAsString();
          break;
        default:
          break;
      }
    }
    if (doipServiceRef != null && profileRefs != null) {
      FdoProfile profile;

      FdoType type = null;
      try {
        profile = getProfileRegistry().getProfile(profileRefs);
      } catch (UnknownProfileException e) {
        profile = new UnknownFdoProfile("Unknown Profile", profileRefs);
      }
      if (typeRef != null) {
        type = new DefaultFdoType(typeRef);
      }
      return new DefaultFdo(
          pid,
          attributes,
          profile,
          new LazyResolutionData(this, dataRefs),
          new LazyResolutionMetadata(this, metadataRefs),
          type,
          null);
    }
    return new NonFdoDigitalObject(pid, attributes);
  }

  @Override
  public FDO createFDO(
      FdoProfile profile,
      FdoType type,
      RepositoryConnection repository,
      Data data,
      Metadata metadata)
      throws ValidationException {
    FDO fdo = new DefaultFdo(null, profile, type, data, metadata);
    fdo.validate();
    return repository.createFDO(fdo);
  }

  @Override
  public String purgeFDO(String pid) throws PidUnresolvableException, UnknownRepositoryException {
    DigitalObject d_o = resolvePID(pid);
    // Connect to repository the fdo is saved in
    RepositoryConnection repository = null;
    try {
      repository = repositoryRegistry.createRepositoryConnection(getCurrentRepository(pid));
    } catch (InvalidRecordContentException e) {
      throw new UnknownRepositoryException();
    }
    // Delete FDO including data + metadata
    if (d_o.isFDO()) {
      // Todo: we might need a deep copy of data / metadata for rollback
      // Todo: Recreation of data/metadata - ensure re-registering with handle etc. (new PIDs?)
      FDO fdo = d_o.toFDO();
      Data data = fdo.getData();
      Metadata metadata = fdo.getMetadata();
      // Delete FDO
      try {
        repository.purgeDO(pid);
      } catch (UnsuccessfulOperationException e) {
        e.printStackTrace();
        // Fail: Rollback changes and abort
        // Todo: if (data != null) fdo.setData(new Data(data))
        // Todo: if (metadata != null) fdo.setMetadata(new Metadata(metadata))
        return null;
      }
      // Delete data
      if (data != null) {
        if (purgeFDO(data.getPID()) == null) {
          // Fail: Rollback changes (if there are any) and abort
          // Todo: fdo.setData(new Data(data))
          return null; // ToDo: UnsuccessfulOperationException
        }
      }
      // Delete metadata
      if (metadata != null) {
        if (purgeFDO(metadata.getPID()) == null) {
          // Fail: Rollback changes and abort
          // Todo: if (data != null) fdo.setData(new Data(data))
          // Todo: fdo.setMetadata(new Metadata(metadata))
          return null;
        }
      }
      // Successful delete of FDO
      return repository.getId();
    }
    // Delete non-FDO digital object (data/metadata etc.)
    try {
      repository.purgeDO(pid);
      return repository.getId();
    } catch (UnsuccessfulOperationException e) {
      e.printStackTrace();
      return null;
    }
  }

  @Override
  public String deleteFDO(String pid, boolean deleteMD)
      throws IllegalArgumentException,
          PidUnresolvableException,
          UnknownRepositoryException,
          UnsuccessfulOperationException {
    DigitalObject d_o = resolvePID(pid);
    // Connect to repository the fdo is saved in
    RepositoryConnection repository = null;
    try {
      repository = repositoryRegistry.createRepositoryConnection(getCurrentRepository(pid));
    } catch (InvalidRecordContentException e) {
      throw new UnknownRepositoryException();
    }
    if (d_o == null || !d_o.isFDO()) {
      throw new IllegalArgumentException("Digital Object with PID " + pid + "is not an FDO.");
    }
    FDO fdo = d_o.toFDO();
    Data data = fdo.getData();
    Metadata metadata = fdo.getMetadata();
    // 1. Delete data bit-sequence
    List<InputStream> dataFiles = null;
    List<InputStream> metadataFiles = null;
    try {
      dataFiles = repository.deleteFilesFromDo(data.getPID());
    } catch (UnsuccessfulOperationException e) {
      // No operations have successfully concluded yet
      return null;
    }
    // 3. If delete_MD, delete metadata bit-sequence
    if (deleteMD) {
      try {
        metadataFiles = repository.deleteFilesFromDo(metadata.getPID());
      } catch (UnsuccessfulOperationException e) {
        // If any of the listed operations fails, all operations are rolled back
        if (dataFiles != null) {
          repository.addFilesToDo(data.getPID(), dataFiles);
        }
      }
    }
    // 2. Update data-attributes: FDO_status set to “deleted”, “URL_status” added
    String dataFdoStatus = null;
    boolean dataFdoStatusSet = false;
    String dataUrlStatus = null;
    boolean dataUrlStatusSet = false;
    try {
      dataFdoStatus = repository.createUpdateDoAttribute(data.getPID(), "FDO_Status", "deleted");
      dataFdoStatusSet = true;
      dataUrlStatus = repository.createUpdateDoAttribute(data.getPID(), "URL_Status", "");
      dataUrlStatusSet = true;
    } catch (UnsuccessfulOperationException e) {
      // If any of the listed operations fails, all operations are rolled back
      if (dataFiles != null) {
        repository.addFilesToDo(data.getPID(), dataFiles);
      }
      if (metadataFiles != null) {
        repository.addFilesToDo(metadata.getPID(), metadataFiles);
      }
      if (dataFdoStatusSet) {
        if (dataFdoStatus != null) {
          repository.createUpdateDoAttribute(data.getPID(), "FDO_Status", dataFdoStatus);
        } else {
          repository.deleteDoAttribute(data.getPID(), "FDO_Status");
        }
      }
    }
    // 3. If delete_MD, update metadata-attributes analogously to data-attributes
    String metadataFdoStatus = null;
    boolean metadataFdoStatusSet = false;
    String metadataUrlStatus = null;
    boolean metadataUrlStatusSet = false;
    if (deleteMD) {
      try {
        metadataFdoStatus =
            repository.createUpdateDoAttribute(metadata.getPID(), "FDO_status", "deleted");
        metadataFdoStatusSet = true;
        metadataUrlStatus = repository.createUpdateDoAttribute(metadata.getPID(), "URL_status", "");
        metadataUrlStatusSet = true;
      } catch (UnsuccessfulOperationException e) {
        // If any of the listed operations fails, all operations are rolled back
        if (dataFiles != null) {
          repository.addFilesToDo(data.getPID(), dataFiles);
        }
        if (metadataFiles != null) {
          repository.addFilesToDo(metadata.getPID(), metadataFiles);
        }
        if (dataFdoStatusSet) {
          if (dataFdoStatus != null) {
            repository.createUpdateDoAttribute(data.getPID(), "FDO_status", dataFdoStatus);
          } else {
            repository.deleteDoAttribute(data.getPID(), "FDO_status");
          }
        }
        if (dataUrlStatusSet) {
          if (dataUrlStatus != null) {
            repository.createUpdateDoAttribute(data.getPID(), "URL_status", dataUrlStatus);
          } else {
            repository.deleteDoAttribute(data.getPID(), "URL_status");
          }
        }
        if (metadataFdoStatusSet) {
          if (metadataFdoStatus != null) {
            repository.createUpdateDoAttribute(metadata.getPID(), "FDO_status", dataFdoStatus);
          } else {
            repository.deleteDoAttribute(metadata.getPID(), "FDO_status");
          }
        }
      }
    }
    // 4. FDO_status set to “deleted”
    try {
      repository.createUpdateDoAttribute(fdo.getPID(), "FDO_status", "deleted");
    } catch (UnsuccessfulOperationException e) {
      // If any of the listed operations fails, all operations are rolled back
      if (dataFiles != null) {
        repository.addFilesToDo(data.getPID(), dataFiles);
      }
      if (metadataFiles != null) {
        repository.addFilesToDo(metadata.getPID(), metadataFiles);
      }
      if (dataFdoStatusSet) {
        if (dataFdoStatus != null) {
          repository.createUpdateDoAttribute(data.getPID(), "FDO_status", dataFdoStatus);
        } else {
          repository.deleteDoAttribute(data.getPID(), "FDO_status");
        }
      }
      if (dataUrlStatusSet) {
        if (dataUrlStatus != null) {
          repository.createUpdateDoAttribute(data.getPID(), "URL_status", dataUrlStatus);
        } else {
          repository.deleteDoAttribute(data.getPID(), "URL_status");
        }
      }
      if (metadataFdoStatusSet) {
        if (metadataFdoStatus != null) {
          repository.createUpdateDoAttribute(metadata.getPID(), "FDO_status", dataFdoStatus);
        } else {
          repository.deleteDoAttribute(metadata.getPID(), "FDO_status");
        }
      }
      if (metadataUrlStatusSet) {
        if (metadataUrlStatus != null) {
          repository.createUpdateDoAttribute(metadata.getPID(), "URL_status", dataUrlStatus);
        } else {
          repository.deleteDoAttribute(metadata.getPID(), "URL_status");
        }
      }
    }
    return repository.getId();
  }

  @Override
  public String deleteFDO(String pid)
      throws PidUnresolvableException, UnknownRepositoryException, UnsuccessfulOperationException {
    return deleteFDO(pid, false);
  }

  @Override
  public DefaultProfileRegistry<FdoProfile> getProfileRegistry() {
    return profileRegistry;
  }

  @Override
  public FDO moveFdoData(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository) {
    // Copy component to new repository
    Data dataCopy = targetRepository.copyFdoComponent(fdo.getData());

    // We update the FDO before we delete the old component object such that the FDO record is
    // always valid.
    FdoUpdate updateFdo = DefaultFdoUpdate.createUpdateFdo(fdo, dataCopy);
    FDO resultFdo = fdoRepository.updateFdo(updateFdo);

    sourceRepository.deleteFdoComponent(fdo.getData(), resultFdo.getPID());
    return resultFdo;

    // TODO roll-back
  }

  @Override
  public FDO moveFdoMetadata(
      FDO fdo,
      RepositoryConnection fdoRepository,
      RepositoryConnection sourceRepository,
      RepositoryConnection targetRepository) {
    // Copy component to new repository
    Metadata metadataCopy = targetRepository.copyFdoComponent(fdo.getMetadata());

    // We update the FDO before we delete the old component object such that the FDO record is
    // always valid.
    FdoUpdate updateFdo = DefaultFdoUpdate.createUpdateFdo(fdo, metadataCopy);
    FDO resultFdo = fdoRepository.updateFdo(updateFdo);

    sourceRepository.deleteFdoComponent(fdo.getMetadata(), resultFdo.getPID());
    return resultFdo;

    // TODO roll-back
  }
}
