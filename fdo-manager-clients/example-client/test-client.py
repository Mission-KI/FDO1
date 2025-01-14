from fdo_manager_service_api_client import Client, AuthenticatedClient
import io
from fdo_manager_service_api_client.api.info import hello
from fdo_manager_service_api_client.api.fd_os import create_fdo
from fdo_manager_service_api_client.api.repositories import list_repositories
from fdo_manager_service_api_client.models import (Hello, CreateFDOBody, TargetRepositories,
                                                   Repository)
from fdo_manager_service_api_client.types import (File)

# URL = "http://localhost:8081/api/v1"
URL="https://manager.testbed.pid.gwdg.de/api/v1"

with Client(base_url=URL) as client:
    print(hello.sync(client=client))


with AuthenticatedClient(base_url=URL, token="skldjflskdjf",) as client:
    print(hello.sync(client=client))

    print(list_repositories.sync(client=client))

    with open(__file__, 'rb') as fi:
        with open("README.md", 'rb') as fi2:
            createFDOBody = CreateFDOBody(
                    repositories=TargetRepositories(fdo="mock-repo-1"),
                    data=File(file_name="fi", payload=fi.read()),
                    metadata=File(file_name="fi2", payload=fi2.read()))
                # "repositories": {"fdo": "LinkAhead", "metadata": None, "data": None},
                # "repositories": TargetRepositories({"LinkAhead"}),
                #"data": b"some initial binary data: \x00\x01",
                #"metadata": b"some initial binary data: \x00\x01",
                # "metadata": fi2.read(),
            #})
    a = create_fdo.sync_detailed(client=client, body=createFDOBody)
    print(a)
