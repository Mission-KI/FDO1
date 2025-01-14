package com.indiscale.fdo.manager.mock;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.google.gson.JsonObject;
import com.indiscale.fdo.manager.DefaultData;
import com.indiscale.fdo.manager.DefaultMetadata;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.PidUnresolvableException;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.UnknownProfileException;
import com.indiscale.fdo.manager.api.UnknownRepositoryException;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import org.junit.jupiter.api.Test;

public class MockManagerTest {

  @Test
  public void testListRepositories() throws UnknownRepositoryException {
    try (Manager manager = new MockManager()) {
      List<RepositoryConfig> listRepositories = manager.getRepositoryRegistry().listRepositories();

      // the MockManager knows three (in-memory) repositories
      assertEquals(3, listRepositories.size());
      assertEquals("mock-repo-1", listRepositories.get(0).getId());
      assertEquals("mock-repo-2", listRepositories.get(1).getId());
      assertEquals("mock-repo-3", listRepositories.get(2).getId());

      assertNotNull(manager.getRepositoryRegistry().getRepositoryConfig("mock-repo-1"));
      assertThrows(
          UnknownRepositoryException.class,
          () -> manager.getRepositoryRegistry().getRepositoryConfig("unknown-repo"));
    }
  }

  @Test
  public void testListProfiles() throws UnknownProfileException {
    try (Manager manager = new MockManager()) {
      List<FdoProfile> listProfiles = manager.getProfileRegistry().listProfiles();
      assertEquals(1, listProfiles.size());

      // the MockManager knows one FDO profile
      assertEquals(manager.getDefaultProfile(), listProfiles.get(0));
      assertEquals("mock-profile-1", listProfiles.get(0).getId());
      assertNotNull(manager.getProfileRegistry().getProfile("mock-profile-1"));

      assertThrows(
          UnknownProfileException.class,
          () -> manager.getProfileRegistry().getProfile("unknown-profile"));
    }
  }

  @Test
  public void testCreateFDO()
      throws UnknownRepositoryException, ValidationException, UnknownProfileException {
    try (Manager manager = new MockManager()) {

      // 1. Specify the FDO profile
      // The MockManager knows one FDO profile and that's mock-profile-1
      FdoProfile profile = manager.getProfileRegistry().getProfile("mock-profile-1");

      // 2. Specify the target repository (where the FDO is gonna be stored)
      // The MockManager knows three (in-memory) repositories: mock-repo-{1,2,3}
      RepositoryConnection repository =
          manager.getRepositoryRegistry().createRepositoryConnection("mock-repo-1");

      // 3. Specify the data and meta data.
      // You need an InputStream to use the Default{Data,Metadata}
      // implementation. You also implement the interfaces yourself, ofc.
      InputStream dataInputStream = new ByteArrayInputStream("this is data".getBytes());
      InputStream mdInputStream = new ByteArrayInputStream("this is metadata".getBytes());

      Data data = new DefaultData(dataInputStream);
      Metadata metadata = new DefaultMetadata(mdInputStream);

      // 4. Create the FDO --- That's it
      FDO fdo = manager.createFDO(profile, null, repository, data, metadata);

      assertNotNull(fdo.getPID()); // new PID

      // Teardown
      deleteMockFDO(fdo);
    }
  }

  @Test
  public void testPurgeFDO() throws UnknownRepositoryException {
    // Setup - Create new FDO to delete
    FDO fdo = createMockFDO();
    assumeTrue(fdo != null);
    String fdo_pid = fdo.getPID();
    String data_pid = fdo.getData().getPID();
    String metadata_pid = fdo.getMetadata().getPID();
    try (Manager manager = new MockManager()) {
      // FDO exists and can be deleted
      assertNotNull(manager.purgeFDO(fdo_pid));
      // Check successful delete - if resolvePID does not work, this test has been skipped in setup
      assertThrows(PidUnresolvableException.class, () -> manager.resolvePID(fdo_pid));
      assertThrows(PidUnresolvableException.class, () -> manager.resolvePID(data_pid));
      assertThrows(PidUnresolvableException.class, () -> manager.resolvePID(metadata_pid));
      // FDO has already been deleted
      assertThrows(PidUnresolvableException.class, () -> manager.purgeFDO(fdo_pid));
      assertThrows(PidUnresolvableException.class, () -> manager.purgeFDO(data_pid));
      assertThrows(PidUnresolvableException.class, () -> manager.purgeFDO(metadata_pid));
      // FDO does not exist
      assertThrows(
          PidUnresolvableException.class, () -> manager.purgeFDO("prefix/thisisnotasuffix24329"));
    } catch (PidUnresolvableException e) {
      fail("PID " + fdo_pid + " of FDO created by Setup Method not recognized.");
    } finally {
      deleteMockFDO(fdo);
    }
  }

