package com.indiscale.fdo.manager.api;

public class UnknownProfileException extends Exception {

  public UnknownProfileException(String profile) {
    super("Unknown profile " + profile);
  }

  private static final long serialVersionUID = -8106239741819310158L;
}
