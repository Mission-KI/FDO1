package com.indiscale.fdo.manager.api;

public interface ProfileValidator<T> {

  public ValidationResult validate(T t);
}
