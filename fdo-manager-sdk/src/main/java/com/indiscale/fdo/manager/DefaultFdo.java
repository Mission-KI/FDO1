package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoStatus;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.Metadata;

public class DefaultFdo implements FDO {

  private FdoProfile profile;
  private Data data;
  private Metadata metadata;
  private JsonObject attributes;
  private String pid;
  private FdoType type;
  private FdoStatus status;

  public DefaultFdo(
      JsonObject attributes, FdoProfile profile, FdoType type, Data data, Metadata metadata) {
    this(null, attributes, profile, type, data, metadata);
  }

  public DefaultFdo(
      String pid,
      JsonObject attributes,
      FdoProfile profile,
      FdoType type,
      Data data,
      Metadata metadata) {
    this(pid, attributes, profile, data, metadata, type, null);
  }

  public DefaultFdo(
      String pid,
      JsonObject attributes,
      FdoProfile profile,
      Data data,
      Metadata metadata,
      FdoType type,
      FdoStatus status) {
    this.pid = pid;
    this.profile = profile;
    this.data = data;
    this.metadata = metadata;
    this.attributes = attributes;
    this.type = type;
    this.status = status;
  }

  public DefaultFdo(JsonObject attributes, FdoProfile profile, Data data, Metadata metadata) {
    this(attributes, profile, null, data, metadata);
  }

  @Override
  public String getPID() {
    return pid;
  }

  @Override
  public JsonObject getAttributes() {
    return this.attributes;
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
