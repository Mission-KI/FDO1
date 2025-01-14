package com.indiscale.fdo.manager.api;

import java.util.Objects;

/**
 * Enum-like class (objects with equal ids are equal) for identifying repository types.
 *
 * <p>It is not an enum because we create these at run-time and we also have a description.
 */
public class RepositoryType {

  /** Unique identifier, e.g. "DOIP" for repositories implementing the DOIP protocol. */
  public final String id;

  /** Short description intended for human readers */
  public String description;

  public RepositoryType(String id) {
    if (id == null) {
      throw new NullPointerException("id was null.");
    }
    this.id = id;
  }

  @Override
  public int hashCode() {
    return this.id.hashCode();
  }

  @Override
  public boolean equals(Object obj) {
    return obj instanceof RepositoryType && Objects.equals(((RepositoryType) obj).id, this.id);
  }

  @Override
  public String toString() {
    return new StringBuffer("RepositoryType:").append(id).toString();
  }

  public RepositoryType description(String description) {
    this.description = description;
    return this;
  }
}
