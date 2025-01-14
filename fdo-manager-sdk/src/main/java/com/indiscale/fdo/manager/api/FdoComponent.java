package com.indiscale.fdo.manager.api;

/** Convenient base interface for the components of an FDO - {@link Data} and {@link Metadata}. */
public interface FdoComponent extends InputStreamSource, DigitalObject {

  /** Per default this return false - the <em>component<em> of an FDO is never itself an FDO. */
  @Override
  public default boolean isFDO() {
    return false;
  }

  public BaseProfile<? extends FdoComponent> getProfile();

  @Override
  default boolean isFdoComponent() {
    return true;
  }

  @Override
  default FdoComponent toFdoComponent() {
    return this;
  }
}
