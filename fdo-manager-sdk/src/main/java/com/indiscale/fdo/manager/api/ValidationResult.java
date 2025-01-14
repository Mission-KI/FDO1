package com.indiscale.fdo.manager.api;

import java.util.List;

public interface ValidationResult {

  public boolean isValid();

  public List<ValidationError> getErrors();
}
