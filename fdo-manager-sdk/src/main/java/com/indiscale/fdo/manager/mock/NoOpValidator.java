package com.indiscale.fdo.manager.mock;

import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.ProfileValidator;
import com.indiscale.fdo.manager.api.ValidationError;
import com.indiscale.fdo.manager.api.ValidationResult;
import java.util.Collections;
import java.util.List;

/** Doesn't actually validate anything, which effectively means everything is valid. */
class NoOpValidator implements ProfileValidator<FDO> {

  @Override
  public ValidationResult validate(FDO t) {
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
