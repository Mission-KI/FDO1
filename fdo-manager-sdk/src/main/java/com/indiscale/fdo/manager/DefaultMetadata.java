package com.indiscale.fdo.manager;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.AbstractFdoComponent;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import java.io.InputStream;

public class DefaultMetadata extends AbstractFdoComponent implements Metadata {

  private MetadataProfile profile;

  public DefaultMetadata() {
    this((MetadataProfile) null);
  }

  public DefaultMetadata(MetadataProfile profile) {
    this(null, null, profile);
  }

  protected void setProfile(MetadataProfile profile) {
    this.profile = profile;
  }

  public DefaultMetadata(InputStream in) {
    this(in, null, null);
  }

  public DefaultMetadata(InputStream in, JsonObject attributes) {
    this(in, attributes, null);
  }

  public DefaultMetadata(InputStream in, JsonObject attributes, MetadataProfile profile) {
    super(in, attributes);
    this.profile = profile;
  }

  @Override
  public MetadataProfile getProfile() {
    return profile;
  }
}
