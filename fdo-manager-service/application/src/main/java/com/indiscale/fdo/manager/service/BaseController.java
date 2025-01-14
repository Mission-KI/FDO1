package com.indiscale.fdo.manager.service;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.service.api.model.Error;
import com.indiscale.fdo.manager.service.api.model.Links;
import com.indiscale.fdo.manager.service.authentication.Authenticator;
import com.indiscale.fdo.manager.service.authentication.AuthenticatorProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.IanaLinkRelations;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.server.ResponseStatusException;

public class BaseController {

  @Autowired ManagerPool managerPool;

  @Autowired AuthenticatorProvider authenticator;

  @Autowired OperationsLoggerFactory operationsLoggerFactory;

  private OperationsLogger logger = null;

  protected OperationsLogger getLogger() {
    if (logger == null) {
      logger = operationsLoggerFactory.createLogger();
    }
    return logger;
  }

  protected Manager getManager() {
    return managerPool.getManager();
  }

  protected Authenticator getAuthenticator() {
    return authenticator.getAuthenticator();
  }

  @ExceptionHandler(ResponseStatusException.class)
  public ResponseEntity<?> handleResponseStatusException(
      ResponseStatusException ex, WebRequest request) {
    Error body =
        new Error().status(Integer.toString(ex.getStatusCode().value())).detail(ex.getReason());
    return ResponseEntity.status(ex.getStatusCode()).body(body);
  }

  public <T> T getOperations(Class<T> controllerClass) {
    return methodOn(controllerClass);
  }

  public String link(Object object) {
    return linkTo(object).withSelfRel().getHref();
  }

  public Links linkSelf(Object object) {
    return new Links().self(link(object));
  }

  public Links linkCollection(Object object) {
    return new Links().collection(linkTo(object).withRel(IanaLinkRelations.COLLECTION).getHref());
  }
}
