package com.indiscale.fdo.manager.service.fdo;

import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.UnknownProfileException;
import com.indiscale.fdo.manager.service.BaseController;
import com.indiscale.fdo.manager.service.api.model.GetProfile200Response;
import com.indiscale.fdo.manager.service.api.model.Links;
import com.indiscale.fdo.manager.service.api.model.ListProfiles200Response;
import com.indiscale.fdo.manager.service.api.model.Profile;
import com.indiscale.fdo.manager.service.api.model.ProfileAttributes;
import com.indiscale.fdo.manager.service.api.operation.ProfilesApi;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@CrossOrigin(origins = {"${react-dev-server}"})
public class ProfilesApiImpl extends BaseController implements ProfilesApi {

  private Profile toProfile(FdoProfile p) {
    ProfileAttributes attr = new ProfileAttributes();
    attr.description(p.getDescription());
    // attr.setDescription(p.getDescription());
    attr.pid(p.getPID());
    return new Profile().id(p.getId()).attributes(attr);
  }

  @Override
  public ResponseEntity<ListProfiles200Response> listProfiles() {
    try (Manager manager = getManager()) {
      List<FdoProfile> profiles = manager.getProfileRegistry().listProfiles();
      ListProfiles200Response result = new ListProfiles200Response();
      for (FdoProfile p : profiles) {
        Links self = linkSelf(getOperations(getClass()).getProfile(p.getId()));
        result.addDataItem(toProfile(p).links(self));
      }
      Links self = linkSelf(getOperations(getClass()).listProfiles());

      return ResponseEntity.ok(result.links(self));
    }
  }

  @Override
  public ResponseEntity<GetProfile200Response> getProfile(String profileId) {
    try (Manager manager = getManager()) {
      Profile profile = toProfile(manager.getProfileRegistry().getProfile(profileId));
      Links links = linkCollection(getOperations(getClass()).listProfiles());
      links.self(link(getOperations(getClass()).getProfile(profileId)));
      return ResponseEntity.ok(new GetProfile200Response().data(profile).links(links));
    } catch (UnknownProfileException e) {
      throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Unknown Profile ID: " + profileId);
    }
  }
}
