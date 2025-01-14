package fdoassetfetcher.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

import com.fasterxml.jackson.annotation.JsonAlias;
import java.util.Optional;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Asset(
        @JsonProperty("@id") String id,
        @JsonProperty("@type") String type,
        @JsonAlias({"edc:properties", "properties"}) Properties properties,
        @JsonAlias({"edc:dataAddress", "dataAddress"}) DataAddress dataAddress,
        @JsonProperty("@context") Context context) {
    public Asset withProperties(Properties properties) {
        return new Asset(this.id, this.type, properties, this.dataAddress, this.context);
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Properties(
            @JsonAlias({"edc:id", "id"}) String id,
            @JsonAlias({"edc:name", "name"}) String name,
            @JsonAlias({"edc:description", "description"}) String description,
            @JsonAlias({"edc:contenttype", "contenttype"}) String contentType,
            @JsonAlias({"edc:isFdo", "isFdo"}) String isFdo,
            @JsonInclude(JsonInclude.Include.NON_ABSENT)
            @JsonAlias({"edc:fdoPid", "fdoPid"})
            Optional<String> fdoPid) {
        public Properties withFdoPid(Optional<String> fdoPid) {
            return new Properties(this.id, this.name, this.description, this.contentType, this.isFdo, fdoPid);
        }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record DataAddress(
            @JsonProperty("@type") String atType,
            @JsonAlias({"edc:type", "type"}) String dataType,
            @JsonAlias({"edc:baseUrl", "baseUrl"}) String baseUrl,
            @JsonAlias({"edc:proxyPath", "proxyPath"}) String proxyPath,
            @JsonAlias({"edc:proxyQueryParams", "proxyQueryParams"}) String proxyQueryParams
    ) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Context(
            @JsonProperty("@vocab") String vocab,
            @JsonProperty("edc") String edc,
            @JsonProperty("dcat") String dcat,
            @JsonProperty("dct") String dct,
            @JsonProperty("odrl") String odrl,
            @JsonProperty("dspace") String dspace) {
    }
}
