package fdoassetfetcher.model;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import fdoassetfetcher.util.RuleDeserializer;
import fdoassetfetcher.util.TargetDeserializer;

import java.util.List;
import java.util.Optional;

@JsonIgnoreProperties(ignoreUnknown = true)
public record Dataset(
        @JsonProperty("@id") String id,
        @JsonProperty("@type") String type,
        @JsonProperty("odrl:hasPolicy") Policy policy,
        @JsonProperty("dcat:distribution") List<Distribution> distribution,
        @JsonAlias({"edc:id", "id"}) String assetId,
        @JsonAlias({"edc:name", "name"}) String name,
        @JsonAlias({"edc:description", "description"}) String description,
        @JsonAlias({"edc:contenttype", "contenttype"}) String contentType,
        @JsonAlias({"edc:isFdo", "isFdo"}) String isFdo,
        @JsonInclude(JsonInclude.Include.NON_ABSENT)
        @JsonAlias({"edc:fdoPid", "fdoPid"}) Optional<String> fdoPid) {

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Policy(
            @JsonProperty("@id") String id,
            @JsonProperty("@type") String type,
            @JsonDeserialize(using = RuleDeserializer.class)
            @JsonProperty("odrl:permission") List<Rule> permission,
            @JsonDeserialize(using = RuleDeserializer.class)
            @JsonProperty("odrl:prohibition") List<Rule> prohibition,
            @JsonDeserialize(using = RuleDeserializer.class)
            @JsonProperty("odrl:obligation") List<Rule> obligation,
            @JsonDeserialize(using = TargetDeserializer.class)
            @JsonProperty("odrl:target") Target target) {

        @JsonIgnoreProperties(ignoreUnknown = true)
        public record Rule(
                @JsonProperty("odrl:target") String target,
                @JsonProperty("odrl:action") Action action,
                @JsonProperty("odrl:constraint") Constraint constraint) {

            @JsonIgnoreProperties(ignoreUnknown = true)
            public record Action(
                    @JsonProperty("odrl:type") String type) {
            }

            @JsonIgnoreProperties(ignoreUnknown = true)
            public record Constraint(
                    @JsonProperty("odrl:leftOperand") String leftOperand,
                    @JsonProperty("odrl:operator") Operator operator,
                    @JsonProperty("odrl:rightOperand") String rightOperand) {

                @JsonIgnoreProperties(ignoreUnknown = true)
                public record Operator(
                        @JsonProperty("@id") String id) {
                }
            }
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public record Target(
                @JsonProperty("@id") String id,
                @JsonProperty("@type") String type) {
        }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record Distribution(
            @JsonProperty("@type") String type,
            @JsonProperty("dct:format") Format format,
            @JsonProperty("dcat:accessService") AccessService accessService) {

        @JsonIgnoreProperties(ignoreUnknown = true)
        public record Format(
                @JsonProperty("@id") String id) {
        }

        @JsonIgnoreProperties(ignoreUnknown = true)
        public record AccessService(
                @JsonProperty("@id") String id,
                @JsonProperty("@type") String type,
                @JsonProperty("dcat:endpointDescription") String endpointDescription,
                @JsonProperty("dcat:endpointUrl") String endpointUrl,
                @JsonProperty("dct:terms") String terms,
                @JsonProperty("dct:endpointUrl") String dctEndpointUrl) {
        }
    }
}
