from basyx.aas.adapter import aasx
from basyx.aas.adapter.http import WSGIApp
from basyx.aas.examples.data.example_aas import create_example_asset_identification_submodel, \
    create_example_bill_of_material_submodel, create_example_submodel, create_example_concept_description, \
    create_example_asset_administration_shell

from fdo_adapter.fdo_provider import FdoServiceAasRegistryDictObjectStore

from werkzeug.serving import run_simple


def create_example_fdo_obj_store():
    # Create an object store with fdo service to generate FDOs of added AAS
    obj_store: FdoServiceAasRegistryDictObjectStore = FdoServiceAasRegistryDictObjectStore(
        fdo_manager_url="http://localhost:8081/api/v1",
        fdo_manager_token="<enter token>",
        fdo_repository="mock-repo-1"
    )
    # Add example AAS objects to the object store
    obj_store.add(create_example_asset_identification_submodel())
    obj_store.add(create_example_bill_of_material_submodel())
    obj_store.add(create_example_submodel())
    obj_store.add(create_example_concept_description())
    obj_store.add(create_example_asset_administration_shell())
    return obj_store


def run_aas_server():
    # Create an object store with fdo service
    fdo_obj_store = create_example_fdo_obj_store()
    # Run the AAS server with the object store
    run_simple(hostname="localhost",
               port=8080,
               application=WSGIApp(
                   object_store=fdo_obj_store,
                   file_store=aasx.DictSupplementaryFileContainer()),
               use_debugger=True, use_reloader=True)


if __name__ == "__main__":
    run_aas_server()
