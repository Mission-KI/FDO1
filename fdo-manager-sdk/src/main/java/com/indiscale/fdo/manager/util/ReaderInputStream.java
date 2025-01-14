package com.indiscale.fdo.manager.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

public class ReaderInputStream extends InputStream {

  private StringReader stringReader;

  public ReaderInputStream(StringReader stringReader) {
    this.stringReader = stringReader;
  }

  @Override
  public int read() throws IOException {
    return this.stringReader.read();
  }
}
