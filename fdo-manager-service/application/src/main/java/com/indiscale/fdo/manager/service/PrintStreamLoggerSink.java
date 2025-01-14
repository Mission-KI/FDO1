package com.indiscale.fdo.manager.service;

import java.io.PrintStream;

public class PrintStreamLoggerSink implements OperationsLoggerSink {

  private PrintStream stream;

  public PrintStreamLoggerSink(PrintStream stream) {
    this.stream = stream;
  }

  @Override
  public void log(LogRecord rec) {
    stream.println(rec.toString());
  }
}
