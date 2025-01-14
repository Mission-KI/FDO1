package com.indiscale.fdo.manager.api;

public class UnsuccessfulOperationException extends Exception {

  private static final long serialVersionUID = -8259072698218790187L;

  public UnsuccessfulOperationException() {
    super();
  }

  public UnsuccessfulOperationException(String message) {
    super(message);
  }
}
