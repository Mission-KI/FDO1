# FDO Manager SDK

**This is WIP - don't use it unless you want to break things.**

Reference implementation for basic FDO operations.

# Use

## Maven

Add this dependency to your `pom.xml`:

```xml
<dependency>
  <groupId>com.indiscale.fdo</groupId>
  <artifactId>fdo-manager-sdk</artifactId>
  <version>${fdo-manager.version}</version>
</dependency>
```

and replace `${fdo-manager.version}` with the desired version.

Also, add this repository:

```xml
<repositories>
  <repository>
    <id>gitlab.indiscale.com</id>
    <url>https://gitlab.indiscale.com/api/v4/projects/229/packages/maven</url>
  </repository>
</repositories>

<distributionManagement>
  <repository>
    <id>gitlab.indiscale.com</id>
    <url>https://gitlab.indiscale.com/api/v4/projects/229/packages/maven</url>
  </repository>

  <snapshotRepository>
    <id>gitlab.indiscale.com</id>
    <url>https://gitlab.indiscale.com/api/v4/projects/229/packages/maven</url>
  </snapshotRepository>
</distributionManagement>
```

## Code

Take the MockManager as an example of the api:

```java
try (Manager manager = new MockManager()) {

  // 1. Specify the FDO profile
  // The MockManager knows one FDO profile and that's mock-profile-1
  FdoProfile profile = manager.getProfileRegistry().getProfile("mock-profile-1");

  // 2. Specify the target repository (where the FDO is gonna be stored)
  // The MockManager knows three (in-memory) repositories: mock-repo-{1,2,3}
  RepositoryConnection repository =
      manager.getRepositoryRegistry().createRepositoryConnection("mock-repo-1");

  // 3. Specify the data and meta data.
  // You need an InputStream to use the Default{Data,Metadata}
  // implementation. You also implement the interfaces yourself, ofc.
  InputStream dataInputStream = new ByteArrayInputStream("this is data".getBytes());
  InputStream mdInputStream = new ByteArrayInputStream("this is metadata".getBytes());

  Data data = new DefaultData(dataInputStream);
  Metadata metadata = new DefaultMetadat(mdInputStream);

  // 4. Create the FDO --- That's it
  FDO fdo = manager.createFDO(profile, repository, data, metadata);

  assertNotNull(fdo.getPID());// new PID
}
```

See more: https://gitlab.com/fairdo/fdo-manager/sdk/-/blob/main/src/test/java/com/indiscale/fdo/manager/mock/MockManagerTest.java

# Test

Run general unit tests via `mvn test`. You can optionally enable a set of
integration test.

## Integration Tests

The test suite includes two sets of integration tests (or maybe you would call
it end-to-end tests) which test the integration with two repositories. One is
supposed to be a Cordra repository the other one is supposed to be a LinkAhead
repository.

Each of these integration tests need a configuration as a json file in order to
run. If there is no such configuration file the tests are just being skipped.
You can also just have one configuration file to run just one of the tests.

An example for both is included in this repository's base directory:
.test.cordra.json.example and .test.linkahead.json.example. The examples use
the FDO test bed repositories but you can also run a local instance of those
repositories.

### Running Test Suite Against Local Testbed

#### Start the local testbed

* `make -C fdo-local-testbed clean start_handle_system start_linkahead start_cordra

#### Configure library

* `cp fdo-local-testbed/fdo-manager/repositories/.test.* .`

#### Run tests

* `mvn test`

### Public Test Bed Repositories

Currently there are two test bed repositories available:

- CORDRA-Test bed: `.test.cordra.json.example`
- LinkAhead-Test bed: `.test.linkahead.json.example`

To use the test bed repositories, just remove the `.example` suffix from the
files and insert credentials for the repositories (not publicly available).
Then run `mvn test` and look into your repository for newly created FDOs.

For the test bed repositories this would be:
* https://linkahead.testbed.pid.gwdg.de/Entity/?query=FIND%20RECORD%20WHICH%20HAVE%20BEEN%20INSERTED%20TODAY&P=0L10
* https://cordra.testbed.pid.gwdg.de/

# Deploy

Upload new maven artifact to the maven repository: `mvn deploy`.

# Contact

* (Lead) Timm Fitschen <t.fitschen@indiscale.com>

# License

LGPL 3.0 or later. <https://www.gnu.org/licenses/lgpl-3.0.en.html>

# Copyright

* Copyright (C) 2024 Timm Fitschen <t.fitschen@indiscale.com>
* Copyright (C) 2024 IndiScale GmbH <info@indiscale.com>
