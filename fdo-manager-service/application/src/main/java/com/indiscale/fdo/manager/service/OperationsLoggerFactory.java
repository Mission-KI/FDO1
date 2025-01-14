package com.indiscale.fdo.manager.service;

import org.springframework.stereotype.Service;

@Service
public class OperationsLoggerFactory {

  public OperationsLogger createLogger() {
    OperationsLogger logger = new OperationsLogger();
    logger.addSink(new MemoryOperationsLoggerSink());
    logger.addSink(new PrintStreamLoggerSink(System.err));
    return logger;
  }
}
