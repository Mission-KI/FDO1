package fdoassetfetcher.util;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;
import fdoassetfetcher.model.Dataset;

import java.io.IOException;

public class TargetDeserializer extends StdDeserializer<Dataset.Policy.Target> {

    public TargetDeserializer() {
        this(null);
    }

    public TargetDeserializer(Class<?> vc) {
        super(vc);
    }

    @Override
    public Dataset.Policy.Target deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);

        if (node.isTextual()) {
            return new Dataset.Policy.Target(node.asText(), null);
        } else {
            String id = node.has("@id") ? node.get("@id").asText() : null;
            String type = node.has("@type") ? node.get("@type").asText() : null;
            return new Dataset.Policy.Target(id, type);
        }
    }
}
