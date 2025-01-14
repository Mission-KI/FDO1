package com.indiscale.fdo.manager.service;

import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import java.util.UUID;

public class LogRecord {

  public static final String CREATE = "Op.Create";
  public static final String DELETE = "Op.Delete";

  private String operation;
  private DigitalObject fdo;

  private RepositoryConnection repository;

  private final long timestamp;

  private String id;

  public LogRecord(String operation) {
    this.timestamp = System.currentTimeMillis();
    this.id = UUID.randomUUID().toString();
    this.operation = operation;
  }

  public LogRecord fdo(DigitalObject fdo) {
    this.fdo = fdo;
    return this;
  }

  public LogRecord targetRepository(RepositoryConnection repository) {
    this.repository = repository;
    return this;
  }

  public String getId() {
    return id;
  }

  public RepositoryConnection getRepository() {
    return repository;
  }

  public String getOperation() {
    return operation;
  }

  public DigitalObject getFdo() {
    return fdo;
  }

  @Override
  public String toString() {
    StringBuilder b = new StringBuilder();
    b.append(getOperation());
    b.append(" ");
    b.append(getFdo().getPID());
    b.append(" in repository ");
    b.append(repository.getId());
    return b.toString();
  }

  public long getTimestamp() {
    return timestamp;
  }
}
