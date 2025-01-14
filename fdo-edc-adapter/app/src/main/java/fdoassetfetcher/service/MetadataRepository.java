package fdoassetfetcher.service;
import java.io.ByteArrayInputStream;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.indiscale.fdo.manager.DefaultData;
import com.indiscale.fdo.manager.DefaultFdo;
import com.indiscale.fdo.manager.DefaultFdoType;
import com.indiscale.fdo.manager.DefaultMetadata;
import com.indiscale.fdo.manager.DefaultMetadataProfile;
import com.indiscale.fdo.manager.UrlRefData;
import com.indiscale.fdo.manager.api.Data;
import com.indiscale.fdo.manager.api.FDO;
import com.indiscale.fdo.manager.api.FdoType;
import com.indiscale.fdo.manager.api.FdoProfile;
import com.indiscale.fdo.manager.api.Metadata;
import com.indiscale.fdo.manager.api.MetadataProfile;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConnection;
import com.indiscale.fdo.manager.doip.DoipRepository;
import com.indiscale.fdo.manager.mock.MockRepositoryFactory;
import com.indiscale.fdo.manager.util.Util;

import fdoassetfetcher.model.Dataset;
import io.github.cdimascio.dotenv.Dotenv;

public class MetadataRepository {

    private static final String REPOSITORY_TYPE;
    private static final String ASSET_METADATA_KEY;
    private static final String CONNECTOR_ENDPOINT;
    private static final String METADATA_PROFILE;

    static {
        // Loads the .env file from the resources directory
        Dotenv dotenv = Dotenv.configure().load();
        REPOSITORY_TYPE = dotenv.get("REPOSITORY_TYPE");
        ASSET_METADATA_KEY = dotenv.get("ASSET_METADATA_KEY");
        CONNECTOR_ENDPOINT = dotenv.get("CONNECTOR_ENDPOINT");
        METADATA_PROFILE = dotenv.get("METADATA_PROFILE");
    }

    public static String addDatasetToRepository(JsonNode dataset, String profileName) {
        String linkAheadJson = ".test.cordra.json";
        RepositoryConfig config = getRepositoryConfig(linkAheadJson);
        if (config == null) {
            System.err.println("Repository configuration could not be loaded.");
            return null;
        }

        try {
            RepositoryConnection repository;
            if ("MOCK".equalsIgnoreCase(REPOSITORY_TYPE)) {
                MockRepositoryFactory mockFactory = new MockRepositoryFactory(
                    new HashMap<> ());
                repository = mockFactory.createConnection(config);
            } else {
                repository = new DoipRepository(config);
            }
            FdoProfile profile = FdoProfile.GENERIC_FDO;
            ObjectMapper objectMapper = new ObjectMapper();
            InputStream mdInputStream = null;
            if (dataset.get(ASSET_METADATA_KEY)!=null){
              mdInputStream = new ByteArrayInputStream(objectMapper.writeValueAsString(dataset.get(ASSET_METADATA_KEY)).getBytes(StandardCharsets.UTF_8));
            }
            else{
                throw new IOException("Missing Metadata");
            }
            MetadataProfile mdprofile = new DefaultMetadataProfile(METADATA_PROFILE);
            FdoType fdotype = new DefaultFdoType("21.T11966/f7f29218c8d5832ab5b5");
            Data data = new UrlRefData(new URL(CONNECTOR_ENDPOINT));
            Metadata md = new DefaultMetadata(mdInputStream, null, mdprofile);

            ObjectMapper mapper = new ObjectMapper();
            String jsonString = mapper.writeValueAsString(dataset);
            JsonParser jsonParser = new JsonParser();
            JsonObject attrs =  jsonParser.parse(jsonString).getAsJsonObject();
            //JsonObject attrs = new JsonObject();
            //attrs.add("license", new JsonPrimitive("CC0"));
            System.out.println(attrs);

            FDO fdo = repository.createFDO(new DefaultFdo(attrs, profile, fdotype, data , md));
            System.out.println("Created FDO with PID: " + fdo.getPID());
            return fdo.getPID();
        } catch (Exception e) {
            System.err.println("Error while adding dataset to repository: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private static RepositoryConfig getRepositoryConfig(String linkAheadJson) {
        try (InputStream resourceStream = new FileInputStream(linkAheadJson)) {
            if (resourceStream == null) {
                throw new IOException("File not found");
            }
            String jsonContent = new String(resourceStream.readAllBytes(), StandardCharsets.UTF_8);
            return Util.jsonToRepositoryConfig(jsonContent);
        } catch (IOException e) {
            System.err.println(
                    "WARNING: Cannot setup connection to LinkAhead since the config file `"
                            + linkAheadJson
                            + "` does not exist.");
            e.printStackTrace();
            return null;
        }
    }

    private static Data getDataFromDataset(Dataset dataset) {
        try {
            return new DefaultData(new FileInputStream("../" + dataset.id())); //TODO replace by data URL
        } catch (FileNotFoundException e) {
            System.err.println("File not found for ID `" + dataset.id() + "`, using default data URL.");
        }
        return new DefaultData(new ByteArrayInputStream("https://jsonplaceholder.typicode.com/todos".getBytes(StandardCharsets.UTF_8))); //TODO replace by data URL
    }
}
