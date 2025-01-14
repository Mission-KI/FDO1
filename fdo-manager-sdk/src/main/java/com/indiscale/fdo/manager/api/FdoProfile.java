package com.indiscale.fdo.manager.api;

import com.indiscale.fdo.manager.DefaultProfile;
import com.indiscale.fdo.manager.profiles.GenericFdoProfile;

public interface FdoProfile extends BaseProfile<FDO>, DigitalObject {

  static FdoProfile GENERIC_FDO = new GenericFdoProfile();

  static FdoProfile getProfile(String pid) {
    if (pid == null || pid.equals(GENERIC_FDO.getId()) || pid.equals(GENERIC_FDO.getPID())) {
      return GENERIC_FDO;
    }
    return new DefaultProfile(pid);
  }

  @Override
  default boolean isFdoComponent() {
    return false;
  }

  @Override
  default FdoComponent toFdoComponent() {
    return null;
  }
}
