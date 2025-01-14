package com.indiscale.fdo.manager.api;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class RepositoryTypeTest {

  @Test
  void testToString() {
    RepositoryType type = new RepositoryType("testId");
    assertEquals(type.toString(), "RepositoryType:testId");
  }

  @Test
  void testDescription() {
    RepositoryType type = new RepositoryType("testId");
    assertNull(type.description);
    type.description("desc");
    assertEquals("desc", type.description);
  }

  @Test
  void testEquals() {
    RepositoryType r1_1 = new RepositoryType("testId1");
    RepositoryType r1_2 = new RepositoryType("testId1");
    assertEquals(r1_1, r1_2);

    RepositoryType r2 = new RepositoryType("testId2");
    assertNotEquals(r1_1, r2);
  }

  @Test
  void testNotNullable() {
    assertThrows(NullPointerException.class, () -> new RepositoryType(null));
  }
}
