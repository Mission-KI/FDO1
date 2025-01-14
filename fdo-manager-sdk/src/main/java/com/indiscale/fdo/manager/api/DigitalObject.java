package com.indiscale.fdo.manager.api;

import com.google.gson.JsonObject;

public interface DigitalObject {
  public String getPID();

  public JsonObject getAttributes();

  public boolean isFDO();

  public FDO toFDO();

  public FdoComponent toFdoComponent();

  public boolean isFdoComponent();
}
