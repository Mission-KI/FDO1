package com.indiscale.fdo.manager.api;

import java.util.List;

public interface ProfileRegistry<T> {

  public T getProfile(String id) throws UnknownProfileException;

  public List<T> listProfiles();
}
