package com.indiscale.fdo.manager.api;

public class ValidationException extends Exception {

  private ValidationResult validationResult;

  public ValidationException(ValidationResult validationResult) {
    this.validationResult = validationResult;
  }

  private static final long serialVersionUID = -4450619747263845886L;

  public ValidationResult getValidationResult() {
    return validationResult;
  }
}
