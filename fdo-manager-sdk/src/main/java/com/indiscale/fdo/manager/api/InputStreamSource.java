package com.indiscale.fdo.manager.api;

import java.io.IOException;
import java.io.InputStream;

public interface InputStreamSource {
  public InputStream getInputStream() throws IOException;
}
