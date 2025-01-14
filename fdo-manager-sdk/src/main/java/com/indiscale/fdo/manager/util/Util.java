package com.indiscale.fdo.manager.util;

import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.stream.JsonReader;
import com.indiscale.fdo.manager.DefaultRepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryConfig;
import com.indiscale.fdo.manager.api.RepositoryType;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class Util {

  public static PublicKey readPublicKeyFromPem(String path)
      throws NoSuchAlgorithmException, InvalidKeySpecException, IOException {
    File file = new File(path);
    return readPublicKeyFromPem(file);
  }

  public static PublicKey ascToPublicKey(String key)
      throws NoSuchAlgorithmException, InvalidKeySpecException {
    key =
        key.replaceAll(System.lineSeparator(), "")
            .replaceAll(".*-----BEGIN PUBLIC KEY-----", "")
            .replaceAll("-----END PUBLIC KEY-----.*", "");

    byte[] decoded = Base64.getDecoder().decode(key);

    KeyFactory keyFactory = KeyFactory.getInstance("RSA");
    KeySpec keySpec = new X509EncodedKeySpec(decoded);
    return keyFactory.generatePublic(keySpec);
  }

  public static PublicKey readPublicKeyFromPem(File file)
      throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
    String key = new String(Files.readAllBytes(file.toPath()), Charset.defaultCharset());
    return ascToPublicKey(key);
  }

  public static RepositoryConfig jsonToRepositoryConfig(File json) throws FileNotFoundException {
    return jsonToRepositoryConfig(new FileReader(json));
  }

  public static RepositoryConfig jsonToRepositoryConfig(String json) {
    return jsonToRepositoryConfig(new StringReader(json));
  }

  public static RepositoryConfig jsonToRepositoryConfig(Reader reader) {
    GsonBuilder builder = new GsonBuilder();
    builder.registerTypeAdapter(
        RepositoryType.class,
        new JsonDeserializer<RepositoryType>() {

          @Override
          public RepositoryType deserialize(
              JsonElement json, Type typeOfT, JsonDeserializationContext context)
              throws JsonParseException {
            String id = json.getAsString();
            return new RepositoryType(id);
          }
        });
    JsonReader json = new JsonReader(reader);
    DefaultRepositoryConfig result = builder.create().fromJson(json, DefaultRepositoryConfig.class);
    if (result == null) {
      throw new IllegalArgumentException("json does not describe a repository config");
    }
    if (result.getType() == null) {
      throw new IllegalArgumentException("type is null or undefined.");
    }
    if (result.getId() == null) {
      throw new IllegalArgumentException("id is null or undefined.");
    }
    return result;
  }

  // http://typeregistry.lab.pidconsortium.net/#objects/21.T11969/141bf451b18a79d0fe66
  public static final String FDO_KIP = "21.T11969/141bf451b18a79d0fe66";
}
