package com.indiscale.fdo.manager.api;

public interface FDO extends DigitalObject {

  @Override
  public default FDO toFDO() {
    return this;
  }

  @Override
  public default boolean isFDO() {
    return true;
  }

  public Data getData();

  public Metadata getMetadata();

  public FdoProfile getProfile();

  public FdoType getType();

  public FdoStatus getStatus();

  public default void validate() throws ValidationException {
    ValidationResult result = getProfile().getValidator().validate(this);
    if (!result.isValid()) {
      throw new ValidationException(result);
    }
  }

  @Override
  default boolean isFdoComponent() {
    return false;
  }

  @Override
  default FdoComponent toFdoComponent() {
    throw new RuntimeException("This is an FDO, not an FdoComponent");
  }
}
