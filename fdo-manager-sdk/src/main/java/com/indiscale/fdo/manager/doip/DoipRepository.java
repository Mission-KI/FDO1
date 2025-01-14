package com.indiscale.fdo.manager.doip;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.indiscale.fdo.manager.api.AuthenticationException;
import com.indiscale.fdo.manager.api.CredentialsAuthenticationInfo;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoUpdate;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryType;
import com.indiscale.fdo.manager.api.TokenAuthenticationInfo;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import com.indiscale.fdo.manager.util.Util;
import java.io.IOException;
import java.io.InputStream;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.UUID;
import net.dona.doip.DoipConstants;
import net.dona.doip.client.AuthenticationInfo;
import net.dona.doip.client.DigitalObject;
import net.dona.doip.client.DoipClient;
import net.dona.doip.client.DoipException;
import net.dona.doip.client.Element;
import net.dona.doip.client.PasswordAuthenticationInfo;
import net.dona.doip.client.QueryParams;
import net.dona.doip.client.SearchResults;
import net.dona.doip.client.ServiceInfo;

public class DoipRepository implements RepositoryConnection {

  @Override
  public void setTokenAuthenticationInfo(TokenAuthenticationInfo authentication) {
    this.auth =
        new net.dona.doip.client.TokenAuthenticationInfo(
            service.serviceId, authentication.getToken());
  }

  @Override
  public void setCredentialsAuthenticationInfo(CredentialsAuthenticationInfo authentication) {
    this.auth =
        new net.dona.doip.client.PasswordAuthenticationInfo(
            authentication.getUsername(), authentication.getPassword());
  }

  java.util.logging.Logger logger =
      java.util.logging.Logger.getLogger(DoipRepository.class.getName());

  private final ServiceInfo service;
  private AuthenticationInfo auth;

  @Override
  public boolean isOnline() {
    try (DoipClient client = new DoipClient()) {
      client.hello(config.get("serviceId"), this.auth, service);
      return true;
    } catch (DoipException e) {
      e.printStackTrace();
      return false;
    }
  }

  public void list() {
    try (DoipClient client = new DoipClient()) {
      SearchResults<String> searchIds =
          client.searchIds("test", "test", new QueryParams(-1, -1), auth, service);
      for (String id : searchIds) {
        System.out.println(id);
      }
    } catch (DoipException e) {
      e.printStackTrace();
    }
  }

  private final RepositoryConfig config;

