package com.indiscale.fdo.manager.service.fdo;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.DefaultRepositoryRegistry;
import com.indiscale.fdo.manager.api.DigitalObject;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoComponent;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.PidUnresolvableException;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryRegistry;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnknownRepositoryTypeException;
import com.indiscale.fdo.manager.mock.MockManager;
import com.indiscale.fdo.manager.service.OperationsLogger;
import com.indiscale.fdo.manager.service.OperationsLoggerFactory;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.server.ResponseStatusException;

/** Test the {@link FDOApiImpl} class */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class FDOApiTest {

  static OperationsLoggerFactory operationsLoggerFactory = new OperationsLoggerFactory();

  private static final Manager mockitoManager = mock(MockManager.class);

  public static class TestFDOApiImpl extends FDOApiImpl {
    @Override
    public Manager getManager() {
      return mockitoManager;
    }

    @Override
    protected OperationsLogger getLogger() {
      return operationsLoggerFactory.createLogger();
    }
  }

  private final FDOApiImpl api = new FDOApiTest.TestFDOApiImpl();

  @Test
  void testFDOApiWithMockitoManager()
      throws PidUnresolvableException, UnknownRepositoryException, UnknownRepositoryTypeException {
    // Setup Mocks for Test FDOs
    DigitalObject mockDO =
        new DigitalObject() {
          @Override
          public String getPID() {
            return "prefix/suffix";
          }

          @Override
          public JsonObject getAttributes() {
            return null;
          }

          @Override
          public boolean isFDO() {
            return false;
          }

          @Override
          public FDO toFDO() {
            return null;
          }

          @Override
          public FdoComponent toFdoComponent() {
            return null;
          }

          @Override
          public boolean isFdoComponent() {
            return false;
          }
        };
    DigitalObject mockDO2 =
        new DigitalObject() {
          @Override
          public String getPID() {
            return "suffix/prefix";
          }

          @Override
          public JsonObject getAttributes() {
            return null;
          }

          @Override
          public boolean isFDO() {
            return false;
          }

          @Override
          public FDO toFDO() {
            return null;
          }

          @Override
          public FdoComponent toFdoComponent() {
            return null;
          }

          @Override
          public boolean isFdoComponent() {
            return false;
          }
        };
    // Configure Test returns, commented out returns are there so that each set of returns has same
    // index.
    when(mockitoManager.resolvePID("prefix/suffix"))
        .thenReturn(mockDO)
        .thenReturn(mockDO2)
        .thenThrow(PidUnresolvableException.class)
        .thenReturn(mockDO)
        .thenReturn(mockDO);
    when(mockitoManager.purgeFDO("prefix/suffix"))
        .thenReturn("mock-repo-1")
        .thenReturn("mock-repo-1")
        // .thenReturn("mock-repo-1")    will not be called as PidUnresolvableException was thrown
        .thenReturn("mock-repo-1")
        .thenReturn(null);
    // Setup other returns
    RepositoryRegistry mockRepositoryRegistry = mock(DefaultRepositoryRegistry.class);
    RepositoryConnection mockRepositoryConnection = mock(RepositoryConnection.class);
    when(mockitoManager.getRepositoryRegistry()).thenReturn(mockRepositoryRegistry);
    when(mockRepositoryRegistry.createRepositoryConnection("mock-repo-1"))
        .thenReturn(mockRepositoryConnection);
    when(mockRepositoryConnection.getId()).thenReturn("mock-repo-1");
    // 1,2,4 should pass as resolvePID returns successfully and purgeFDO returns an id
    // 3 should fail because resolvePID throws PidUnresolvableException
    // 5 should fail because purgeFDO returns null
    // 6 should fail because the mockitoManager is not configured for "random/string"
    assertEquals(api.purgeFDO("prefix", "suffix").getStatusCode(), HttpStatusCode.valueOf(204));
    assertEquals(api.purgeFDO("prefix", "suffix").getStatusCode(), HttpStatusCode.valueOf(204));
    assertThrows(ResponseStatusException.class, () -> api.purgeFDO("prefix", "suffix"));
    assertEquals(api.purgeFDO("prefix", "suffix").getStatusCode(), HttpStatusCode.valueOf(204));
    assertThrows(ResponseStatusException.class, () -> api.purgeFDO("prefix", "suffix"));
    assertThrows(ResponseStatusException.class, () -> api.purgeFDO("random", "string"));
    // resolvePID("prefix/suffix") is called from 1,2,3,4,5
    // resolvePID("random/string") is called from 6
    // purgeFDO("prefix/suffix") is called from 1,2,4,5
    verify(mockitoManager, times(5)).resolvePID("prefix/suffix");
    verify(mockitoManager, times(1)).resolvePID("random/string");
    verify(mockitoManager, times(4)).purgeFDO("prefix/suffix");
  }
}
