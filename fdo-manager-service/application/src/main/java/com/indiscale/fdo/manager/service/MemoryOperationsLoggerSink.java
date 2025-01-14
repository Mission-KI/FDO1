package com.indiscale.fdo.manager.service;

import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedDeque;

public class MemoryOperationsLoggerSink implements OperationsLoggerSink {

  private static Deque<LogRecord> logs = new ConcurrentLinkedDeque<>();

  public void log(LogRecord record) {
    MemoryOperationsLoggerSink.logs.addFirst(record);
  }

  public static List<LogRecord> getLogRecords(int page, int pageLength) {
    Iterator<LogRecord> iterator = logs.iterator();
    List<LogRecord> result = new LinkedList<>();
    int counter = 0;
    int startIndex = page * pageLength;
    while (iterator.hasNext() && counter < startIndex + pageLength) {
      counter++;
      if (counter > startIndex) {
        result.add(iterator.next());
      }
    }
    return result;
  }
}
