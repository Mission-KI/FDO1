package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;

public class NonFdoDigitalObject implements DigitalObject {

  private String pid;
  private JsonObject attributes;

  public NonFdoDigitalObject(String pid, JsonObject attributes) {
    this.pid = pid;
    this.attributes = attributes;
  }

  @Override
  public String getPID() {
    return pid;
  }

  @Override
  public JsonObject getAttributes() {
    return attributes;
  }

  @Override
  public boolean isFDO() {
    return false;
  }

  @Override
  public FDO toFDO() {
    return null;
  }

  @Override
  public FdoComponent toFdoComponent() {
    return null;
  }

  @Override
  public boolean isFdoComponent() {
    return false;
  }
}
