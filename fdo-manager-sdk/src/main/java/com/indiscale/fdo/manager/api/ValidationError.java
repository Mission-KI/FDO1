package com.indiscale.fdo.manager.api;

import java.util.List;

public interface ValidationError {
  public List<ValidationError> getCauses();

  public String getDescription();
}
