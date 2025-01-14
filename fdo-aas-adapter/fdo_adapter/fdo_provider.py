import json
from dataclasses import dataclass
from base64 import b64encode
from io import BytesIO
from typing import Iterable, Dict

from basyx.aas.model import DictObjectStore, Identifiable, Identifier, AssetAdministrationShell
from basyx.aas.adapter import json as jsonization

from fdo_manager_service_api_client import AuthenticatedClient
from fdo_manager_service_api_client.api.fd_os import create_fdo
from fdo_manager_service_api_client.models import CreateFDOBody, TargetRepositories
from fdo_manager_service_api_client.types import File

from .descriptors import create_aas_descriptor


@dataclass
class PID:
    prefix: str
    suffix: str


class FdoServiceAasRegistryDictObjectStore(DictObjectStore):
    """
    A special DictObjectStore that is used to generate the FDOs of added AAS.

    This class is used to generate the FDOs of added AAS and store them in a local in-memory object store.
    On add AAS to the store, the FDO of the AAS is generated and sent to the FDO Manager.
    """

    def __init__(self,
                 fdo_manager_url: str,
                 fdo_manager_token: str,
                 fdo_repository: str,
                 objects: Iterable[Identifiable] = ()) -> None:
        self.fdo_manager_url = fdo_manager_url
        self.fdo_manager_token = fdo_manager_token
        self.fdo_repository = fdo_repository
        self.fdo_client = AuthenticatedClient(base_url=self.fdo_manager_url, token=self.fdo_manager_token)

        self._aasid_to_pids: Dict[PID, Identifiable] = {}
        super().__init__(objects=objects)

    def add(self, x: Identifiable) -> None:
        super().add(x)
        if isinstance(x, AssetAdministrationShell):
            pid = self.create_fdo_from_aas(x)
            self._aasid_to_pids[x.id] = pid

    def discard(self, x: Identifiable) -> None:
        super().discard(x)
        if isinstance(x, AssetAdministrationShell):
            pid = self._aasid_to_pids[x.id]
            # delete_fdo.sync_detailed(client=self.fdo_client, pid_prefix=pid.prefix, pid_suffix=pid.suffix)
            # FIXME: delete_fdo is not implemented in the API

    def update_fdos(self) -> None:
        for x in self._backend.values():
            if isinstance(x, AssetAdministrationShell):
                self.update_fdo(x.id)

    def update_fdo(self, aas_id: Identifier) -> None:
        aas = self.get_identifiable(aas_id)
        if isinstance(aas, AssetAdministrationShell):
            createFDOBody = self.create_fdo_body(aas)
            pid = self._aasid_to_pids[aas.id]
            # delete_fdo.sync_detailed(client=self.fdo_client, pid_prefix=pid.prefix, pid_suffix=pid.suffix)
            # update_fdo.sync_detailed(client=self.fdo_client, body=createFDOBody,
            # pid_prefix=pid.prefix, pid_suffix=pid.suffix)
            # FIXME: update_fdo is not implemented in the API

    def create_fdo_from_aas(self, aas: AssetAdministrationShell) -> PID:
        createFDOBody = self.create_fdo_body(aas)

        response = create_fdo.sync_detailed(client=self.fdo_client, body=createFDOBody)
        pid = self.get_pid_from_create_fdo_response(response)
        return pid

    def create_fdo_body(self, aas: AssetAdministrationShell) -> CreateFDOBody:
        return CreateFDOBody(
            repositories=TargetRepositories(fdo=self.fdo_repository),
            data=self.create_data_for_aas_fdo_body(aas),
            metadata=self.create_metadata_for_aas_fdo_body(aas))

    def create_data_for_aas_fdo_body(self, aas: AssetAdministrationShell) -> File:
        """Use JSON representation of the AAS as data for the FDO body."""
        data = json.dumps(aas, cls=jsonization.json_serialization.AASToJsonEncoder).encode('utf-8')
        data = BytesIO(data)
        data.seek(0)
        return File(file_name="data", payload=data, mime_type="application/json")

    def create_metadata_for_aas_fdo_body(self, aas: AssetAdministrationShell) -> File:
        """Use JSON representation of the AAS descriptor as metadata for the FDO body.
        See: https://admin-shell-io.github.io/aas-specs-antora/IDTA-01002/v3.1/specification/interfaces-payload.html#_assetadministrationshelldescriptor
        """
        aas_descriptor = create_aas_descriptor(aas, self)
        metadata = BytesIO(json.dumps(aas_descriptor).encode('utf-8'))
        metadata.seek(0)
        return File(file_name="metadata", payload=metadata, mime_type="application/json")

    def get_pid_from_create_fdo_response(self, response) -> PID:
        pid = response.headers.get("Location").removeprefix(self.fdo_manager_url).strip("/").removeprefix("fdo/")
        pid_prefix, pid_suffix = pid.split("/")
        return PID(prefix=pid_prefix, suffix=pid_suffix)
