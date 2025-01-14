package fdoassetfetcher.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;

import fdoassetfetcher.model.Asset;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Optional;

public class EdcAssetManager {
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    private final String managementUrl;
    private String authToken;

    public EdcAssetManager(HttpClient httpClient, ObjectMapper objectMapper, String managementUrl, String authToken) {
        this.httpClient = httpClient;
        this.objectMapper = objectMapper;
        this.managementUrl = managementUrl;
        this.authToken = authToken;
        this.objectMapper.registerModule(new Jdk8Module());
    }

    public synchronized void updateAuthToken(String authToken) {
        this.authToken = authToken;
    }

    public JsonNode fetchAsset(String assetId) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(managementUrl + "/v3/assets/" + assetId))
                //.header("Authorization", "Bearer " + authToken)
                .header("X-Api-Key", "ApiKeyDefaultValue")
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {

            try{
                return objectMapper.readTree(response.body());
            } catch (Exception e) {
                System.out.println(e);
                System.out.println("Failed to fetch catalog: \n" + response.body());
                return null;
            }

        } else {
            System.out.println("Failed to fetch asset: " + response.body());
            return null;
        }
    }

    public boolean createAsset(Asset asset) throws IOException, InterruptedException {
        String assetJson = objectMapper.writeValueAsString(asset);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(managementUrl + "/v3/assets"))
                .header("Content-Type", "application/json")
                //.header("Authorization", "Bearer " + authToken)
                .header("X-Api-Key", "ApiKeyDefaultValue")
                .POST(HttpRequest.BodyPublishers.ofString(assetJson))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            System.out.println("Asset created successfully.");
            return true;
        } else {
            System.out.println("Failed to create asset: " + response.body());
            return false;
        }
    }

    public boolean updateAsset(JsonNode asset) throws IOException, InterruptedException {
        String assetJson = objectMapper.writeValueAsString(asset);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(managementUrl + "/v3/assets"))
                .header("Content-Type", "application/json")
                //.header("Authorization", "Bearer " + authToken)
                .header("X-Api-Key", "ApiKeyDefaultValue")
                .PUT(HttpRequest.BodyPublishers.ofString(assetJson))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 204) {
            System.out.println("Asset updated successfully.");
            return true;
        } else {
            System.out.println("Failed to update asset: " + response.body());
            return false;
        }
    }

    public boolean deleteAsset(String assetId) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(managementUrl + "/v3/assets/" + assetId))
                //.header("Authorization", "Bearer " + authToken)
                .header("X-Api-Key", "ApiKeyDefaultValue")
                .DELETE()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 204) {
            System.out.println("Asset deleted successfully.");
            return true;
        } else {
            System.out.println("Failed to delete asset: " + response.body());
            return false;
        }
    }

    public JsonNode updateAssetWithFdoPid(String assetId, String fdoPid) throws IOException, InterruptedException {
        JsonNode asset = this.fetchAsset(assetId);
        if (asset != null) {
            // Retrieve the current properties and create a new Properties object with the new fdoPid
            ObjectNode props = null;
            if (asset.get("edc:properties") != null){
              ((ObjectNode) asset.get("edc:properties")).put("edc:fdoPid", fdoPid);
            } else if (asset.get("properties")!= null) {
              ((ObjectNode) asset.get("properties")).put("edc:fdoPid", fdoPid);
            } else {
              throw new IOException("No properties key in asset");
            }
            return asset;
        }
        return null;
    }
}
