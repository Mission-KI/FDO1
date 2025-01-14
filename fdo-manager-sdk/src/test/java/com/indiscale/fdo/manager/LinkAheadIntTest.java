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
import com.indiscale.fdo.manager.api.AuthenticationException;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.ProfileValidator;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.api.TokenAuthenticationInfo;
import com.indiscale.fdo.manager.api.UnsuccessfulOperationException;
import com.indiscale.fdo.manager.api.ValidationException;
import com.indiscale.fdo.manager.api.ValidationResult;
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

public class LinkAheadIntTest {

  private static RepositoryConfig config = null;

  public static boolean skip() {
    return config == null;
  }

  @BeforeAll
  public static void setup() {
    String linkaheadJson = System.getProperty("test.linkahead.json", ".test.linkahead.json");
    try {
      config = Util.jsonToRepositoryConfig(new File(linkaheadJson));
    } catch (FileNotFoundException e) {
      System.err.println(
          "WARNING: skipping LinkAheadIntTest because the config file `"
              + linkaheadJson
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
        DoipConstants.OP_RETRIEVE,
        DoipConstants.OP_DELETE,
        DoipConstants.OP_UPDATE
      };
      assertEquals(Set.of(operations), repository.listOperations());
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateEmptyFDO() throws IOException, ValidationException {
    try (DoipRepository repository = new DoipRepository(config)) {
      Data data = new DefaultData();
      Metadata metadata = new DefaultMetadata();
      FdoProfile profile =
          new FdoProfile() {

            @Override
            public ProfileValidator<FDO> getValidator() {
              return new ProfileValidator<FDO>() {

                @Override
                public ValidationResult validate(FDO t) {
                  return new ValidationResult() {

                    @Override
                    public boolean isValid() {
                      return true;
                    }

                    @Override
                    public List<com.indiscale.fdo.manager.api.ValidationError> getErrors() {
                      return new ArrayList<>();
                    }
                  };
                }
              };
            }

            @Override
            public String getId() {
              return "MockProfile";
            }

            @Override
            public String getDescription() {
              // TODO Auto-generated method stub
              return null;
            }

            @Override
            public String getPID() {
              return getId();
            }

            @Override
            public JsonObject getAttributes() {
              // TODO Auto-generated method stub
              return null;
            }

            @Override
            public boolean isFDO() {
              // TODO Auto-generated method stub
              return false;
            }

            @Override
            public FDO toFDO() {
              // TODO Auto-generated method stub
              return null;
            }
          };

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

      // Teardown
      purgeLinkaheadFDO(result);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testAuthenticationFailed() {
    try (DoipRepository repository = new DoipRepository(config)) {
      repository.setTokenAuthenticationInfo(new TokenAuthenticationInfo("token"));
      assertThrows(AuthenticationException.class, repository::listOperations);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateFDO() throws IOException, ValidationException {
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject dataattributes = new JsonObject();
      DefaultData data =
          new DefaultData(new ReaderInputStream(new StringReader("testtext")), dataattributes);

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

      // Teardown
      purgeLinkaheadFDO(result);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testPurgeDO() {
    FDO fdo = createLinkaheadFDO();
    assumeTrue(fdo != null);
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
      purgeLinkaheadFDO(fdo);
    }
  }

  private String streamToString(InputStream in) {
    try {
      in.reset();
    } catch (IOException e) {
    }
    try (Scanner s = new Scanner(in).useDelimiter("\\A"); ) {
      return s.hasNext() ? s.next() : "";
    }
  }

  @Test
  @DisabledIf("skip")
  public void testDeleteFilesFromDo() throws UnsuccessfulOperationException, IOException {
    FDO fdo = createLinkaheadFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      Data data = fdo.getData();
      assumeFalse(repository.retrieveFilesFromDo(data.getPID()).isEmpty());
      // File exists and can be deleted
      repository.deleteFilesFromDo(data.getPID());
      // File has already been deleted
      assertEquals(0, repository.retrieveFilesFromDo(data.getPID()).size());
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeLinkaheadFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testAddFilesToDo() throws UnsuccessfulOperationException {
    FDO fdo = createLinkaheadFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      // FDO does not have any files yet
      List<InputStream> newFiles = new ArrayList<>();
      newFiles.add(new ByteArrayInputStream("testtext1".getBytes(StandardCharsets.UTF_8)));
      repository.addFilesToDo(fdo.getPID(), newFiles);
      List<InputStream> files = repository.retrieveFilesFromDo(fdo.getPID());
      assertEquals(1, files.size());
      assertEquals("testtext1", streamToString(files.get(0)));
      // Data already has a file
      newFiles.add(
          new ByteArrayInputStream("testtext3 arsgartq f342§".getBytes(StandardCharsets.UTF_8)));
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.addFilesToDo(fdo.getData().getPID(), newFiles));
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeLinkaheadFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testDeleteDoAttribute() throws UnsuccessfulOperationException {
    FDO fdo = createLinkaheadFDO();
    // Ensure correct setup
    assumeTrue(fdo != null, "FDO not created successfully");
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject attr = repository.retrieveAttributesFromDo(fdo.getPID());
      assumeTrue(
          attr.has(config.get("typeStatus", "FDO_Status")), "FDO missing attribute FDO_status");
      assumeTrue(
          "active".equals(attr.get(config.get("typeStatus", "FDO_Status")).getAsString()),
          "FDO attribute FDO_status has incorrect value");
      // Attribute does exist
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertTrue(attr.has(config.get("typeStatus", "FDO_Status")));
      assertEquals("active", attr.get(config.get("typeStatus", "FDO_Status")).getAsString());
      // Attribute does exist
      String deletedValue =
          repository.deleteDoAttribute(fdo.getPID(), config.get("typeStatus", "FDO_Status"));
      assertEquals("active", deletedValue);
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertFalse(attr.has(config.get("typeStatus", "FDO_Status")));
      // Attribute does not exist anymore
      assertNull(
          repository.deleteDoAttribute(fdo.getPID(), config.get("typeStatus", "FDO_Status")));
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeLinkaheadFDO(fdo);
    }
  }

  @Test
  @DisabledIf("skip")
  public void testCreateUpdateDoAttribute() throws UnsuccessfulOperationException {
    FDO fdo = createLinkaheadFDO();
    // Ensure correct setup
    assumeTrue(fdo != null);
    try (DoipRepository repository = new DoipRepository(config)) {
      JsonObject attr = repository.retrieveAttributesFromDo(fdo.getPID());
      assumeTrue(
          attr.has(config.get("typeStatus", "FDO_Status")), "FDO missing attribute FDO_status");
      assumeTrue(
          "active".equals(attr.get(config.get("typeStatus", "FDO_Status")).getAsString()),
          "FDO attribute FDO_status has incorrect value");
      // Attribute already exists
      attr = repository.retrieveAttributesFromDo(fdo.getPID()); // Check successful update
      assertTrue(attr.has(config.get("typeStatus", "FDO_Status")));
      assertEquals("active", attr.get(config.get("typeStatus", "FDO_Status")).getAsString());
      // Attribute newly created
      assertTrue(attr.has(config.get("typeStatus", "FDO_Status")));
      assertEquals("active", attr.get(config.get("typeStatus", "FDO_Status")).getAsString());
      // DO does not exist
      assertThrows(
          UnsuccessfulOperationException.class,
          () -> repository.deleteFilesFromDo("prefix/thisisnotasuffix24329"));
    } finally {
      purgeLinkaheadFDO(fdo);
    }
  }

  public boolean purgeLinkaheadFDO(FDO fdo) {
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

  public FDO createLinkaheadFDO() {
    try (DoipRepository repository = new DoipRepository(config)) {
      // Setup profile
      FdoProfile profile = FdoProfile.GENERIC_FDO;
      // Setup data
      JsonObject content = new JsonObject();
      content.addProperty(config.get("typeStatus", "FDO_Status"), "active");
      InputStream file = new ByteArrayInputStream("testtext".getBytes(StandardCharsets.UTF_8));
      DefaultData data = new DefaultData(file, content);
      // Setup metadata
      Metadata metadata = new DefaultMetadata();
      // Setup fdo
      content = new JsonObject();
      content.addProperty(config.get("typeStatus", "FDO_Status"), "active");
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
      System.out.println(fdo.getPID());
      assertNotNull(fdo.getData().getAttributes());
      assertEquals("http://example.com", fdo.getData().getAttributes().get("URL").getAsString());
    } finally {
      purgeLinkaheadFDO(fdo);
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
      purgeLinkaheadFDO(fdo);
    }
  }
}
