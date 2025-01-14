package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import java.io.IOException;
import java.io.InputStream;

public class LazyResolutionMetadata implements Metadata {

  private Manager manager;
  private String pid;

  public LazyResolutionMetadata(Manager manager, String pid) {
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
  public MetadataProfile getProfile() {
    // TODO Auto-generated method stub
    return null;
  }
}
