package com.indiscale.fdo.manager;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeFalse;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.indiscale.fdo.manager.api.AuthenticationException;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import com.indiscale.fdo.manager.doip.DoipFdo;
import com.indiscale.fdo.manager.doip.DoipRepository;
import com.indiscale.fdo.manager.util.ReaderInputStream;
import com.indiscale.fdo.manager.util.Util;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.Set;
import net.dona.doip.DoipConstants;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.DisabledIf;

public class CordraIntTest {
  public static final String CORDRA_DOIP_AUTH_TOKEN = "20.DOIP/Op.Auth.Token";
  public static final String CORDRA_DOIP_AUTH_INTRO = "20.DOIP/Op.Auth.Introspect";
  public static final String CORDRA_DOIP_AUTH_REVOKE = "20.DOIP/Op.Auth.Revoke";
  public static final String CORDRA_DOIP_AUTH_CHANGE_PW = "20.DOIP/Op.ChangePassword";
  public static final String CORDRA_DOIP_AUTH_CHECK_CREDS = "20.DOIP/Op.CheckCredentials";
  public static final String CORDRA_DOIP_AUTH_INITDATA = "20.DOIP/Op.GetInitData";
  public static final String CORDRA_DOIP_AUTH_REINDEX = "20.DOIP/Op.ReindexBatch";
  public static final String CORDRA_DOIP_AUTH_BATCH = "20.DOIP/Op.BatchUpload";
  public static final String CORDRA_DOIP_AUTH_HIGHEST_SAFE = "20.DOIP/Op.HighestSafeTxnIdForSearch";
  public static final String CORDRA_DOIP_AUTH_GETDESIGN = "20.DOIP/Op.GetDesign";
  private static RepositoryConfig config = null;

  public static boolean skip() {
    return config == null;
  }

  @BeforeAll
  public static void setup() {
    String cordradJson = System.getProperty("test.cordra.json", ".test.cordra.json");
    try {
      config = Util.jsonToRepositoryConfig(new File(cordradJson));
    } catch (FileNotFoundException e) {
      System.err.println(
          "WARNING: skipping LinkAheadIntTest because the config file `"
              + cordradJson
              + "` does not exist.");
    }
  }

  @Test
  @DisabledIf("skip")
  public void testIsOnline() throws IOException {
    try (RepositoryConnection repository = new DoipRepository(config)) {
      assertTrue(repository.isOnline());
    }
  }

