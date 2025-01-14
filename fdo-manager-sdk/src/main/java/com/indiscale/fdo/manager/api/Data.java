package com.indiscale.fdo.manager.api;

/**
 * Data component of an FDO.
 *
 * <p>Data objects are itself a digital object. As such they have a pid.
 *
 * <p>Data objects encapsulate a byte stream (the very core of the {@link FDO} when you think of it
 * as concentric spheres with data, {@link Metadata}, {@link FdoProfile} and the PID which ties it
 * all together).
 *
 * <p>Data objects must validate against the data-related part of an FDO's {@link FdoProfile}, i.e.
 * the part of the profile which is relevant for the data. This could be something like, "is a
 * JPEG".
 */
public interface Data extends FdoComponent {

  /**
   * Per default this throws a RuntimeException, because {@link #isFDO()} is always false - the data
   * component of an FDO is never itself an FDO.
   */
  @Override
  default FDO toFDO() {
    throw new RuntimeException("This is a Data object, not an FDO");
  }

  /** Get the data-related part of an FDO's {@link FdoProfile}. */
  public DataProfile getProfile();

  /** Validate against the data-related part of an FDO's {@link FdoProfile}. */
  public default ValidationResult validate() {
    return this.getProfile().getValidator().validate(this);
  }
}
