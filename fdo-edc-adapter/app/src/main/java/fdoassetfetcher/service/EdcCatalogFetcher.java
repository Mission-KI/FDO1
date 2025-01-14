package fdoassetfetcher.service;

import com.fasterxml.jackson.databind.JsonNode;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import jakarta.json.Json;
import jakarta.json.JsonObject;

import fdoassetfetcher.model.Catalog;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class EdcCatalogFetcher {
    private final String managementUrl;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    private String authToken;

    public EdcCatalogFetcher(HttpClient httpClient, ObjectMapper objectMapper, String managementUrl, String authToken) {
        this.httpClient = httpClient;
        this.objectMapper = objectMapper;
        this.managementUrl = managementUrl;
        this.authToken = authToken;
        this.objectMapper.registerModule(new Jdk8Module());
    }

    public synchronized void updateAuthToken(String authToken) {
        this.authToken = authToken;
    }

    public JsonNode fetchCatalog(String counterPartyAddress) throws IOException, InterruptedException {
        JsonObject querySpec = Json.createObjectBuilder()
                .add("offset", 0)
                .add("limit", 10)
                .add("sortOrder", "ASC")
                .add("filterExpression", Json.createArrayBuilder()
                        .add(Json.createObjectBuilder()
                                .add("operandLeft", "https://w3id.org/edc/v0.0.1/ns/isFdo")
                                .add("operator", "=")
                                .add("operandRight", "true")))
                .build();

        JsonObject requestBody = Json.createObjectBuilder()
                .add("@context", Json.createObjectBuilder()
                        .add("@vocab", "https://w3id.org/edc/v0.0.1/ns/"))
                .add("protocol", "dataspace-protocol-http")
                .add("counterPartyAddress", counterPartyAddress)
                .add("querySpec", querySpec)
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(managementUrl + "/v2/catalog/request"))
                .header("Content-Type", "application/json")
//                .header("Authorization", "Bearer " + authToken)
                .header("X-Api-Key", "ApiKeyDefaultValue")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
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
            System.out.println("Failed to fetch catalog: " + response.body());
            return null;
        }
    }
}
