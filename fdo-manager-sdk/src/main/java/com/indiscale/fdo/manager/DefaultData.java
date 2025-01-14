package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.AbstractFdoComponent;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DataProfile;
import java.io.InputStream;

public class DefaultData extends AbstractFdoComponent implements Data {

  public DefaultData() {
    super();
  }

  public DefaultData(InputStream in) {
    super(in);
  }

  public DefaultData(InputStream in, JsonObject attributes) {
    super(in, attributes);
  }

  @Override
  public DataProfile getProfile() {
    return null;
  }
}
