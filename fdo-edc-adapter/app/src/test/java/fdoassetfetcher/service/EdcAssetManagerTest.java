package fdoassetfetcher.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.eq;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.verify;

import com.fasterxml.jackson.databind.ObjectMapper;
import fdoassetfetcher.model.Asset;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Optional;

class EdcAssetManagerTest {

    private EdcAssetManager assetManager;
    private HttpClient httpClient;
    private String managementUrl;

    @BeforeEach
    void setUp() {
        httpClient = mock(HttpClient.class);
        ObjectMapper objectMapper = new ObjectMapper();
        managementUrl = "http://localhost:8080";
        String authToken = "dummyToken";

        assetManager = new EdcAssetManager(httpClient, objectMapper, managementUrl, authToken);
    }

    @Test
    void testFetchAsset_success() throws IOException, InterruptedException {
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/asset_1.json");
        String assetJson = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        // Mock HttpResponse
        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);
        when(httpResponse.body()).thenReturn(assetJson);

        // Mock HttpClient send method
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponse);

        // Call the method to be tested
        Asset asset = assetManager.fetchAsset("myAssetId");

        // Verify the returned Asset object
        assertNotNull(asset);
        assertEquals("myAssetId", asset.id());
        assertEquals("Asset", asset.type());
        assertEquals("myAssetId", asset.properties().id());
        assertEquals("Test Asset", asset.properties().name());
        assertEquals("This is a test asset", asset.properties().description());
        assertEquals("application/json", asset.properties().contentType());
        assertEquals("true", asset.properties().isFdo());
        assertEquals("pid:1234/5678", asset.properties().fdoPid().orElse(null));

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals(URI.create(managementUrl + "/v3/assets/myAssetId"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("GET", capturedRequest.method());
    }

    @Test
    void testCreateAsset_success() throws IOException, InterruptedException {
        // Create a sample Asset object
        Asset.Properties properties = new Asset.Properties(
                "myAssetId",
                "Test Asset",
                "This is a test asset",
                "application/json",
                "true",
                Optional.of("pid:1234/5678")
        );
        Asset.DataAddress dataAddress = new Asset.DataAddress(
                "DataAddress",
                "/data",
                "param1=value1",
                "HttpData",
                "http://example.com/data"
        );
        Asset.Context context = new Asset.Context(
                "https://example.com/vocab#",
                "https://w3id.org/edc/v0.0.1/ns/",
                null,
                null,
                null,
                null
        );
        Asset asset = new Asset(
                "myAssetId",
                "Asset",
                properties,
                dataAddress,
                context
        );

        // Mock HttpResponse
        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);

        // Mock HttpClient send method
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponse);

        // Call the method to be tested
        boolean result = assetManager.createAsset(asset);

        // Verify the result
        assertTrue(result);

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals(URI.create(managementUrl + "/v3/assets"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("application/json", capturedRequest.headers().firstValue("Content-Type").orElse(""));
        assertEquals("POST", capturedRequest.method());
    }

    @Test
    void testUpdateAsset_success() throws IOException, InterruptedException {
        // Create a sample Asset object
        Asset.Properties properties = new Asset.Properties(
                "myAssetId",
                "Test Asset Updated",
                "This is an updated test asset",
                "application/json",
                "true",
                Optional.of("pid:1234/5678")
        );
        Asset.DataAddress dataAddress = new Asset.DataAddress(
                "DataAddress",
                "/data",
                "param1=value1",
                "HttpData",
                "http://example.com/data"
        );
        Asset.Context context = new Asset.Context(
                "https://example.com/vocab#",
                "https://w3id.org/edc/v0.0.1/ns/",
                null,
                null,
                null,
                null
        );
        Asset asset = new Asset(
                "myAssetId",
                "Asset",
                properties,
                dataAddress,
                context
        );

        // Mock HttpResponse
        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(204);

        // Mock HttpClient send method
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponse);

        // Call the method to be tested
        boolean result = assetManager.updateAsset(asset);

        // Verify the result
        assertTrue(result);

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals(URI.create(managementUrl + "/v3/assets"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("application/json", capturedRequest.headers().firstValue("Content-Type").orElse(""));
        assertEquals("PUT", capturedRequest.method());
    }

    @Test
    void testDeleteAsset_success() throws IOException, InterruptedException {
        // Mock HttpResponse
        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(204);

        // Mock HttpClient send method
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponse);

        // Call the method to be tested
        boolean result = assetManager.deleteAsset("myAssetId");

        // Verify the result
        assertTrue(result);

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals(URI.create(managementUrl + "/v3/assets/myAssetId"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("DELETE", capturedRequest.method());
    }

    @Test
    void testUpdateAssetWithFdoPid_success() throws IOException, InterruptedException {
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/asset_2.json");
        String assetJson = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        // Mock HttpResponse for fetchAsset
        HttpResponse<String> httpResponseFetch = mock(HttpResponse.class);
        when(httpResponseFetch.statusCode()).thenReturn(200);
        when(httpResponseFetch.body()).thenReturn(assetJson);

        // Mock HttpClient send method for fetchAsset
        when(httpClient.send(argThat(request -> request.method().equals("GET")), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponseFetch);

        // Call the method to be tested
        String newFdoPid = "pid:1234/9999";
        Asset updatedAsset = assetManager.updateAssetWithFdoPid("myAssetId", newFdoPid);

        // Verify the updated Asset
        assertNotNull(updatedAsset);
        assertEquals("myAssetId", updatedAsset.id());
        assertEquals("Asset", updatedAsset.type());
        assertEquals("myAssetId", updatedAsset.properties().id());
        assertEquals("Test Asset", updatedAsset.properties().name());
        assertEquals("This is a test asset", updatedAsset.properties().description());
        assertEquals("application/json", updatedAsset.properties().contentType());
        assertEquals("true", updatedAsset.properties().isFdo());
        assertEquals(newFdoPid, updatedAsset.properties().fdoPid().orElse(null));

        // Verify that fetchAsset was called with the correct assetId
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));

        HttpRequest capturedRequest = requestCaptor.getValue();
        assertEquals(URI.create(managementUrl + "/v3/assets/myAssetId"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("GET", capturedRequest.method());
    }

    @Test
    void testFetchAsset_withNamespacedFields() throws IOException, InterruptedException {
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/asset_3.json");
        String assetJson = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        // Mock HttpResponse
        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);
        when(httpResponse.body()).thenReturn(assetJson);

        // Mock HttpClient send method
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString())))
                .thenReturn(httpResponse);

        // Call the method to be tested
        Asset asset = assetManager.fetchAsset("myAssetId2");

        // Verify the returned Asset object
        assertNotNull(asset);
        assertEquals("myAssetId2", asset.id());
        assertEquals("edc:Asset", asset.type());

        // Verify properties
        Asset.Properties properties = asset.properties();
        assertNotNull(properties);
        assertEquals("myAssetId2", properties.id());
        assertEquals("Product EDC Demo Asset", properties.name());
        assertEquals("Product Description about Test Asset", properties.description());
        assertEquals("application/json", properties.contentType());
        assertEquals("true", properties.isFdo());
        assertTrue(properties.fdoPid().isEmpty()); // fdoPid is not present in this asset

        // Verify dataAddress
        Asset.DataAddress dataAddress = asset.dataAddress();
        assertNotNull(dataAddress);
        assertEquals("edc:DataAddress", dataAddress.atType());
        assertEquals("HttpData", dataAddress.dataType());
        assertEquals("https://jsonplaceholder.typicode.com/todos", dataAddress.baseUrl());
        assertEquals("true", dataAddress.proxyPath());
        assertEquals("true", dataAddress.proxyQueryParams());

        // Verify context
        Asset.Context context = asset.context();
        assertNotNull(context);
        assertEquals("https://purl.org/dc/terms/", context.dct());
        assertEquals("https://w3id.org/edc/v0.0.1/ns/", context.edc());
        assertEquals("https://www.w3.org/ns/dcat/", context.dcat());
        assertEquals("http://www.w3.org/ns/odrl/2/", context.odrl());
        assertEquals("https://w3id.org/dspace/v0.8/", context.dspace());

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals(URI.create(managementUrl + "/v3/assets/myAssetId2"), capturedRequest.uri());
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals("GET", capturedRequest.method());
    }
}
