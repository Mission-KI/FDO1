package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.ProfileValidator;

public class DefaultProfile implements FdoProfile {

  private String pid;

  public DefaultProfile(String pid) {
    this.pid = pid;
  }

  @Override
  public String getId() {
    return pid;
  }

  @Override
  public String getDescription() {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public ProfileValidator<FDO> getValidator() {
    // TODO Auto-generated method stub
    return null;
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
  public FdoComponent toFdoComponent() {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public boolean isFdoComponent() {
    // TODO Auto-generated method stub
    return false;
  }
}
