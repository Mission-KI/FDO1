package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoType;

public class DefaultFdoType implements FdoType {

  private String pid;

  public DefaultFdoType(String pid) {
    this.pid = pid;
  }

  @Override
  public String getPID() {
    return pid;
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

  @Override
  public boolean isFdoComponent() {
    // TODO Auto-generated method stub
    return false;
  }

  @Override
  public FdoComponent toFdoComponent() {
    // TODO Auto-generated method stub
    return null;
  }
}
