# Example Client

You can create a python client from the OpenAPI specification using for example
the python module openapi-python-client (`pip install openapi-python-client`).

Generate the client code (in this folder) with 
`openapi-python-client generate --url https://gitlab.indiscale.com/fdo/fdo-manager-service/-/raw/main/api/src/main/resources/api.yaml?ref_type=heads`
Add the module to your python environment: `pip install ./fdo-manager-service-api-client`.

Please have a look at `test-client.py`.

# Using the mockup service

Please see `README.md` in the fdo manager service repository:

https://gitlab.indiscale.com/fdo/fdo-manager-service/-/blob/main/README.md?ref_type=heads


Please use the mockup repository in order to test the client, see the following section:

https://gitlab.indiscale.com/fdo/fdo-manager-service/-/blob/main/README.md?ref_type=heads#use-mockup-repository
