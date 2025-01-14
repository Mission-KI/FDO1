package com.indiscale.fdo.manager.doip;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.DefaultMetadataProfile;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DataProfile;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoStatus;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import java.io.IOException;
import java.io.InputStream;
import net.dona.doip.client.DigitalObject;

public class DoipFdo implements FDO {

  public static class DataImpl implements Data {

    private DigitalObject data;

    public DataImpl(DigitalObject data) {
      this.data = data;
    }

    public DataImpl() {
      // TODO Auto-generated constructor stub
    }

    public String get() {
      return this.data.id;
    }

    public String getPID() {
      return this.data.id;
    }

    @Override
    public InputStream getInputStream() throws IOException {
      // TODO we only consider the first here
      if (this.data == null || this.data.elements == null) {
        return null;
      } else {
        return this.data.elements.get(0).in;
      }
    }

    @Override
    public JsonObject getAttributes() {
      if (this.data != null && this.data.attributes.has("content")) {
        return this.data.attributes.get("content").getAsJsonObject();
      }
      return null;
    }

    @Override
    public DataProfile getProfile() {
      // TODO Auto-generated method stub
      return null;
    }
  }

  public static class MetadataImpl implements Metadata {

    private DigitalObject metadata;

    public MetadataImpl(DigitalObject metadata) {
      this.metadata = metadata;
    }

    public MetadataImpl() {
      // TODO Auto-generated constructor stub
    }

    @Override
    public InputStream getInputStream() throws IOException {
      // TODO Auto-generated method stub
      return null;
    }

    @Override
    public String getPID() {
      return this.metadata.id;
    }

    @Override
    public JsonObject getAttributes() {
      if (this.metadata != null
          && this.metadata.attributes != null
          && this.metadata.attributes.has("content")) {
        return this.metadata.attributes.get("content").getAsJsonObject();
      }
      return null;
    }

    @Override
    public MetadataProfile getProfile() {
      JsonObject attributes = getAttributes();
      if (attributes != null && attributes.has(FDO_PROFILE_REF)) {
        return new DefaultMetadataProfile(attributes.get(FDO_PROFILE_REF).getAsString());
      }
      return null;
    }
  }

  private Data data;
  private Metadata metadata;
  private DigitalObject fdo;
  private FdoType type = null;
  private FdoProfile profile = null;
  private FdoStatus status = null;
  private JsonObject attributes;
  public static String FDO_PROFILE_REF = "FDO_Profile_Ref";
  public static String FDO_TYPE = "FDO_Type";
  public static String FDO_STATUS = "FDO_Status";

  public DoipFdo(DigitalObject data, DigitalObject metadata, DigitalObject fdo) {
    this.data = new DataImpl(data);
    this.metadata = new MetadataImpl(metadata);
    this.fdo = fdo;
    this.attributes = fdo.attributes;
    if (this.attributes != null) {
      if (this.attributes.has(FDO_PROFILE_REF)) {
        this.profile = FdoProfile.getProfile(this.attributes.get(FDO_PROFILE_REF).getAsString());
      }
      if (this.attributes.has(FDO_TYPE)) {
        this.type = FdoType.getType(this.attributes.get(FDO_TYPE).getAsString());
      }
      if (this.attributes.has(FDO_STATUS)) {
        this.status = FdoStatus.getStatus(this.attributes.get(FDO_STATUS).getAsString());
      }
    }
  }

  @Override
  public String getPID() {
    return fdo.id;
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
    return attributes;
  }

  @Override
  public FdoProfile getProfile() {
    return profile;
  }

  @Override
  public FdoType getType() {
    return type;
  }

  @Override
  public FdoStatus getStatus() {
    return status;
  }
}
