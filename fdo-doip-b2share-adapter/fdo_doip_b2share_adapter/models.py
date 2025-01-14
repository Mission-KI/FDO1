from typing import Any, Optional

from pydantic import BaseModel, Field, ConfigDict


class DigitalObject(BaseModel):
    model_config = ConfigDict(extra='forbid')

    id: str = Field(
        ..., description='id: identifier of the element; must be unique within a DO.'
    )
    length: Optional[str] = Field(None, description='length of the data portion.')
    type: str = Field(
        ...,
        description='requestId: the identifier of the request provided by the client; shall be unique within a given DOIP session so clients can distinguish between DOIP service responses. The requestId shall be a string not exceeding 4096 bits.',
    )
    attributes: Optional[dict[str, Any]] = Field(
        None,
        description='one or more fields serialized as an object using the default serialization, or as a JSON (sub) object.',
    )


class Model(BaseModel):
    model_config = ConfigDict(extra='forbid')

    id: str = Field(..., description='id: the identifier of the DO.')
    type: str = Field(
        ...,
        description='type: the DO type. Must be 0.TYPE/DO or its extension. See Types section.',
    )
    attributes: Optional[dict[str, Any]] = Field(
        None,
        description='attributes: one or more fields (key-value pairs) serialized as a JSON (sub) object.',
    )
    elements: Optional[DigitalObject] = Field(
        None,
        description='description: one or more elements serialized as an array in the default serialization, with each element consisting of',
    )
    signatures: Optional[str] = Field(
        None,
        description='Required for DOs of type 0.TYPE/DOIPServiceInfo and 0.TYPE/DOIPOperation; otherwise optional. The field is an array of strings in the default serialization; each string is in JWS format19 with an unencoded detached payload.',
    )
