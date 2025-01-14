package com.indiscale.fdo.manager.mock;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.DelegatorFdo;
import com.indiscale.fdo.manager.api.CredentialsAuthenticationInfo;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DataProfile;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoUpdate;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryType;
import com.indiscale.fdo.manager.api.TokenAuthenticationInfo;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class MockRepository implements RepositoryConnection {

  public abstract static class ComponentDelegator<T extends FdoComponent> implements FdoComponent {

    protected T delegate;
    private String id;

    public ComponentDelegator(T data) {
      this.id = "some.prefix/" + UUID.randomUUID().toString();
      this.delegate = data;
    }

    @Override
    public String getPID() {
      return id;
    }

    @Override
    public InputStream getInputStream() throws IOException {
      return delegate.getInputStream();
    }

    @Override
    public JsonObject getAttributes() {
      return delegate.getAttributes();
    }
  }

  public static class MockMetadata extends ComponentDelegator<Metadata> implements Metadata {

    public MockMetadata(Metadata metadata) {
      super(metadata);
    }

    @Override
    public MetadataProfile getProfile() {
      return delegate.getProfile();
    }

    public JsonObject getAttributes() {
      return delegate.getAttributes();
    }
  }

  public static class MockData extends ComponentDelegator<Data> implements Data {

    public MockData(Data data) {
      super(data);
    }

    @Override
    public DataProfile getProfile() {
      return delegate.getProfile();
    }

    public JsonObject getAttributes() {
      return delegate.getAttributes();
    }
  }

  public static class MockFDO extends DelegatorFdo {

    private final String pid;
    private MockData data;
    private MockMetadata metadata;
    private JsonObject attributes;

    public MockFDO(FDO fdo) {
      super(fdo);
      pid = "some.prefix/" + UUID.randomUUID().toString();
      data = new MockData(fdo.getData());
      metadata = new MockMetadata(fdo.getMetadata());
      attributes = fdo.getAttributes();
    }

    @Override
    public String getPID() {
      return pid;
    }

    @Override
    public Data getData() {
      return data;
    }

    @Override
    public Metadata getMetadata() {
      return metadata;
    }

    @Override
    public JsonObject getAttributes() {
      if (attributes == null) {
        attributes = new JsonObject();
      }
      return attributes;
    }
  }

  private final String id;
  private final RepositoryType type;
  private final Map<String, MockHandleRecord> registry;

  public MockRepository(RepositoryConfig config, Map<String, MockHandleRecord> registry) {
    this.id = config.getId();
    this.type = config.getType();
    this.registry = registry;
  }

  @Override
  public String getId() {
    return id;
  }

  @Override
  public RepositoryType getType() {
    return type;
  }

  @Override
  public void close() {}

  @Override
  public boolean isOnline() {
    return true;
  }

  @Override
  public FDO createFDO(FDO fdo) throws ValidationException {
    return new MockFDO(fdo);
  }

  @Override
  public void purgeDO(String pid) {
    return;
  }

  @Override
  public List<InputStream> deleteFilesFromDo(String pid) {
    // Only have a DO - cannot access Input
    return null;
  }

  @Override
  public void addFilesToDo(String pid, List<InputStream> files) {
    // Only have a DO - cannot access Input
    return;
  }

  @Override
  public List<InputStream> retrieveFilesFromDo(String pid) {
    // Only have a DO - cannot access Input
    return null;
  }

  @Override
  public String deleteDoAttribute(String pid, String key) throws UnsuccessfulOperationException {
    if (!registry.containsKey(pid) || registry.get(pid) == null) {
      throw new UnsuccessfulOperationException("Invalid PID.");
    }
    JsonObject attributes = registry.get(pid).getDO().getAttributes();
    if (attributes == null) {
      return "";
    }
    String oldValue = null;
    if (attributes.has(key)) {
      oldValue = attributes.get(key).getAsString();
    }
    attributes.remove(key);
    return oldValue;
  }

  @Override
  public String createUpdateDoAttribute(String pid, String key, String value)
      throws UnsuccessfulOperationException {
    if (!registry.containsKey(pid) || registry.get(pid) == null) {
      throw new UnsuccessfulOperationException("Invalid PID.");
    }
    JsonObject attributes = registry.get(pid).getDO().getAttributes();
    if (attributes == null) {
      return "";
    }
    String oldValue = null;
    if (attributes.has(key)) {
      oldValue = attributes.get(key).getAsString();
    }
    attributes.addProperty(key, value);
    return oldValue;
  }

  @Override
  public JsonObject retrieveAttributesFromDo(String pid) throws UnsuccessfulOperationException {
    if (!registry.containsKey(pid) || registry.get(pid) == null) {
      throw new UnsuccessfulOperationException("Invalid PID.");
    }
    JsonObject attributes = registry.get(pid).getDO().getAttributes();
    if (attributes == null) {
      return new JsonObject();
    }
    return attributes;
  }

  @Override
  public <T extends FdoComponent> T copyFdoComponent(T component) {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public FDO updateFdo(FdoUpdate fdo) {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public void deleteFdoComponent(FdoComponent oldComponent, String newPid) {
    // TODO Auto-generated method stub
  }

  @Override
  public void setTokenAuthenticationInfo(TokenAuthenticationInfo authentication) {
    // TODO Auto-generated method stub
  }

  @Override
  public void setCredentialsAuthenticationInfo(CredentialsAuthenticationInfo authentication) {
    // TODO Auto-generated method stub

  }
}
