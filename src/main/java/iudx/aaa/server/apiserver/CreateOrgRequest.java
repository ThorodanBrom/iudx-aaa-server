package iudx.aaa.server.apiserver;

import io.vertx.codegen.annotations.DataObject;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Data object for create organization API. The validations performed for url are minimal as the
 * Guava library validates the domain sufficiently.
 *
 */
@DataObject(generateConverter = true)
public class CreateOrgRequest {
  String name;
  String url;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public CreateOrgRequest(JsonObject json) {
    CreateOrgRequestConverter.fromJson(json, this);
  }

  public JsonObject toJson() {
    JsonObject obj = new JsonObject();
    CreateOrgRequestConverter.toJson(this, obj);
    return obj;
  }

  /**
   * Creates list of data objects from JsonArray
   * 
   * @param json a JsonArray
   * @return List of CreateOrgRequest objects
   */
  public static List<CreateOrgRequest> jsonArrayToList(JsonArray json) {
    List<CreateOrgRequest> reg = new ArrayList<CreateOrgRequest>();
    json.forEach(obj -> reg.add(new CreateOrgRequest((JsonObject) obj)));
    return reg;
  }
}
