package com.indiscale.fdo.manager.api;

public interface BaseProfile<T> {

  public String getId();

  public String getDescription();

  public String getPID();

  public ProfileValidator<T> getValidator();
}
