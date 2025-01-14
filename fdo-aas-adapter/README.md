# AAS-FDO-Adapter
This is a simple adapter that allows you to automatically generate FDOs from AASs.
This is based on the [basyx-python-SDK](https://github.com/rwth-iat/basyx-python-sdk) and the generated client for [FDO-Manager-Service](https://gitlab.indiscale.com/fdo/fdo-manager-service/-/tree/main?ref_type=heads)

The FDO-Manager-Service is a web service that exposes and OpenAPI-REST API
which allows to create FDOs in the infrastructure of the FDO One Project.

## Installation
1. To install the adapter, we should first generate the client for the FDO-Manager-Service. The instructions to generate the client can be found [here](https://gitlab.indiscale.com/fdo/fdo-manager-clients/-/tree/main/example-client?ref_type=heads).
1. After generating the client, add the generated client module to your python environment:
    ```bash
    pip install <path-to-generated-client>
    ```
1. Install the adapter:
    ```bash
    pip install git+https://github.com/rwth-iat/aas-fdo-adapter.git
    ```

## Usage
For usage examples, please refer to the [example.py](example.py) file.

This adapter will call the FDO-Manager-Service API for each AAS that is
inserted into the AAS server. Thus we need to be able to connect to the
service. In the `example.py` you can see how you can provide you credentials
(If you do not have any, see "Testing" below).

An FDO-Manager-Service provides the capability to create FDOs using a set of
metadata repositories. You need to define which repository you want to use (see
`example.py`).

You can test that the server is correctly running by having a look at
http://localhost:8080/api/v3.0/shells

## Testing
If you want to test this adapter, you can do so with a locally running
FDO-Manager-Service. See [the
documentation](https://gitlab.indiscale.com/fdo/fdo-manager-service/-/tree/main?ref_type=heads)
for how to start a service with a Mock Repository or for a more comprehensive
test check out the [FDO
Testbed](https://gitlab.indiscale.com/fdo/fdo-local-testbed).

1. Start the your local FDO-Manager-Service.
2. Make sure the connection information (`fdo_manager_url`, `fdo_repository`)
   is correct. The examples given should be suitable. If you run the service
   with mock repositories, the "mock-repo-1" should exist. You do not need a
   token when you use the locally running service and you can keep any string
   in `example.py`. (If you use the testbed, look at
   `http://localhost:8081/api/v1/repositories` to see what repository ids you
   can use.)
3. Run `python example.py` to start the server. You should see in the logs of
   your service, that an FDO was created in the repository (see
   `http://localhost:8081/api/v1/logging` in the testbed).
4. You can inspect the created object with `curl`, e.g.
   `curl http://localhost:8081/api/v1/fdo/<fdo pid>`
   You can find the FDO PID in the logs of the service.
   For more information see the service documentaion.
   (If you run the testbed, you can also look into the repositories and into
   the handle record that was created)

## How it works
In this adapter we implemented a special `DictObjectStore` with integrated FDO Service - `FdoServiceAasRegistryDictObjectStore`.

- The `DictObjectStore` is a simple in-memory object store that allows you to store and retrieve AAS objects by their id. The `DictObjectStore` can be used by the AAS Server to store the AAS Objects.
- The FDO Service is a service that allows you to create, update, and delete FDOs. 

We implemented `FdoServiceAasRegistryDictObjectStore`, which is a subclass of `DictObjectStore` that automatically creates, updates, or deletes FDOs based on the changes made in the AAS objects.

For example if an AAS Object is added to the `FdoServiceAasRegistryDictObjectStore`, the adapter will automatically create an FDO for this AAS Object. If the AAS Object is deleted, the adapter will delete the corresponding FDO. The Object Store has also a function to update the FDOs based on the changes made in the AAS Objects.


## Building the docker image

1. create the client code for the FDO service in a folder called
   `fdo-manager-service-api-client`
   `openapi-python-client generate --url https://gitlab.indiscale.com/fdo/fdo-manager-service/-/raw/main/api/src/main/resources/api.yaml?ref_type=heads`
2. set `fdo_manager_url="http://fdo-manager-service:8081/api/v1"` in example.py
2. set `fdo_repository="Cordra"` in example.py
2. change the hostname `    run_simple(hostname="0.0.0.0", ...`
2. run `docker build -f .docker/Dockerfile -t aas-adapter .`
