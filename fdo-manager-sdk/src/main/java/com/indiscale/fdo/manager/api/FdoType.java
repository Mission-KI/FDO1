package com.indiscale.fdo.manager.api;

import com.indiscale.fdo.manager.DefaultFdoType;

public interface FdoType extends DigitalObject {

  static FdoType getType(String pid) {
    if (pid != null) {
      return new DefaultFdoType(pid);
    }
    return null;
  }
}
