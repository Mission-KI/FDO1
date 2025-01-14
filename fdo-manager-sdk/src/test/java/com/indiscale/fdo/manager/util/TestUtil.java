package com.indiscale.fdo.manager.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.indiscale.fdo.manager.DefaultRepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryType;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class TestUtil {

  @Test
  public void testJsonToRepoConfig() {
    DefaultRepositoryConfig config =
        new DefaultRepositoryConfig(new RepositoryType("RepoType1"), "testConfig1");
    GsonBuilder builder = new GsonBuilder();
    builder.registerTypeAdapter(
        RepositoryType.class,
        new JsonSerializer<RepositoryType>() {

          @Override
          public JsonElement serialize(
              RepositoryType src, Type typeOfSrc, JsonSerializationContext context) {
            return new JsonPrimitive(src.id);
          }
        });
    Gson gson = builder.create();
    String json = gson.toJson(config);
    assertEquals(json, "{\"type\":\"RepoType1\",\"id\":\"testConfig1\"}");

    RepositoryConfig config2 = Util.jsonToRepositoryConfig(json);
    assertEquals(config, config2);
    assertEquals(json, gson.toJson(config2));

    Map<String, String> attr = new HashMap<>();
    attr.put("key1", "val1");
    attr.put("key2", "val2");
    attr.put("key3", "val3");
    DefaultRepositoryConfig configWithAttr =
        new DefaultRepositoryConfig(new RepositoryType("RepoType2"), "testConfig2", attr);
    String json2 = gson.toJson(configWithAttr);
    assertEquals(
        json2,
        "{\"type\":\"RepoType2\",\"id\":\"testConfig2\",\"attributes\":{\"key1\":\"val1\",\"key2\":\"val2\",\"key3\":\"val3\"}}");
    RepositoryConfig configWithAttr2 = Util.jsonToRepositoryConfig(json2);
    assertEquals(configWithAttr, configWithAttr2);
    assertEquals(json2, gson.toJson(configWithAttr2));

    String withInt = "{\"type\":\"RepoType3\",\"id\":1234}";
    assertEquals(
        gson.toJson(Util.jsonToRepositoryConfig(withInt)), withInt.replace("1234", "\"1234\""));
    assertThrows(IllegalArgumentException.class, () -> Util.jsonToRepositoryConfig(""));
    assertThrows(IllegalArgumentException.class, () -> Util.jsonToRepositoryConfig("{}"));
    assertThrows(
        IllegalArgumentException.class, () -> Util.jsonToRepositoryConfig("{\"bla\":\"blub\"}"));
    assertThrows(
        IllegalArgumentException.class, () -> Util.jsonToRepositoryConfig("{\"type\":\"blub\"}"));
    assertThrows(
        IllegalArgumentException.class, () -> Util.jsonToRepositoryConfig("{\"id\":\"blub\"}"));
  }
}
