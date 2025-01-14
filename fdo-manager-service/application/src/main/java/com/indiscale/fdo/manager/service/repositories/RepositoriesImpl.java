package com.indiscale.fdo.manager.service.repositories;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.service.BaseController;
import com.indiscale.fdo.manager.service.api.model.GetRepository200Response;
import com.indiscale.fdo.manager.service.api.model.Links;
import com.indiscale.fdo.manager.service.api.model.ListRepositories200Response;
import com.indiscale.fdo.manager.service.api.model.RepositoryAttributes;
import com.indiscale.fdo.manager.service.api.operation.RepositoriesApi;
import java.util.LinkedList;
import java.util.List;
import org.springframework.hateoas.IanaLinkRelations;
import org.springframework.hateoas.Link;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@CrossOrigin(origins = {"${react-dev-server}"})
public class RepositoriesImpl extends BaseController implements RepositoriesApi {

  static class Repository extends com.indiscale.fdo.manager.service.api.model.Repository {
    private static final long serialVersionUID = -4753402740372027632L;

    public Repository(RepositoryConfig config) {
      this.setId(config.getId());
      this.setType(TypeEnum.REPOSITORIES);
      RepositoryAttributes attr = new RepositoryAttributes();
      attr.setDescription(config.getDescription());
      attr.setMaintainer(config.getMaintainer());
      attr.setType(config.getType().id);
      this.setAttributes(attr);
    }

    String getSelfRel() {
      Link selfLink =
          linkTo(methodOn(RepositoriesImpl.class).getRepository(this.getId())).withSelfRel();
      return selfLink.getHref();
    }

    String getCollectionRel() {
      Link collectionLink =
          linkTo(methodOn(RepositoriesImpl.class).listRepositories())
              .withRel(IanaLinkRelations.COLLECTION);
      return collectionLink.getHref();
    }

    public Repository withSelfRel() {
      if (this.getLinks() == null) {
        this.setLinks(new Links());
      }
      this.getLinks().self(getSelfRel());
      return this;
    }

    public Repository withCollectionRel() {
      if (this.getLinks() == null) {
        this.setLinks(new Links());
      }
      this.getLinks().collection(getCollectionRel());
      return this;
    }
  }

  @Override
  public ResponseEntity<ListRepositories200Response> listRepositories() {
    try (Manager manager = getManager()) {
      List<com.indiscale.fdo.manager.service.api.model.Repository> results = new LinkedList<>();

      List<RepositoryConfig> repositories = manager.getRepositoryRegistry().listRepositories();
      for (RepositoryConfig repo : repositories) {
        results.add(new Repository(repo).withSelfRel());
      }

      Link selfLink = linkTo(methodOn(getClass()).listRepositories()).withSelfRel();
      Links links = new Links();
      links.self(selfLink.getHref());
      return ResponseEntity.ok(new ListRepositories200Response().data(results).links(links));
    }
  }

  @Override
  public ResponseEntity<GetRepository200Response> getRepository(String repositoryId) {

    try (Manager manager = getManager()) {
      RepositoryConfig config = manager.getRepositoryRegistry().getRepositoryConfig(repositoryId);

      Repository repo = new Repository(config);
      return ResponseEntity.ok(
          new GetRepository200Response()
              .data(repo)
              .links(new Links().self(repo.getSelfRel()).collection(repo.getCollectionRel())));
    } catch (UnknownRepositoryException e) {
      throw new ResponseStatusException(
          HttpStatus.NOT_FOUND, "Unknown Repository ID: " + repositoryId);
    }
  }
}
