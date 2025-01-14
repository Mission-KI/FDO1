package com.indiscale.fdo.manager.service.repositories;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.indiscale.fdo.manager.api.Manager;
import com.indiscale.fdo.manager.mock.MockManager;
import com.indiscale.fdo.manager.service.api.model.Repository.TypeEnum;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;

/** Test the {@link RepositoriesImpl} class */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class RepositoriesTest {

  public static class TestRepositoriesImpl extends RepositoriesImpl {
    @Override
    public Manager getManager() {
      return new MockManager();
    }
  }

  private RepositoriesImpl repositories = new TestRepositoriesImpl();

  @LocalServerPort private int port;

  @Autowired private TestRestTemplate restTemplate;

  @Value("${server.servlet.context-path}")
  private String contextPath;

  @Test
  void indexMockManager() {
    Assertions.assertThat(repositories).isNotNull();
    assertEquals(repositories.listRepositories().getBody().getData().size(), 3);
  }

  @Test
  void indexResultTest() {
    Assertions.assertThat(
            restTemplate.getForObject(
                "http://localhost:" + port + contextPath + "/repositories", String.class))
        .contains("data");
  }

  @Test
  void resourceTypeNotNull() {
    assertEquals(
        repositories.listRepositories().getBody().getData().get(0).getType(),
        TypeEnum.REPOSITORIES);
  }
}
