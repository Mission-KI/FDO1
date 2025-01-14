# About this repository

This is a proof-of-concept for the FDO-EDC adapter. The adapter requests the
catalog from an EDC connector and creates an FDO for every asset (also called
datasets) in the catalog that is marked appropriately. 

This adapter was created as part of the FDO One project. Please visit XY
for more information on the project.

## Marking datasets for publication
The connector catalog is queried with a filter that restricts the result to
assets which have the special property.

```
https://w3id.org/edc/v0.0.1/ns/isFdo=true
```
This means, that assets need to have an addtional property of the EDC namespace
which is called "isFdo" and that needs to be true in order for the asset to 
show up in the result.

## FDO publication
The public FDO data will include the asset description that is provided by the
catalog and separately the metadata for the asset as it is provided under
another special key, which can be configured (see `ASSET_METADATA_KEY` in the
configuration).

The FDO will also contain the connector endpoint URL (which also needs to
configured).

## Setup of the FDO-EDC Adapter ("App")
This adapter requires the two infrastructure parts that it connects:
1. a running EDC connector
2. credentials that allows to create FDOs as defined in the FDO One project

**Note**, that appropriate assets (isFDO=True) need to exist and must be made 
available via a contract definition in the
connector. Otherwise, the FDO-EDC-adapter will not do anything (see
[Issue #1](https://gitlab.indiscale.com/caosdb/customers/gwdg/fdoasset/-/issues/1)).

For demonstration and testing purposes a minimal provider connector service is
included in this repository as well (see below "Minimal Asset Provider Service").

* Before starting the `.env.example` file should be adjusted and copied to `.env`:

```bash
   cp app/src/main/resources/.env.example app/src/main/resources/.env
```

### Configure the FDO Repository where the FDOs will be created.

* Store a valid repository config json to `app/.test.linkahead.json` [Example](https://gitlab.indiscale.com/fdo/fdo-manager-library/-/blob/main/.test.linkahead.json.example)
* Depending on how your EDC connector is deployed you will need to provide the
  api key (`EDC_UI_MANAGEMENT_API_KEY` in `docker-compose.yml`) or a token that
  you created (e.g. with the `api_authent_curl.sh` script provided by the MDS).

### Start the App

* We skip tests because they don't seem to be passing right now. TODO

```bash
./gradlew run -x test
```


## Minimal Asset Provider Service

- Allows to create example assets which then can be fetched by the "App" and published as FDO.

### 1. Build the connector

```bash
./gradlew connector:build
```

### 2. Run the connector

```bash
java -Dedc.keystore=connector/resources/certs/cert.pfx \
     -Dedc.keystore.password=123456 \
     -Dedc.vault=connector/resources/configuration/provider-vault.properties \
     -Dedc.fs.config=connector/resources/configuration/provider-configuration.properties \
     -jar connector/build/libs/connector.jar
```

### 3. Create an asset with id `myAssetId`

```bash
curl -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/"
    },
    "@id": "myAssetId",
    "@type": "https://w3id.org/edc/v0.0.1/ns/Asset",
    "properties": {
        "name": "Product EDC Demo Asset",
        "contenttype": "application/json",
        "description": "Product Description about Test Asset",
        "isFdo": "true",
        "asset_metadata": {
            "example_key": "example_value"
        }
    },
    "dataAddress": {
        "@type": "https://w3id.org/edc/v0.0.1/ns/DataAddress",
        "type": "HttpData",
        "baseUrl": "https://jsonplaceholder.typicode.com/todos",
        "proxyPath": "true",
        "proxyQueryParams": "true"
    }
}' \
  -H 'content-type: application/json' http://localhost:19193/management/v3/assets \
  -s
```

TODO make sure we have the correct metadata key

### 4. Create a unrestricted policy

```bash
curl -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/",
        "odrl": "http://www.w3.org/ns/odrl/2/"
    },
    "@id": "PolicyForTestAsset",
    "@type": "https://w3id.org/edc/v0.0.1/ns/PolicyDefinition",
    "policy": {
        "@type": "http://www.w3.org/ns/odrl/2/Set",
        "permission": [],
        "prohibition": [],
        "obligation": []
    }
}' \
  -H 'content-type: application/json' http://localhost:19193/management/v2/policydefinitions \
  -s
```

### 5. Create a contract definition for asset with id `myAssetId`

```bash
curl -d '{
  "@context": {
    "@vocab": "https://w3id.org/edc/v0.0.1/ns/"
  },
  "@id": "ContractDefinitionForTestAsset",
  "@type": "https://w3id.org/edc/v0.0.1/ns/ContractDefinition",
  "accessPolicyId": "PolicyForTestAsset",
  "contractPolicyId": "PolicyForTestAsset",
      "assetsSelector": {
        "@type": "https://w3id.org/edc/v0.0.1/ns/CriterionDto",
        "operandLeft": "https://w3id.org/edc/v0.0.1/ns/id",
        "operator": "=",
        "operandRight": "myAssetId"
    }
}' \
  -H 'content-type: application/json' http://localhost:19193/management/v2/contractdefinitions \
  -s
```

### 6. Fetch catalog

For manual testing.

```bash
curl -d '{
    "@context": {
        "@vocab": "https://w3id.org/edc/v0.0.1/ns/"
    },
    "@type": "https://w3id.org/edc/v0.0.1/ns/CatalogRequest",
    "counterPartyAddress": "http://localhost:19194/protocol",
    "protocol": "dataspace-protocol-http",
    "querySpec": {
        "offset": 0,
        "limit": 5
    }
}' \
  -H 'content-type: application/json' http://localhost:19193/management/v2/catalog/request \
  -s
```

