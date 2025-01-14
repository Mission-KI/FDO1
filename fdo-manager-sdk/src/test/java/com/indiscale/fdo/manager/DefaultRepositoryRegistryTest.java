package com.indiscale.fdo.manager;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.RepositoryConnectionFactory;
import com.indiscale.fdo.manager.api.RepositoryType;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnknownRepositoryTypeException;
import com.indiscale.fdo.manager.doip.DoipRepositoryFactory;
import org.junit.jupiter.api.Test;

public class DefaultRepositoryRegistryTest {

  @Test
  public void testGetRepositoryTypes() {
    DefaultRepositoryRegistry registry = new DefaultRepositoryRegistry();
    assertEquals(0, registry.getRepositoryTypes().size());

    registry.registerRepositoryType(new DoipRepositoryFactory());

    assertTrue(registry.getRepositoryTypes().contains(DoipRepositoryFactory.TYPE));

    registry.registerRepositoryType(
        new RepositoryConnectionFactory() {

          @Override
          public RepositoryType getType() {
            return new RepositoryType("ROCrate");
          }

          @Override
          public RepositoryConnection createConnection(RepositoryConfig config) {
            return null;
          }
        });

    assertEquals(2, registry.getRepositoryTypes().size());
    assertTrue(registry.getRepositoryTypes().contains(new RepositoryType("ROCrate")));
  }

  @Test
  public void testRegisterRepository() {
    DefaultRepositoryRegistry registry = new DefaultRepositoryRegistry();
    assertEquals(0, registry.getRepositoryTypes().size());

    assertThrows(NullPointerException.class, () -> registry.registerRepository(null));
    assertThrows(
        IllegalArgumentException.class,
        () -> registry.registerRepository(new DefaultRepositoryConfig(null, "blub")));
    assertThrows(
        UnknownRepositoryTypeException.class,
        () ->
            registry.registerRepository(
                new DefaultRepositoryConfig(new RepositoryType("unknown"), "blub")));
  }

  @Test
  public void testListRepositories() throws UnknownRepositoryTypeException {
    DefaultRepositoryRegistry registry = new DefaultRepositoryRegistry();
    assertEquals(0, registry.listRepositories().size());
    registry.registerRepositoryType(new DoipRepositoryFactory());

    RepositoryConfig config = new DefaultRepositoryConfig(DoipRepositoryFactory.TYPE, "testId");
    registry.registerRepository(config);
    assertEquals(1, registry.listRepositories().size());
    assertEquals(DoipRepositoryFactory.TYPE, registry.listRepositories().get(0).getType());
    assertEquals("testId", registry.listRepositories().get(0).getId());
  }

  @Test
  public void testGetRepositoryType() throws UnknownRepositoryTypeException {
    DefaultRepositoryRegistry registry = new DefaultRepositoryRegistry();
    registry.registerRepositoryType(new DoipRepositoryFactory());
    assertEquals(
        DoipRepositoryFactory.TYPE, registry.getRepositoryType(DoipRepositoryFactory.TYPE.id));
    assertThrows(NullPointerException.class, () -> registry.getRepositoryType(null));
    assertThrows(UnknownRepositoryTypeException.class, () -> registry.getRepositoryType("unknown"));
  }

  @Test
  public void testGetRepository()
      throws UnknownRepositoryException, UnknownRepositoryTypeException {
    DefaultRepositoryRegistry registry = new DefaultRepositoryRegistry();
    registry.registerRepositoryType(new DoipRepositoryFactory());
    RepositoryType type = DoipRepositoryFactory.TYPE;
    DefaultRepositoryConfig config = new DefaultRepositoryConfig(type, "testId");
    registry.registerRepository(config);
    assertEquals(type, registry.getRepositoryConfig("testId").getType());
    assertThrows(NullPointerException.class, () -> registry.getRepositoryConfig(null));
    assertThrows(UnknownRepositoryException.class, () -> registry.getRepositoryConfig("unknown"));
  }
}
