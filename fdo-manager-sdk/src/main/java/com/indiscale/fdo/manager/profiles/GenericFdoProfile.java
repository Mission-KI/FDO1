package com.indiscale.fdo.manager.profiles;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.ProfileValidator;
import com.indiscale.fdo.manager.api.ValidationError;
import com.indiscale.fdo.manager.api.ValidationResult;
import com.indiscale.fdo.manager.util.Util;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class GenericFdoProfile implements FdoProfile {
  static class ValidationErrorImpl implements ValidationError {

    private String description;
    private List<ValidationError> causes;

    public ValidationErrorImpl(String description, List<ValidationError> causes) {
      this.description = description;
      this.causes = causes;
    }

    public ValidationErrorImpl(String description) {
      this(description, null);
    }

    @Override
    public List<ValidationError> getCauses() {
      return causes;
    }

    @Override
    public String getDescription() {
      return description;
    }
  }

  public static final ValidationError DATA_MISSING = new ValidationErrorImpl("Missing Data.");
  public static final ValidationError METADATA_MISSING =
      new ValidationErrorImpl("Missing Metadata.");
  public static final ValidationError DATA_PROFILE_MISSING =
      new ValidationErrorImpl("Missing Data Profile.");
  public static final ValidationError METADATA_PROFILE_MISSING =
      new ValidationErrorImpl("Missing Metadata Profile.");

  static class ValidationResultImpl implements ValidationResult {

    private List<ValidationError> errors = new LinkedList<>();

    public void addError(ValidationError error) {
      this.errors.add(error);
    }

    @Override
    public boolean isValid() {
      return errors.isEmpty();
    }

    @Override
    public List<ValidationError> getErrors() {
      return Collections.unmodifiableList(errors);
    }

    public void addDataErrors(List<ValidationError> errors) {
      this.errors.add(new ValidationErrorImpl("Invalid Data", errors));
    }

    public void addMetadataErrors(List<ValidationError> errors) {
      this.errors.add(new ValidationErrorImpl("Invalid Metadata", errors));
    }
  }

  static class GenericFdoValidator implements ProfileValidator<FDO> {

    @Override
    public ValidationResult validate(FDO fdo) {
      ValidationResultImpl result = new ValidationResultImpl();
      if (fdo.getData() == null) {
        result.addError(DATA_MISSING);
      } else if (fdo.getData().getProfile() == null) {
        // TODO
        // result.addError(DATA_PROFILE_MISSING);
      } else {
        ValidationResult dataResult = fdo.getData().validate();
        if (!dataResult.isValid()) {
          result.addDataErrors(dataResult.getErrors());
        }
      }
      if (fdo.getMetadata() == null) {
        result.addError(METADATA_MISSING);
      } else if (fdo.getMetadata().getProfile() == null) {
        // TODO
        // result.addError(METADATA_PROFILE_MISSING);
      } else {
        ValidationResult metadataResult = fdo.getMetadata().validate();
        if (!metadataResult.isValid()) {
          result.addMetadataErrors(metadataResult.getErrors());
        }
      }

      return result;
    }
  }

  private static ProfileValidator<FDO> validator = new GenericFdoValidator();

  @Override
  public String getPID() {
    return Util.FDO_KIP;
  }

  @Override
  public ProfileValidator<FDO> getValidator() {
    return validator;
  }

  @Override
  public String getDescription() {
    return "Generic FDO profile. Every FDO must validate against this profile. More detailed profiles need to be developed.";
  }

  @Override
  public String getId() {
    return "FDO_KIP";
  }

  @Override
  public JsonObject getAttributes() {
    return null;
  }

  @Override
  public boolean isFDO() {
    return false;
  }

  @Override
  public FDO toFDO() {
    return null;
  }
}
