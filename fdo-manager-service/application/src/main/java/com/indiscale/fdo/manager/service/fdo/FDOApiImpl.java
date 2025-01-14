package com.indiscale.fdo.manager.service.fdo;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;

import com.google.gson.JsonElement;
import com.indiscale.fdo.manager.DefaultData;
import com.indiscale.fdo.manager.DefaultMetadata;
import com.indiscale.fdo.manager.DefaultMetadataProfile;
import com.indiscale.fdo.manager.UrlRefData;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.InputStreamSource;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.PidUnresolvableException;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.ValidationException;
import com.indiscale.fdo.manager.service.BaseController;
import com.indiscale.fdo.manager.service.api.model.Links;
import com.indiscale.fdo.manager.service.api.model.ResolvePID200Response;
import com.indiscale.fdo.manager.service.api.model.TargetRepositories;
import com.indiscale.fdo.manager.service.api.operation.FdoApi;
import jakarta.validation.Valid;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.util.HashMap;
import java.util.Map.Entry;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

class MultipartFileWrapper implements InputStreamSource {

  private MultipartFile wrapped;

  public MultipartFileWrapper(MultipartFile file) {
    this.wrapped = file;
  }

  @Override
  public InputStream getInputStream() throws IOException {
    return wrapped.getInputStream();
  }
}

class MetadataWrapper extends DefaultMetadata {

  private MultipartFile file;

  private static MetadataProfile createMetadataProfile(String metadataProfile) {
    if (metadataProfile != null) {

      return new DefaultMetadataProfile(metadataProfile);
    }
    return null;
  }

  public MetadataWrapper(MultipartFile file, String metadataProfile) {
    super(createMetadataProfile(metadataProfile));
    this.file = file;
  }

  @Override
  public InputStream getInputStream() throws IOException {
    return this.file.getInputStream();
  }
}

class DataWrapper extends DefaultData {

  private MultipartFile file;

  public DataWrapper(MultipartFile file) {
    super();
    this.file = file;
  }

  @Override
  public InputStream getInputStream() throws IOException {
    return file.getInputStream();
  }
}

@RestController
@CrossOrigin(
    origins = {"${react-dev-server}"},
    exposedHeaders = {"Location"})
public class FDOApiImpl extends BaseController implements FdoApi {

  @Override
  public ResponseEntity<Void> createFDO(
      @Valid TargetRepositories repositories,
      MultipartFile metadataFile,
      MultipartFile dataFile,
      @Valid URI dataUrl,
      @Valid String metadataProfile,
      @Valid String fdoType) {
    try (Manager manager = getManager()) {
      RepositoryConnection repository =
          manager.getRepositoryRegistry().createRepositoryConnection(repositories.getFdo());
      if (getAuthenticator() != null) {
        getAuthenticator().authenticateWith(repository);
      }
      FdoProfile profile = manager.getDefaultProfile();
      Data data = null;
      if (dataFile != null) {
        data = new DataWrapper(dataFile);
      } else if (dataUrl != null) {
        data = new UrlRefData(dataUrl.toURL());
      } else {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Missing data component.");
      }
      FDO fdo =
          manager.createFDO(
              profile,
              FdoType.getType(fdoType),
              repository,
              data,
              new MetadataWrapper(metadataFile, metadataProfile));
      getLogger().createFDO(fdo, repository);

      // TODO(tf) this is a workaround for the apache proxy
      String[] pid = fdo.getPID().split("/", 2);

      URI location = linkTo(getOperations(FDOApiImpl.class).resolvePID(pid[0], pid[1])).toUri();
      return ResponseEntity.created(location).build();
    } catch (UnknownRepositoryException e) {
      throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not Found. Unknown repository id.");
    } catch (ValidationException e) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.getValidationResult().toString());
    } catch (MalformedURLException e) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.toString());
    }
  }

  @Override
  public ResponseEntity<Void> baseDelete(
      String prefix, String suffix, Boolean purge, Boolean deleteMD) {
    if (purge) {
      return purgeFDO(prefix, suffix);
    }
    throw new ResponseStatusException(HttpStatus.NOT_IMPLEMENTED);
  }

  public ResponseEntity<Void> purgeFDO(String prefix, String suffix) {
    try (Manager manager = getManager()) {
      String pid = prefix + "/" + suffix;
      DigitalObject fdo = manager.resolvePID(pid);
      String repoId = manager.purgeFDO(pid);
      if (repoId != null && !repoId.isEmpty()) {
        RepositoryConnection repository =
            manager.getRepositoryRegistry().createRepositoryConnection(repoId);
        getLogger().purgeFDO(fdo, repository);
        return ResponseEntity.noContent().build();
      } else {
        throw new ResponseStatusException(
            HttpStatus.INTERNAL_SERVER_ERROR, "Could not delete PID " + pid);
      }
    } catch (PidUnresolvableException e) {
      throw new ResponseStatusException(
          HttpStatus.NOT_FOUND, "Not found. Could not resolve PID " + e.getPid());
    } catch (UnknownRepositoryException e) {
      e.printStackTrace();
      throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Not found. Repository unknown.");
    }
  }

  @Override
  public ResponseEntity<ResolvePID200Response> resolvePID(String prefix, String suffix) {
    String pid = prefix + "/" + suffix;
    try (Manager manager = getManager()) {
      DigitalObject resolved = manager.resolvePID(pid);
      return ResponseEntity.ok(createResponse(resolved));
    } catch (PidUnresolvableException e) {
      throw new ResponseStatusException(
          HttpStatus.NOT_FOUND, "Not found. Could not resolve PID " + e.getPid());
    }
  }

  private ResolvePID200Response createResponse(DigitalObject resolved) {
    String[] pid = resolved.getPID().split("/", 2);
    com.indiscale.fdo.manager.service.api.model.DigitalObject data =
        new com.indiscale.fdo.manager.service.api.model.DigitalObject(
            resolved.getPID(), resolved.isFDO());
    Links self = linkSelf(getOperations(getClass()).resolvePID(pid[0], pid[1]));

    if (resolved.isFDO()) {
      FDO fdo = resolved.toFDO();
      if (fdo.getData() != null) {
        data.setDataPid(fdo.getData().getPID());
      }
      if (fdo.getMetadata() != null) {
        data.setMetadataPid(fdo.getMetadata().getPID());
      }
      if (fdo.getType() != null) {
        data.setFdoType(fdo.getType().getPID());
      }
      if (fdo.getProfile() != null) {
        data.setFdoProfile(fdo.getProfile().getPID());
      }
    }
    if (resolved.getAttributes() != null) {
      data.setAttributes(new HashMap<>());
      for (Entry<String, JsonElement> s : resolved.getAttributes().entrySet()) {
        data.getAttributes().put(s.getKey(), s.getValue().getAsString());
      }
    }
    if (resolved.isFdoComponent()) {
      FdoComponent fdoComponent = resolved.toFdoComponent();
      if (fdoComponent.getProfile() != null) data.setFdoProfile(fdoComponent.getProfile().getPID());
    }

    return new ResolvePID200Response().data(data).links(self);
  }
}