  @Test
  @DisabledIf("skip")
  public void testListOperations() throws IOException, AuthenticationException {
    try (DoipRepository repository = new DoipRepository(config)) {
      String[] operations = {
        DoipConstants.OP_HELLO,
        DoipConstants.OP_LIST_OPERATIONS,
        DoipConstants.OP_SEARCH,
        DoipConstants.OP_CREATE,
        CORDRA_DOIP_AUTH_TOKEN,
        CORDRA_DOIP_AUTH_INTRO,
        CORDRA_DOIP_AUTH_REVOKE,
        CORDRA_DOIP_AUTH_CHANGE_PW,
        CORDRA_DOIP_AUTH_CHECK_CREDS,
        CORDRA_DOIP_AUTH_INITDATA,
        CORDRA_DOIP_AUTH_REINDEX,
        CORDRA_DOIP_AUTH_BATCH,
        CORDRA_DOIP_AUTH_HIGHEST_SAFE,
        CORDRA_DOIP_AUTH_GETDESIGN,
      };
      assertEquals(Set.of(operations), repository.listOperations());
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateEmptyFDO() throws IOException, ValidationException {
    try (DoipRepository repository = new DoipRepository(config)) {
      Data data = new DoipFdo.DataImpl();
      Metadata metadata = new DoipFdo.MetadataImpl();
      FdoProfile profile = FdoProfile.GENERIC_FDO;

      FDO result =
          repository.createFDO(new DefaultFdo(data.getAttributes(), profile, data, metadata));
      assertNotNull(result);
      assertNotNull(result.getPID());
      assertFalse(result.getPID().isBlank());
      assertNotNull(result.getData());
      assertNotNull(result.getData().getPID());
      assertFalse(result.getData().getPID().isBlank());
      assertNotNull(result.getMetadata());
      assertNotNull(result.getMetadata().getPID());
      assertFalse(result.getMetadata().getPID().isBlank());

      // Teardown
      purgeCordraFDO(result);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateFDO() throws IOException, ValidationException {
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject content = new JsonObject();
      content.add("p1", new JsonPrimitive(1));
      DefaultData data =
          new DefaultData(new ReaderInputStream(new StringReader("testtext")), content);

      Metadata metadata = new DefaultMetadata();

      FdoProfile profile = FdoProfile.GENERIC_FDO;

      FDO result = repository.createFDO(new DefaultFdo(null, profile, data, metadata));
      assertNotNull(result);
      assertNotNull(result.getPID());
      assertFalse(result.getPID().isBlank());
      assertNotNull(result.getData());
      assertNotNull(result.getData().getPID());
      assertFalse(result.getData().getPID().isBlank());
      assertNotNull(result.getMetadata());
      assertNotNull(result.getMetadata().getPID());
      assertFalse(result.getMetadata().getPID().isBlank());

      // Teardown - should probably be in finally
      purgeCordraFDO(result);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testPurgeDO() throws UnsuccessfulOperationException {
    FDO fdo = createCordraFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      // FDO exists and can be deleted
      assertDoesNotThrow(() -> repository.purgeDO(fdo.getPID()));
      assertDoesNotThrow(() -> repository.purgeDO(fdo.getData().getPID()));
      assertDoesNotThrow(() -> repository.purgeDO(fdo.getMetadata().getPID()));
      // FDO has already been deleted
      assertThrows(UnsuccessfulOperationException.class, () -> repository.purgeDO(fdo.getPID()));
      assertThrows(
          UnsuccessfulOperationException.class, () -> repository.purgeDO(fdo.getData().getPID()));
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.purgeDO(fdo.getMetadata().getPID()));
      // FDO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.purgeDO("prefix/thisisnotasuffix24329"));
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  private String streamToString(InputStream in) {
    try {
      in.reset();
    } catch (IOException e) {
    }
    try (Scanner s = new Scanner(in).useDelimiter("\\A")) {
      return s.hasNext() ? s.next() : "";
    }
  }

  @Test
  @DisabledIf("skip")
  public void testDeleteFilesFromDo() throws UnsuccessfulOperationException, IOException {
    FDO fdo = createCordraFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      Data data = fdo.getData();
      assumeFalse(repository.retrieveFilesFromDo(data.getPID()).isEmpty());
      // File exists and can be deleted
      List<InputStream> deletedFiles = repository.deleteFilesFromDo(data.getPID());
      assertEquals(1, deletedFiles.size());
      assertEquals("testtext", streamToString(deletedFiles.get(0)));
      // File has already been deleted
      assertEquals(0, repository.retrieveFilesFromDo(data.getPID()).size());
      assertNull(repository.deleteFilesFromDo(data.getPID()));
      // File has never existed
      assertNull(repository.deleteFilesFromDo(fdo.getMetadata().getPID()));
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testAddFilesToDo() throws UnsuccessfulOperationException {
    FDO fdo = createCordraFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      // FDO does not have any files yet
      List<InputStream> newFiles = new ArrayList<>();
      newFiles.add(new ByteArrayInputStream("testtext1".getBytes(StandardCharsets.UTF_8)));
      newFiles.add(new ByteArrayInputStream("testtext2".getBytes(StandardCharsets.UTF_8)));
      repository.addFilesToDo(fdo.getPID(), newFiles);
      List<InputStream> files = repository.retrieveFilesFromDo(fdo.getPID());
      assertEquals(2, files.size());
      assertEquals("testtext1", streamToString(files.get(0)));
      assertEquals("testtext2", streamToString(files.get(1)));
      // Data already has a file
      newFiles.add(
          new ByteArrayInputStream("testtext3 arsgartq f342§".getBytes(StandardCharsets.UTF_8)));
      newFiles.add(
          new ByteArrayInputStream("testtext4 xg fszstx ✓".getBytes(StandardCharsets.UTF_8)));
      repository.addFilesToDo(fdo.getData().getPID(), newFiles);
      files = repository.retrieveFilesFromDo(fdo.getData().getPID());
      assertEquals(5, files.size());
      assertEquals("testtext", streamToString(files.get(0)));
      assertEquals("testtext1", streamToString(files.get(1)));
      assertEquals("testtext2", streamToString(files.get(2)));
      assertEquals("testtext3 arsgartq f342§", streamToString(files.get(3)));
      assertEquals("testtext4 xg fszstx ✓", streamToString(files.get(4)));
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testDeleteDoAttribute() throws UnsuccessfulOperationException {
    FDO fdo = createCordraFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject attr = repository.retrieveAttributesFromDo(fdo.getPID());
      assumeTrue(attr.has("Url"), "FDO missing attribute Url");
      assumeTrue(attr.has("FDO_status"), "FDO missing attribute FDO_status");
      assumeTrue(
          "http://thisisnotanurl.con".equals(attr.get("Url").getAsString()),
          "FDO attribute Url has incorrect value");
      assumeTrue(
          "active".equals(attr.get("FDO_status").getAsString()),
          "FDO attribute FDO_status has incorrect value");
      // Attribute does exist
      String deletedValue = repository.deleteDoAttribute(fdo.getPID(), "Url");
      assertEquals("http://thisisnotanurl.con", deletedValue);
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertFalse(attr.has("Url"));
      assertTrue(attr.has("FDO_status"));
      assertEquals("active", attr.get("FDO_status").getAsString());
      // Attribute does exist
      deletedValue = repository.deleteDoAttribute(fdo.getPID(), "FDO_status");
      assertEquals("active", deletedValue);
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertFalse(attr.has("Url"));
      assertFalse(attr.has("FDO_status"));
      // Attribute does not exist anymore
      assertNull(repository.deleteDoAttribute(fdo.getPID(), "FDO_status"));
      assertNull(repository.deleteDoAttribute(fdo.getPID(), "Url"));
      // Attribute never existed
      assertNull(repository.deleteDoAttribute(fdo.getMetadata().getPID(), "Url"));
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateUpdateDoAttribute() throws UnsuccessfulOperationException {
    FDO fdo = createCordraFDO();
    // Ensure correct setup
    assumeTrue(fdo != null);
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject attr = repository.retrieveAttributesFromDo(fdo.getPID());
      assumeTrue(attr.has("Url"), "FDO missing attribute Url");
      assumeTrue(attr.has("FDO_status"), "FDO missing attribute FDO_status");
      assumeTrue(
          "http://thisisnotanurl.con".equals(attr.get("Url").getAsString()),
          "FDO attribute Url has incorrect value");
      assumeTrue(
          "active".equals(attr.get("FDO_status").getAsString()),
          "FDO attribute FDO_status has incorrect value");
      // Attribute already exists
      String changedValue = repository.createUpdateDoAttribute(fdo.getPID(), "Url", "newUrl");
      assertEquals("http://thisisnotanurl.con", changedValue);
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertTrue(attr.has("Url"));
      assertTrue(attr.has("FDO_status"));
      assertEquals("newUrl", attr.get("Url").getAsString());
      assertEquals("active", attr.get("FDO_status").getAsString());
      // Attribute newly created
      assertFalse(attr.has("NewKey"));
      changedValue = repository.createUpdateDoAttribute(fdo.getPID(), "NewKey", "newVal");
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertNull(changedValue);
      assertTrue(attr.has("NewKey"));
      assertTrue(attr.has("Url"));
      assertTrue(attr.has("FDO_status"));
      assertEquals("newVal", attr.get("NewKey").getAsString());
      assertEquals("newUrl", attr.get("Url").getAsString());
      assertEquals("active", attr.get("FDO_status").getAsString());
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  public boolean purgeCordraFDO(FDO fdo) {
    boolean success = true;
    try (DoipRepository repository = new DoipRepository(config)) {
      repository.purgeDO(fdo.getPID());
    } catch (Exception e) {
      success = false;
    }
    try (DoipRepository repository = new DoipRepository(config)) {
      repository.purgeDO(fdo.getData().getPID());
    } catch (Exception e) {
      success = false;
    }
    try (DoipRepository repository = new DoipRepository(config)) {
      repository.purgeDO(fdo.getMetadata().getPID());
    } catch (Exception e) {
      success = false;
    }
    return success;
  }

  public FDO createCordraFDO() {
    try (DoipRepository repository = new DoipRepository(config)) {
      // Setup profile
      FdoProfile profile = FdoProfile.GENERIC_FDO;
      // Setup data
      JsonObject content = new JsonObject();
      content.addProperty("FDO_status", "active");
      content.addProperty("Url", "http://thisisnotanurl.con");
      InputStream file = new ByteArrayInputStream("testtext".getBytes(StandardCharsets.UTF_8));
      DefaultData data = new DefaultData(file, content);
      // Setup metadata
      Metadata metadata = new DefaultMetadata();
      // Setup fdo
      content = new JsonObject();
      content.addProperty("FDO_status", "active");
      content.addProperty("Url", "http://thisisnotanurl.con");
      return repository.createFDO(new DefaultFdo(content, profile, data, metadata));
    } catch (Exception e) {
      return null;
    }
  }

  @Test
  @DisabledIf("skip")
  public void testUrlRefData() throws MalformedURLException, ValidationException {
    UrlRefData data = new UrlRefData(new URL("http://example.com"));
    Metadata md = new DefaultMetadata();
    FDO fdo = new DefaultFdo(null, null, data, md);
    try (DoipRepository repository = new DoipRepository(config)) {
      fdo = repository.createFDO(fdo);
      assertNotNull(fdo.getData().getAttributes());
      assertEquals("http://example.com", fdo.getData().getAttributes().get("URL").getAsString());
    } finally {
      purgeCordraFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCustomMDProfile() throws MalformedURLException, ValidationException {
    MetadataProfile profile = new DefaultMetadataProfile("MyCustomProfile");
    Data data = new UrlRefData(new URL("http://example.com"));
    Metadata md =
        new DefaultMetadata(new ReaderInputStream(new StringReader("testtext")), null, profile);
    FDO fdo = new DefaultFdo(null, null, data, md);
    try (DoipRepository repository = new DoipRepository(config)) {
      fdo = repository.createFDO(fdo);
      System.out.println(fdo.getPID());
      assertNotNull(fdo.getMetadata().getProfile());
      assertEquals("MyCustomProfile", fdo.getMetadata().getProfile().getPID());
    } finally {
      purgeCordraFDO(fdo);
    }
  }
}
