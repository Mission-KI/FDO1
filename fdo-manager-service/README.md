# FDO Manager Service

**This is WIP - don't use it unless you want to break things.**

Reference implementation of a RESTful Service API for basic FDO operations.
This service exposes the functionality of the
[FDO Manager SDK](https://gitlab.com/fairdo/fdo-manager/sdk).


## Build JAR

```
mvn clean package
```

This results in `application/target/fdo-manager-service.application-${version}.jar`

## Run

Either build the application and start the JAR with

```
java -jar application/target/fdo-manager-service.application-${version}.jar
```

or start it directly from maven with

```
mvn spring-boot:run
```

### Use Mockup Repository

Build the JAR file, then run

```
java -Dmock=true -jar application/target/fdo-manager-service.application-${version}.jar
```

### Request

By default you can access the service at `http://localhost:8081/api/v1`. Try

```
curl http://localhost:8081/api/v1/hello
```

### API Specs

You can view the API specs at `http://localhost:8081/api/v1/swagger-ui/index.html`.

### Stop

Stop the running service with `CTRL-C`.

## Troubleshooting

### API Generation on Windows

When running `mvn package` under Microsoft Windows the code generation fails with
```
[ERROR] Error resolving schema #/components/schemas/OperationsLogRecord
java.net.URISyntaxException: Illegal character in opaque part at index 2: C:\Users\Indiscale\Documents\fdo-manager-service-f-windows-api-generation\api/src/main/resourc     es/api.yaml
    at java.net.URI$Parser.fail (URI.java:2995)
    at java.net.URI$Parser.checkChars (URI.java:3166)
    at java.net.URI$Parser.parse (URI.java:3202)
    at java.net.URI.<init> (URI.java:645)
...
```

There seems to be a problem with the maven plugin or the parser. This is a
known issue, see https://github.com/OpenAPITools/openapi-generator/issues/18161

**Workaround**: change the `api/pom.xml`:

```
             </goals>
             <id>buildApi</id>
             <configuration>
-              <inputSpec>${basedir}/src/main/resources/api.yaml</inputSpec>
+              <inputSpec>api/src/main/resources/api.yaml</inputSpec>
               <generatorName>spring</generatorName>
```


### Exception on startup

When running the mockup repository as described above, the following exception is shown:
```
java.io.IOException: ERROR: cannot read repository config directory: repositories
        at com.indiscale.fdo.manager.service.ManagerPool.getConfig(ManagerPool.java:58)
        at com.indiscale.fdo.manager.service.ManagerPool.getRepositoryRegistry(ManagerPool.java:68)
        at com.indiscale.fdo.manager.service.ManagerPool.createManager(ManagerPool.java:79)
        at com.indiscale.fdo.manager.service.ManagerPool$2.create(ManagerPool.java:155)
        at com.indiscale.fdo.manager.service.ManagerPool$ManagerAllocator.allocate(ManagerPool.java:124)
        at com.indiscale.fdo.manager.service.ManagerPool$ManagerAllocator.allocate(ManagerPool.java:114)
        at stormpot.ReallocatingAdaptor.allocate(ReallocatingAdaptor.java:37)
        at stormpot.BAllocThread.alloc(BAllocThread.java:255)
        at stormpot.BAllocThread.increaseSizeByAllocating(BAllocThread.java:152)
        at stormpot.BAllocThread.replenishPool(BAllocThread.java:113)
        at stormpot.BAllocThread.continuouslyReplenishPool(BAllocThread.java:97)
        at stormpot.BAllocThread.run(BAllocThread.java:89)
        at java.base/java.lang.Thread.run(Thread.java:1570)

```

This configuration is not needed for the mockup repository and can be ignored.


# Contact

* (Lead) Timm Fitschen <t.fitschen@indiscale.com>

# License

AGPL 3.0 or later. <https://www.gnu.org/licenses/agpl-3.0.en.html>

# Copyright

* Copyright (C) 2024 Timm Fitschen <t.fitschen@indiscale.com>
* Copyright (C) 2024 IndiScale GmbH <info@indiscale.com>
