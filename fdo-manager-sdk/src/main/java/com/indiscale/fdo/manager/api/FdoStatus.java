package com.indiscale.fdo.manager.api;

import com.indiscale.fdo.manager.DefaultFdoStatus;

public interface FdoStatus extends DigitalObject {

  static FdoStatus getStatus(String pid) {
    return new DefaultFdoStatus(pid);
  }
}
