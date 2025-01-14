package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.FdoStatus;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.Metadata;

public class DelegatorFdo implements FDO {

  private FDO fdo;

  public DelegatorFdo(FDO fdo) {
    this.fdo = fdo;
  }

  @Override
  public String getPID() {
    return fdo.getPID();
  }

  @Override
  public JsonObject getAttributes() {
    return fdo.getAttributes();
  }

  @Override
  public Data getData() {
    return fdo.getData();
  }

  @Override
  public Metadata getMetadata() {
    return fdo.getMetadata();
  }

  @Override
  public FdoProfile getProfile() {
    return fdo.getProfile();
  }

  @Override
  public FdoType getType() {
    return fdo.getType();
  }

  @Override
  public FdoStatus getStatus() {
    return fdo.getStatus();
  }
}
