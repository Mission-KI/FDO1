package fdoassetfetcher;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.IOException;
import java.util.List;
import com.fasterxml.jackson.databind.node.ObjectNode;

import com.fasterxml.jackson.databind.ObjectMapper;
import fdoassetfetcher.model.Asset;
import com.fasterxml.jackson.databind.JsonNode;
import fdoassetfetcher.model.Catalog;
import fdoassetfetcher.model.Dataset;

import fdoassetfetcher.service.EdcAssetManager;
import fdoassetfetcher.service.EdcCatalogFetcher;
import fdoassetfetcher.service.MetadataRepository;
import io.github.cdimascio.dotenv.Dotenv;

import java.net.http.HttpClient;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class Main {
    private static final String CONNECTOR_MANAGEMENT_URL;
    private static final String COUNTER_PARTY_ADDRESS;
    private static String authToken;
    private static final String DATASET_ID_KEY;
    private static final String CATALOG_DATASET_KEY;

    static {
        // Loads the .env file from the resources directory
        Dotenv dotenv = Dotenv.configure().load();
        CONNECTOR_MANAGEMENT_URL = dotenv.get("CONNECTOR_MANAGEMENT_URL");
        COUNTER_PARTY_ADDRESS = dotenv.get("COUNTER_PARTY_ADDRESS");
        CATALOG_DATASET_KEY = dotenv.get("CATALOG_DATASET_KEY");
        DATASET_ID_KEY = dotenv.get("DATASET_ID_KEY");
        authToken = dotenv.get("AUTH_TOKEN");
    }

    public static void main(String[] args) {
        HttpClient httpClient = HttpClient.newHttpClient();
        ObjectMapper objectMapper = new ObjectMapper();
        EdcCatalogFetcher fetcher = new EdcCatalogFetcher(httpClient, objectMapper, CONNECTOR_MANAGEMENT_URL, authToken);
        EdcAssetManager manager = new EdcAssetManager(httpClient, objectMapper, CONNECTOR_MANAGEMENT_URL, authToken);
        Set<String> assetStore = new HashSet<>();
        ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);
        System.out.println("---FDO Asset Fetcher started---");
        // Schedule fetching the catalog every 10 seconds and process any new fdo assets
        executor.scheduleAtFixedRate(() -> {
            try {
                System.out.println("Fetching catalog...");
                JsonNode catalog = fetcher.fetchCatalog(COUNTER_PARTY_ADDRESS);
                System.out.println("Fetched Catalog.");
                if (catalog == null) {
                    System.out.println("Catalog is null.");
                } else {
                    if (catalog.get(CATALOG_DATASET_KEY) == null) {
                        System.out.println("Catalog has no datasets.");
                    } else {
                        JsonNode result = catalog.get(CATALOG_DATASET_KEY);
                        Iterable<JsonNode> datasets = result;

                        if (!result.isArray()){
                          datasets = List.of(result);
                        }
                        for ( JsonNode dataset : datasets){
                        if (dataset.get(DATASET_ID_KEY) == null){
                          throw new IOException("Dataset ID is needed.");
                        }

                        String datasetId = dataset.get(DATASET_ID_KEY).asText();
                        // Check if the asset needs to be updated
                        //
                        // TODO we can remove the asset store, because we can
                        // filter the assets with respect to the FDOPID
                        if (!assetStore.contains(datasetId)) {
                            assetStore.add(datasetId);
                            System.out.printf("New Dataset ID: %s%n", datasetId);
                            try {
                                // Save dataset entry into FDO repo
                                String fdoPid = MetadataRepository.addDatasetToRepository(dataset, "mock-profile-1");
                                JsonNode assetWithFdoPid = manager.updateAssetWithFdoPid(datasetId, fdoPid);
                                // Update the asset on the connector
                                boolean success = manager.updateAsset(assetWithFdoPid);
                                if (success) {
                                    System.out.println("Updated asset with ID: " + datasetId);
                                } else {
                                    System.out.println("Failed to update asset with ID: " + datasetId);
                                }
                                System.out.println("Dataset is done");
                            } catch (Exception e) {
                                System.err.println("Error adding dataset to repository: " + e.getMessage());
                                e.printStackTrace();
                            }
                        }
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Exception during catalog fetching: " + e.getMessage());
                e.printStackTrace();
            }
            System.out.println("waiting...");
        }, 0, 10, TimeUnit.SECONDS);

        // Schedule a daily check for token updates
        executor.scheduleAtFixedRate(() -> {
            try {
                Dotenv dotenv = Dotenv.configure().load();
                String newAuthToken = dotenv.get("AUTH_TOKEN");
                if (newAuthToken != null && !newAuthToken.equals(authToken)) {
                    authToken = newAuthToken;
                    fetcher.updateAuthToken(newAuthToken);
                    manager.updateAuthToken(newAuthToken);
                    System.out.println("Auth token updated to: " + newAuthToken);
                }
            } catch (Exception e) {
                System.err.println("Exception during token update: " + e.getMessage());
                e.printStackTrace();
            }
        }, 0, 1, TimeUnit.DAYS);

        System.out.println("---FDO Asset Fetcher stopped---");
    }
}
