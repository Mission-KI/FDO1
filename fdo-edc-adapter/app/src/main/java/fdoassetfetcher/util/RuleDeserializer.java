package fdoassetfetcher.util;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import com.fasterxml.jackson.databind.node.ArrayNode;
import fdoassetfetcher.model.Dataset;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class RuleDeserializer extends StdDeserializer<List<Dataset.Policy.Rule>> {

    public RuleDeserializer() {
        this(null);
    }

    public RuleDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public List<Dataset.Policy.Rule> deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        List<Dataset.Policy.Rule> rules = new ArrayList<>();

        if (node.isArray()) {
            for (JsonNode item : node) {
                Dataset.Policy.Rule rule = jp.getCodec().treeToValue(item, Dataset.Policy.Rule.class);
                rules.add(rule);
            }
        } else {
            Dataset.Policy.Rule rule = jp.getCodec().treeToValue(node, Dataset.Policy.Rule.class);
            rules.add(rule);
        }

        return rules;
    }
}