package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.DataProfile;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

public class UrlRefData implements Data {

  private JsonObject attributes;
  private URL url;

  public UrlRefData(URL url) {
    this.url = url;
    this.attributes = new JsonObject();
    attributes.addProperty("URL", url.toExternalForm());
  }

  public URL getUrl() {
    return url;
  }

  @Override
  public InputStream getInputStream() throws IOException {
    return null;
  }

  @Override
  public String getPID() {
    return null;
  }

  @Override
  public JsonObject getAttributes() {
    return attributes;
  }

  @Override
  public DataProfile getProfile() {
    return null;
  }
}
