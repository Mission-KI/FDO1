package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DataProfile;
import java.io.IOException;
import java.io.InputStream;

public class LazyResolutionData implements Data {

  private DefaultManager manager;
  private String pid;

  public LazyResolutionData(DefaultManager manager, String pid) {
    this.manager = manager;
    this.pid = pid;
  }

  @Override
  public InputStream getInputStream() throws IOException {
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
  public DataProfile getProfile() {
    // TODO Auto-generated method stub
    return null;
  }
}
