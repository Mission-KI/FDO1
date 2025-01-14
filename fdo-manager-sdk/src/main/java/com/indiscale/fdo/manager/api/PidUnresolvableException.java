package com.indiscale.fdo.manager.api;

public class PidUnresolvableException extends Exception {

  private static final long serialVersionUID = 4788288877851939179L;
  private String pid;

  public PidUnresolvableException(String pid) {
    super("Could not resolve handle with pid " + pid);
    this.pid = pid;
  }

  public String getPid() {
    return pid;
  }
}
