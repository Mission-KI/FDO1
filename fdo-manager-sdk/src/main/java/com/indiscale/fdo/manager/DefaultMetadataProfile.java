package com.indiscale.fdo.manager;

import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.ProfileValidator;
import com.indiscale.fdo.manager.api.ValidationError;
import com.indiscale.fdo.manager.api.ValidationResult;
import java.util.Collections;
import java.util.List;

class NoOpValidator implements ProfileValidator<Metadata> {

  @Override
  public ValidationResult validate(Metadata t) {
    return new ValidationResult() {

      @Override
      public boolean isValid() {
        return true;
      }

      @Override
      public List<ValidationError> getErrors() {
        return Collections.emptyList();
      }
    };
  }
}

public class DefaultMetadataProfile implements MetadataProfile {

  private String pid;
  private ProfileValidator<Metadata> validator;

  public DefaultMetadataProfile(String pid) {
    this.pid = pid;
    validator = new NoOpValidator();
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
  public String getPID() {
    return pid;
  }

  @Override
  public ProfileValidator<Metadata> getValidator() {
    return validator;
  }
}
