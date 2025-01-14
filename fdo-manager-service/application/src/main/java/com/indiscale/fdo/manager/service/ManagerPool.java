package com.indiscale.fdo.manager.service;

import com.indiscale.fdo.manager.DefaultManager;
import com.indiscale.fdo.manager.DefaultProfileRegistry;
import com.indiscale.fdo.manager.DefaultRepositoryRegistry;
import com.indiscale.fdo.manager.DelegatorManager;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.UnknownProfileException;
import com.indiscale.fdo.manager.api.UnknownRepositoryTypeException;
import com.indiscale.fdo.manager.doip.DoipRepositoryFactory;
import com.indiscale.fdo.manager.mock.MockManager;
import com.indiscale.fdo.manager.util.Util;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import stormpot.Allocator;
import stormpot.Pool;
import stormpot.PoolException;
import stormpot.Poolable;
import stormpot.Slot;
import stormpot.Timeout;

@Service
public class ManagerPool {

  private static DefaultRepositoryRegistry registry = null;

  private static List<RepositoryConfig> getConfig()
      throws IOException, UnknownRepositoryTypeException {
    List<RepositoryConfig> result = new ArrayList<>();
    String repositoriesProperty = System.getProperty("repositoriesDir", "repositories");
    File repositoriesDir = new File(repositoriesProperty);
    if (repositoriesDir.isDirectory()) {
      for (File repo :
          repositoriesDir.listFiles(
              new FilenameFilter() {
                @Override
                public boolean accept(File dir, String name) {
                  return name.endsWith(".json") && !new File(dir, name).isDirectory();
                }
              })) {

        RepositoryConfig config = Util.jsonToRepositoryConfig(repo);
        registry.registerRepository(config);
      }

    } else {
      throw new IOException(
          "ERROR: cannot read repository config directory: " + repositoriesProperty);
    }
    return result;
  }

  private static DefaultRepositoryRegistry getRepositoryRegistry() {
    if (registry == null) {
      registry = new DefaultRepositoryRegistry(new DoipRepositoryFactory());
      try {
        for (RepositoryConfig config : getConfig()) {
          registry.registerRepository(config);
        }
      } catch (IOException | UnknownRepositoryTypeException e) {
        e.printStackTrace();
      }
    }
    return registry;
  }

  private static DefaultManager createManager() {
    DefaultManager result = new DefaultManager(getRepositoryRegistry(), getProfileRegistry());
    try {
      result.setDefaultProfile(FdoProfile.GENERIC_FDO.getId());
    } catch (UnknownProfileException e) {
      e.printStackTrace();
    }
    return result;
  }

  private static DefaultProfileRegistry<FdoProfile> getProfileRegistry() {
    DefaultProfileRegistry<FdoProfile> result = new DefaultProfileRegistry<>();
    result.registerProfile(FdoProfile.GENERIC_FDO);
    return result;
  }

  public static class PooledManager extends DelegatorManager implements Poolable {

    private Slot slot;

    public PooledManager(Manager manager, Slot slot) {
      super(manager);
      this.slot = slot;
    }

    @Override
    public void release() {
      this.slot.release(this);
    }

    @Override
    public void close() {
      this.release();
    }
  }

  public static class ManagerAllocator implements Allocator<PooledManager> {

    private ManagerFactory factory;

    public ManagerAllocator(ManagerFactory factory) {
      this.factory = factory;
    }

    @Override
    public PooledManager allocate(Slot slot) throws Exception {
      return new PooledManager(factory.create(), slot);
    }

    @Override
    public void deallocate(PooledManager poolable) throws Exception {
      poolable.close();
    }
  }

  public static class ManagerPoolTimeoutException extends Exception {

    private static final long serialVersionUID = -1400402103379045494L;
  }

  private static Logger logger = LoggerFactory.getLogger(ManagerPool.class);

  public static interface ManagerFactory {
    public Manager create();
  }

  private static Pool<PooledManager> pool =
      Pool.from(
              new ManagerAllocator(
                  new ManagerFactory() {

                    @Override
                    public Manager create() {
                      if (System.getProperty("mock", "false").equals("true")) {
                        logger.warn("Creating MockManager");
                        return new MockManager();
                      } else {
                        return createManager();
                      }
                    }
                  }))
          .build();

  Timeout timeout = new Timeout(5, TimeUnit.SECONDS);

  public Manager getManager() {

    try {
      Manager manager = pool.claim(timeout);
      if (manager == null) {
        throw new ManagerPoolTimeoutException();
      }
      return manager;
    } catch (PoolException | InterruptedException e) {
      e.printStackTrace();
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, e.getLocalizedMessage());
    } catch (ManagerPoolTimeoutException e) {
      throw new ResponseStatusException(
          HttpStatus.REQUEST_TIMEOUT, "Service is under high load. Please try again later.");
    }
  }
}
