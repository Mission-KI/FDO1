import json

from basyx.aas.model import AssetAdministrationShell, Submodel, DictObjectStore
from basyx.aas.adapter import json as jsonization

DESCRIPTOR_FIELDS = ["description", "displayName", "extension"]
SIMPLE_AAS_DESCRIPTOR_FIELDS = DESCRIPTOR_FIELDS + ["administration", "assetKind", "assetType", "globalAssetId",
                                                    "specificAssetId", "idShort"]
SIMPLE_SUBMODEL_DESCRIPTOR_FIELDS = DESCRIPTOR_FIELDS + ["administration", "idShort", "semanticId",
                                                         "supplementalSemanticId"]


def create_aas_descriptor(aas: AssetAdministrationShell, provider: DictObjectStore):
    datastring = json.dumps(aas, cls=jsonization.json_serialization.AASToJsonEncoder).encode('utf-8')
    aas_dict = json.loads(datastring)

    descriptor = {"id": aas.id}

    for field in SIMPLE_AAS_DESCRIPTOR_FIELDS:
        if field in aas_dict:
            descriptor[field] = aas_dict[field]

    if aas.submodel:
        descriptor["submodelDescriptor"] = []
    for submodel_ref in aas.submodel:
        submodel = submodel_ref.resolve(provider)
        create_submodel_descriptor(submodel)
        descriptor["submodelDescriptor"].append(create_submodel_descriptor(submodel))
    return descriptor


def create_submodel_descriptor(submodel: Submodel):
    datastring = json.dumps(submodel, cls=jsonization.json_serialization.AASToJsonEncoder).encode('utf-8')
    submodel_dict = json.loads(datastring)

    submodel_descriptor = {"id": submodel.id}
    for field in SIMPLE_SUBMODEL_DESCRIPTOR_FIELDS:
        if field in submodel_dict:
            submodel_descriptor[field] = submodel_dict[field]
    return submodel_descriptor