  public DoipRepository(RepositoryConfig config) {
    this.config = config;
    this.service =
        new ServiceInfo(
            config.get("serviceId"), config.get("host"), Integer.parseInt(config.get("port")));
    if (config.get("publicKey") != null) {
      try {
        service.publicKey = Util.ascToPublicKey(config.get("publicKey"));

      } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
        e.printStackTrace();
      }
    } else {
      logger.warning("DoipRepository needs publicKey");
    }
    if (config.get("username") != null && config.get("password") != null) {
      this.auth = new PasswordAuthenticationInfo(config.get("username"), config.get("password"));
    } else {
      this.auth = null;
    }
  }

  DigitalObject toDO(FdoComponent component) throws IOException {
    DigitalObject dataobject = new DigitalObject();
    dataobject.type = getTypeDo();
    dataobject.attributes = new JsonObject();
    if (component.getAttributes() != null) {
      dataobject.setAttribute("content", component.getAttributes());
    } else {
      dataobject.setAttribute("content", new JsonObject());
    }
    if (component.getProfile() != null) {
      dataobject
          .attributes
          .get("content")
          .getAsJsonObject()
          .add(getProfileType(), new JsonPrimitive(component.getProfile().getPID()));
    }
    if (component.getInputStream() != null) {
      dataobject.elements = new ArrayList<>();

      Element dataelement = new Element();
      dataelement.id = UUID.randomUUID().toString();
      dataelement.type = "application/octet-stream";
      dataelement.in = component.getInputStream();
      dataobject.elements.add(dataelement);
    }
    return dataobject;
  }

  private String getProfileType() {
    return config.get("typeProfileRef");
  }

  private String getTypeFdo() {
    return config.get("typeFdo");
  }

  private String getTypeDo() {
    return config.get("typeDo");
  }

  public String getTypeStatus() {
    return config.get("typeStatus");
  }

  public String getTypeFdoType() {
    return config.get("typeFdoType", "FDO_Type_Ref");
  }

  DigitalObject toFDO(FDO fdoIn, DigitalObject dataDo, DigitalObject metadataDo)
      throws IOException {
    JsonObject attributes = fdoIn.getAttributes();
    DigitalObject fdo = new DigitalObject();
    fdo.type = getTypeFdo();
    fdo.attributes = new JsonObject();
    if (attributes != null) {
      fdo.setAttribute("content", attributes);
    } else {
      fdo.setAttribute("content", new JsonObject());
    }

    JsonObject content = fdo.attributes.getAsJsonObject("content");
    if (fdoIn.getProfile() != null) {

      content.add(getProfileType(), new JsonPrimitive(fdoIn.getProfile().getPID()));
    } else {
      content.add(getProfileType(), new JsonPrimitive(Util.FDO_KIP));
    }
    if (fdoIn.getType() != null) {
      content.add(getTypeFdoType(), new JsonPrimitive(fdoIn.getType().getPID()));
    }
    if (dataDo != null) {
      JsonArray arr = new JsonArray();
      arr.add(new JsonPrimitive(dataDo.id));
      content.add(getTypeDataRef(), arr);
    }
    if (metadataDo != null) {
      JsonArray arr = new JsonArray();
      arr.add(new JsonPrimitive(metadataDo.id));
      content.add(getTypeMDRef(), arr);
    }
    return fdo;
  }

  private String getTypeDataRef() {
    return config.get("typeDataRef");
  }

  private String getTypeMDRef() {
    return config.get("typeMDRef");
  }

  @Override
  public FDO createFDO(FDO fdo) throws ValidationException {
    Data data = fdo.getData();
    Metadata metadata = fdo.getMetadata();

    try (DoipClient client = new DoipClient()) {
      DigitalObject dataDo = null;
      DigitalObject metadataDo = null;

      if (data != null) {
        dataDo = client.create(this.toDO(data), this.auth, service);
      }
      if (metadata != null) {
        metadataDo = client.create(this.toDO(metadata), this.auth, service);
      }

      DigitalObject fdopid = client.create(this.toFDO(fdo, dataDo, metadataDo), this.auth, service);
      return new DoipFdo(dataDo, metadataDo, fdopid);

    } catch (DoipException e) {
      // TODO handle exception
      e.printStackTrace();
    } catch (IOException e) {
      // TODO handle exception
      e.printStackTrace();
    }
    return null;
  }

  @Override
  public void purgeDO(String pid) throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      client.delete(pid, this.auth, service);
      return;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public List<InputStream> deleteFilesFromDo(String pid) throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      JsonObject attrRetrieve = new JsonObject();
      attrRetrieve.addProperty("includeElementData", true);
      DigitalObject d_o = client.retrieve(pid, attrRetrieve, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }

      JsonArray elementsToDelete = new JsonArray();
      List<InputStream> deletedFiles = new ArrayList<>();
      if (d_o.elements != null && !d_o.elements.isEmpty()) {
        for (Element el : d_o.elements) {
          deletedFiles.add(el.in);
          if (el.length == 0) {
            // If we retrieve empty elements with "includeElementData" and then call update, Cordra
            // closes the connection. I hope this fixes the problem, but the fix is not tested.
            el.in = null;
          }
          // Note: This queues ALL elements to be deleted without any checks.
          elementsToDelete.add(el.id);
        }
      } else {
        return null; // Nothing to change
      }
      JsonObject attrUpdate = new JsonObject();
      // ToDo: This is as far as I can determine a Cordra-specific function, not a DOIP one. It is
      //       not mentioned in any DONA docs. If this breaks for other repos, this is the likely
      //       culprit.
      attrUpdate.add("elementsToDelete", elementsToDelete);
      client.update(d_o, this.auth, service, attrUpdate);
      return deletedFiles;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public void addFilesToDo(String pid, List<InputStream> files)
      throws UnsuccessfulOperationException {
    if (files == null || files.isEmpty()) {
      return; // Nothing to change
    }
    try (DoipClient client = new DoipClient()) {
      DigitalObject d_o = client.retrieve(pid, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }
      List<Element> elements = new ArrayList<>();
      for (InputStream file : files) {
        Element element = new Element();
        try {
          file.reset();
        } catch (IOException e) {
          System.err.println(
              "Warning: Submitting InputStream that could not be reset to DOIP Repository.");
        }
        element.in = file;
        element.id = "File-" + new Random().nextInt(999999); // ID is mandatory for Cordra at least
        elements.add(element);
      }
      if (d_o.elements != null) {
        d_o.elements.addAll(elements);
      } else {
        d_o.elements = elements;
      }
      JsonObject attr = new JsonObject();
      attr.addProperty("includeElementData", true);
      client.update(d_o, this.auth, service, attr);
      return;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public List<InputStream> retrieveFilesFromDo(String pid) throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      JsonObject attr = new JsonObject();
      attr.addProperty("includeElementData", true);
      DigitalObject d_o = client.retrieve(pid, attr, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }
      List<InputStream> files = new ArrayList<>();
      if (d_o.elements != null && !d_o.elements.isEmpty()) {
        for (Element el : d_o.elements) {
          try {
            el.in.reset();
          } catch (IOException e) {
            System.err.println("Warning: Retrieved InputStream could not be reset.");
          }
          files.add(el.in);
        }
      } else {
        return new ArrayList<InputStream>();
      }
      return files;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public String deleteDoAttribute(String pid, String key) throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      DigitalObject d_o = client.retrieve(pid, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }
      JsonObject content = d_o.attributes.getAsJsonObject("content");
      if (!content.has(key)) {
        return null; // Nothing to change
      }
      String previousValue = content.get(key).getAsString();
      content.remove(key);
      client.update(d_o, this.auth, service);
      return previousValue;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public String createUpdateDoAttribute(String pid, String key, String value)
      throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      DigitalObject d_o = client.retrieve(pid, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }
      JsonObject content = d_o.attributes.getAsJsonObject("content");
      String previousValue = null;
      if (content.has(key)) {
        previousValue = content.get(key).getAsString();
      }
      content.addProperty(key, value);
      client.update(d_o, this.auth, service);
      return previousValue;
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public JsonObject retrieveAttributesFromDo(String pid) throws UnsuccessfulOperationException {
    try (DoipClient client = new DoipClient()) {
      DigitalObject d_o = client.retrieve(pid, this.auth, service);
      if (d_o == null) {
        throw new UnsuccessfulOperationException("Invalid PID.");
      }
      if (d_o.attributes == null) {
        return null;
      }
      return d_o.attributes.getAsJsonObject("content");
    } catch (DoipException e) {
      throw new UnsuccessfulOperationException(e.getMessage());
    }
  }

  @Override
  public String getId() {
    return config.getId();
  }

  @Override
  public RepositoryType getType() {
    return config.getType();
  }

  @Override
  public void close() {
    // TODO Auto-generated method stub

  }

  private void handleDoipException(DoipException e) throws AuthenticationException {
    if (DoipConstants.STATUS_UNAUTHENTICATED.equals(e.getStatusCode())) {
      throw new AuthenticationException(e.getMessage());
    }
    e.printStackTrace();
  }

  public Set<String> listOperations() throws AuthenticationException {
    try (DoipClient client = new DoipClient()) {
      return new HashSet<>(client.listOperations(config.get("serviceId"), auth, service));
    } catch (DoipException e) {
      handleDoipException(e);
    }
    return null;
  }

  @Override
  public <T extends FdoComponent> T copyFdoComponent(T component) {
    // TODO(Henrik)
    return null;
  }

  @Override
  public FDO updateFdo(FdoUpdate fdo) {
    // TODO(Henrik)
    return null;
  }

  @Override
  public void deleteFdoComponent(FdoComponent oldComponent, String newPid) {
    // TODO Auto-generated method stub
  }
}
