package com.indiscale.fdo.manager;

import com.indiscale.fdo.manager.api.BaseProfile;
import com.indiscale.fdo.manager.api.ProfileRegistry;
import com.indiscale.fdo.manager.api.UnknownProfileException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class DefaultProfileRegistry<T extends BaseProfile<?>> implements ProfileRegistry<T> {

  private Map<String, T> profiles = new HashMap<>();
  private Set<T> setProfiles = new HashSet<>();

  public void registerProfile(T profile) {
    this.profiles.put(profile.getId(), profile);
    this.profiles.put(profile.getPID(), profile);
    this.setProfiles.add(profile);
  }

  @Override
  public T getProfile(String id) throws UnknownProfileException {
    T profile = this.profiles.get(id);
    if (profile == null) {
      throw new UnknownProfileException(id);
    }
    return profile;
  }

  @Override
  public List<T> listProfiles() {
    return List.copyOf(this.setProfiles);
  }
}
