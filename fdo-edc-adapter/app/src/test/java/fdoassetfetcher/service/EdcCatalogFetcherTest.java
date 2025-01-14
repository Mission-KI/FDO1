package fdoassetfetcher.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.verify;

import com.fasterxml.jackson.databind.ObjectMapper;
import fdoassetfetcher.model.Catalog;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

class EdcCatalogFetcherTest {

    private EdcCatalogFetcher catalogFetcher;
    private HttpClient httpClient;
    private String managementUrl;

    @BeforeEach
    void setUp() {
        // Mocking dependencies
        httpClient = mock(HttpClient.class);
        ObjectMapper objectMapper = new ObjectMapper();
        managementUrl = "http://localhost:8080";  // Example URL
        String authToken = "dummyToken";

        // Create the CatalogFetcher instance with mocked dependencies
        catalogFetcher = new EdcCatalogFetcher(httpClient, objectMapper, managementUrl, authToken);
    }

    @Test
    void testFetchCatalog_success() throws IOException, InterruptedException {
        // Load catalog response from file
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/catalog_response_1.json");
        String responseBody = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);
        when(httpResponse.body()).thenReturn(responseBody);

        // Mock the HttpClient send method to return the mock HttpResponse
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString()))).thenReturn(httpResponse);

        // Call the method to be tested
        Catalog catalog = catalogFetcher.fetchCatalog("http://example.com");

        // Verify the returned Catalog object
        assertNotNull(catalog);
        assertEquals("4e567a37-150b-494b-994e-5470435bc700", catalog.id());
        assertEquals("dcat:Catalog", catalog.type());
        assertEquals("Product EDC Demo Asset", catalog.dataset().name());

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals("application/json", capturedRequest.headers().firstValue("Content-Type").orElse(""));
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals(URI.create(managementUrl + "/v2/catalog/request"), capturedRequest.uri());
    }

    @Test
    void testFetchCatalog_withPolicy_success() throws IOException, InterruptedException {
        // Load catalog response from file
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/catalog_response_2.json");
        String responseBody = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);
        when(httpResponse.body()).thenReturn(responseBody);

        // Mock the HttpClient send method to return the mock HttpResponse
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString()))).thenReturn(httpResponse);

        // Call the method to be tested
        Catalog catalog = catalogFetcher.fetchCatalog("http://example.com");

        // Verify the returned Catalog object
        assertNotNull(catalog);
        assertEquals("3de1b60e-a2a6-43d6-ad15-2dc26b951308", catalog.id());
        assertEquals("dcat:Catalog", catalog.type());
        assertEquals("Product EDC Demo Asset", catalog.dataset().name());

        // Verify that the ODRL policy has been correctly parsed
        assertNotNull(catalog.dataset().policy());
        assertEquals("ZGY=:bXlBc3NldElkMg==:NTVkNzEzZmYtOTViOC00MGI0LWI4ZmItZjljY2Q3M2Y4NzI5", catalog.dataset().policy().id());
        assertEquals("odrl:Set", catalog.dataset().policy().type());
        assertEquals("myAssetId2", catalog.dataset().policy().target().id());
        assertNotNull(catalog.dataset().policy().permission());
        assertEquals("USE", catalog.dataset().policy().permission().get(0).action().type());
        assertEquals("ALWAYS_TRUE", catalog.dataset().policy().permission().get(0).constraint().leftOperand());
        assertEquals("odrl:eq", catalog.dataset().policy().permission().get(0).constraint().operator().id());
        assertEquals("true", catalog.dataset().policy().permission().get(0).constraint().rightOperand());

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals("application/json", capturedRequest.headers().firstValue("Content-Type").orElse(""));
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals(URI.create(managementUrl + "/v2/catalog/request"), capturedRequest.uri());
    }

    @Test
    void testFetchCatalog_withEmptyPolicy_success() throws IOException, InterruptedException {
        // Load catalog response from file
        ObjectMapper jsonMapper = new ObjectMapper();
        File jsonFile = new File("src/test/resources/catalog_response_3.json");
        String responseBody = jsonMapper.writeValueAsString(jsonMapper.readTree(jsonFile));

        HttpResponse<String> httpResponse = mock(HttpResponse.class);
        when(httpResponse.statusCode()).thenReturn(200);
        when(httpResponse.body()).thenReturn(responseBody);

        // Mock the HttpClient send method to return the mock HttpResponse
        when(httpClient.send(any(HttpRequest.class), eq(HttpResponse.BodyHandlers.ofString()))).thenReturn(httpResponse);

        // Call the method to be tested
        Catalog catalog = catalogFetcher.fetchCatalog("http://example.com");

        // Verify the returned Catalog object
        assertNotNull(catalog);
        assertEquals("2e2a0d70-b9f6-410b-b0a3-e7019a3165fe", catalog.id());
        assertEquals("dcat:Catalog", catalog.type());
        assertEquals("Product EDC Demo Asset", catalog.dataset().name());
        assertEquals("Product Description about Test Asset", catalog.dataset().description());
        assertEquals("true", catalog.dataset().isFdo());
        assertEquals("application/json", catalog.dataset().contentType());

        // Verify the policy has been correctly parsed with empty permissions, prohibitions, and obligations
        assertNotNull(catalog.dataset().policy());
        assertEquals("Q29udHJhY3REZWZpbml0b25Gb3JUZXN0QXNzZXQ=:bXlBc3NldElk:NDg0NDEwMGYtMjdiMy00ZGRiLWEzYTMtNmEwZTRkNjNjYzdi", catalog.dataset().policy().id());
        assertEquals("odrl:Set", catalog.dataset().policy().type());
        assertEquals("myAssetId", catalog.dataset().policy().target().id());
        assertTrue(catalog.dataset().policy().permission().isEmpty());
        assertTrue(catalog.dataset().policy().prohibition().isEmpty());
        assertTrue(catalog.dataset().policy().obligation().isEmpty());

        // Verify that the HTTP request was built correctly
        ArgumentCaptor<HttpRequest> requestCaptor = ArgumentCaptor.forClass(HttpRequest.class);
        verify(httpClient).send(requestCaptor.capture(), eq(HttpResponse.BodyHandlers.ofString()));
        HttpRequest capturedRequest = requestCaptor.getValue();

        assertEquals("application/json", capturedRequest.headers().firstValue("Content-Type").orElse(""));
        assertEquals("Bearer dummyToken", capturedRequest.headers().firstValue("Authorization").orElse(""));
        assertEquals(URI.create(managementUrl + "/v2/catalog/request"), capturedRequest.uri());
    }
}
