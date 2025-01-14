package com.indiscale.fdo.manager.mock;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.ProfileValidator;

/** MockProfile used for testing. This profile prominently uses the {@link NoOpValidator}. */
public class MockProfile implements FdoProfile {
  private final String id;

  public MockProfile(String id) {
    this.id = id;
  }

  @Override
  public ProfileValidator<FDO> getValidator() {
    return new NoOpValidator();
  }

  @Override
  public String getId() {
    return id;
  }

  @Override
  public String getDescription() {
    return "Mock-Profile Description";
  }

  @Override
  public String getPID() {
    return "0.prefix/" + id;
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
