package com.indiscale.fdo.manager.service.hello;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

/** Test HelloImpl class (without embedded server). */
@SpringBootTest
@AutoConfigureMockMvc
public class HelloMockMvcTest {

  @Autowired private MockMvc mockMvc;

  @Test
  public void shouldReturnOurText() throws Exception {
    this.mockMvc.perform(get("/hello")).andExpect(content().string(containsString("Hello")));
  }
}
