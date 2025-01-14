package com.indiscale.fdo.manager.service;

import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import java.util.ArrayList;
import java.util.List;

public class OperationsLogger {

  private List<OperationsLoggerSink> sinks = new ArrayList<>();

  public void addSink(OperationsLoggerSink sink) {
    sinks.add(sink);
  }

  public void createFDO(FDO fdo, RepositoryConnection repository) {
    LogRecord rec = new LogRecord(LogRecord.CREATE).fdo(fdo).targetRepository(repository);
    for (OperationsLoggerSink sink : sinks) {
      sink.log(rec);
    }
  }

  public void purgeFDO(DigitalObject fdo, RepositoryConnection repository) {
    LogRecord rec = new LogRecord(LogRecord.DELETE).fdo(fdo).targetRepository(repository);
    for (OperationsLoggerSink sink : sinks) {
      sink.log(rec);
    }
  }
}
