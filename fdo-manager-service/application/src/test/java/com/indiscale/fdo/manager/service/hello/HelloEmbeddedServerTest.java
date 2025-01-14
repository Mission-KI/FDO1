package com.indiscale.fdo.manager.service.hello;

import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;

/** Test the HelloImpl class. */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HelloEmbeddedServerTest {

  @Autowired private HelloImpl hello;

  @LocalServerPort private int port;

  @Autowired private TestRestTemplate restTemplate;

  @Value("${server.servlet.context-path}")
  private String contextPath;

  @Test
  void index() {
    Assertions.assertThat(hello).isNotNull();
  }

  @Test
  void indexResultTest() {
    Assertions.assertThat(
            restTemplate.getForObject(
                "http://localhost:" + port + contextPath + "/hello", String.class))
        .contains("Hello");
  }
}