  @Test
  public void testDeleteFDO()
      throws PidUnresolvableException,
          UnsuccessfulOperationException,
          UnknownRepositoryException,
          IOException {
    // Setup - Create new FDO to delete
    FDO fdo = createMockFDO();
    FDO fdo2 = createMockFDO();
    assumeTrue(fdo != null);
    assumeTrue(fdo2 != null);
    try (Manager manager = new MockManager()) {
      String fdo_pid = fdo.getPID();
      String data_pid = fdo.getData().getPID();
      String metadata_pid = fdo.getMetadata().getPID();
      String fdo_pid2 = fdo2.getPID();
      String data_pid2 = fdo2.getData().getPID();
      String metadata_pid2 = fdo2.getMetadata().getPID();
      // FDO exists and can be deleted
      assertNotNull(manager.deleteFDO(fdo_pid));
      FDO deletedFdo = manager.resolvePID(fdo_pid).toFDO();
      Data deletedData = deletedFdo.getData();
      Metadata deletedMetadata = deletedFdo.getMetadata();
      // Check successful delete
      // Cannot delete with current version of Mock
      // assertNull(deletedData.getInputStream()); // Data bit-sequence deleted
      assertTrue(
          deletedData.getAttributes().has("FDO_Status")); // Data FDO_status attribute is “deleted”
      assertEquals("deleted", deletedData.getAttributes().get("FDO_Status").getAsString());
      assertTrue(deletedData.getAttributes().has("URL_Status")); // Data URL_status attribute added
      assertTrue(
          deletedFdo.getAttributes().has("FDO_Status")); // FDO FDO_status attribute is “deleted”
      assertEquals("deleted", deletedFdo.getAttributes().get("FDO_Status").getAsString());
      assertEquals(fdo.getMetadata().getAttributes(), deletedMetadata.getAttributes());
      assertEquals(fdo.getMetadata().getInputStream(), deletedMetadata.getInputStream());
      // FDO exists and can be deleted including metadata
      assertNotNull(manager.deleteFDO(fdo_pid, true));
      // Check successful delete
      // Check successful delete
      // Data bit-sequence deleted
      // Metadata bit-sequence deleted
      // Data FDO_status attribute set to “deleted”
      // Metadata FDO_status attribute set to “deleted”
      // Data URL_status attribute added
      // Metadata URL_status attribute added
      // FDO FDO_status attribute set to “deleted”
      // FDO has already been deleted
      // Invalid target: not an FDO

      // FDO does not exist
      assertThrows(
          PidUnresolvableException.class, () -> manager.deleteFDO("prefix/thisisnotasuffix24329"));
    } finally {
      deleteMockFDO(fdo);
      deleteMockFDO(fdo2);
    }
  }

  public boolean deleteMockFDO(FDO fdo) {
    try (Manager manager = new MockManager()) {
      manager.purgeFDO(fdo.getPID());
      if (manager.resolvePID(fdo.getPID()) == null
          && manager.resolvePID(fdo.getData().getPID()) == null
          && manager.resolvePID(fdo.getMetadata().getPID()) == null) {
        return true;
      }
      return false;
    } catch (Exception e) {
      return false;
    }
  }

  public FDO createMockFDO() {
    try (Manager manager = new MockManager()) {
      FdoProfile profile = manager.getProfileRegistry().getProfile("mock-profile-1");
      RepositoryConnection repository =
          manager.getRepositoryRegistry().createRepositoryConnection("mock-repo-1");
      InputStream dataInputStream = new ByteArrayInputStream("this is data".getBytes());
      InputStream mdInputStream = new ByteArrayInputStream("this is metadata".getBytes());
      Data data = new DefaultData(dataInputStream, new JsonObject());
      Metadata metadata = new DefaultMetadata(mdInputStream, new JsonObject());
      FDO fdo = manager.createFDO(profile, null, repository, data, metadata);
      // Check created FDO for completeness
      if (manager.resolvePID(fdo.getPID()) != null
          && manager.resolvePID(fdo.getData().getPID()) != null
          && manager.resolvePID(fdo.getMetadata().getPID()) != null)
        // FDO created successfully
        return fdo;
    } catch (Exception e) {
      return null;
    }
    return null;
  }
}
