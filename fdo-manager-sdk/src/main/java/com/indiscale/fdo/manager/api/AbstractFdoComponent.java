package com.indiscale.fdo.manager.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.InputStream;

public abstract class AbstractFdoComponent implements FdoComponent {

  private InputStream in;
  private JsonObject attributes;

  public AbstractFdoComponent(InputStream in) {
    this(in, null);
  }

  public AbstractFdoComponent(InputStream in, JsonObject attributes) {
    this.in = in;
    this.attributes = attributes;
  }

  public AbstractFdoComponent() {
    this(null, null);
  }

  @Override
  public String getPID() {
    return null;
  }

  @Override
  public InputStream getInputStream() throws IOException {
    return in;
  }

  @Override
  public JsonObject getAttributes() {
    return attributes;
  }

  public void setAttribute(String name, JsonElement value) {
    if (attributes == null) {
      this.attributes = new JsonObject();
    }
    this.attributes.add(name, value);
  }
}
