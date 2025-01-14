package fdoassetfetcher.model;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Catalog(
        @JsonProperty("@id") String id,
        @JsonProperty("@type") String type,
        @JsonAlias({"dspace:participantId", "edc:participantId", "participantId"}) String participantId,
        @JsonProperty("dcat:dataset") Dataset dataset,
        @JsonProperty("dcat:service") DataService service,
        @JsonProperty("@context") Context context) {

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record DataService(
            @JsonProperty("@id") String id,
            @JsonProperty("@type") String type,
            @JsonProperty("dct:terms") String terms,
            @JsonProperty("dct:endpointUrl") String endpointUrl) {
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