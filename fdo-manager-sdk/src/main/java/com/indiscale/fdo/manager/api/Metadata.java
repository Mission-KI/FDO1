package com.indiscale.fdo.manager.api;

/**
 * Metadata component of an FDO.
 *
 * <p>Metadata objects are itself a digital object. As such they have a pid.
 *
 * <p>Metadata objects encapsulate a byte stream which contains the serialized metadata of an {@link
 * FDO}, e.g. a JSON, XML or other representation. Metadata plus {@link Data}, {@link FdoProfile}
 * and the PID make up the {@link FDO}.
 *
 * <p>Metadata objects must validate against the metadata-related part of an FDO's {@link
 * FdoProfile}, i.e. the part of the profile which is relevant for the metadata. This could be
 * something like, "validates against this json-schema X".
 */
public interface Metadata extends FdoComponent {

  /**
   * Per default this throws a RuntimeException, because {@link #isFDO()} is always false - the
   * metadata component of an FDO is never itself an FDO.
   */
  @Override
  default FDO toFDO() {
    throw new RuntimeException("This is a Metadata object, not an FDO");
  }

  /** Get the metadata-related part of the {@link FdoProfile}. */
  public MetadataProfile getProfile();

  /**
   * Validate against the metadata-related part of the {@link FdoProfile}.
   *
   * @return
   */
  default ValidationResult validate() {
    return this.getProfile().getValidator().validate(this);
  }
}
