# generated by datamodel-codegen:
#   filename:  0.DOIP_Op.Retrieve-Request.json
#   version:   0.26.1

from __future__ import annotations

from typing import Optional, Union

from pydantic import BaseModel, Extra, Field


class Attributes(BaseModel):
    class Config:
        extra = Extra.forbid

    elements: Optional[str] = None


class Attributes1(BaseModel):
    class Config:
        extra = Extra.forbid

    includeElementData: Optional[str] = None


class Authentication(BaseModel):
    class Config:
        extra = Extra.forbid

    username: Optional[str] = None
    password: Optional[str] = None


class Authentication1(BaseModel):
    class Config:
        extra = Extra.forbid

    token: Optional[str] = None


class Authentication2(BaseModel):
    class Config:
        extra = Extra.forbid

    key: Optional[str] = None


class RetrieveRequest(BaseModel):
    class Config:
        extra = Extra.forbid

    requestId: Optional[str] = Field(
        None,
        description='requestId: the identifier of the request provided by the client; shall be unique within a given DOIP session so clients can distinguish between DOIP service responses. The requestId shall be a string not exceeding 4096 bits.',
    )
    clientId: Optional[str] = Field(
        None, description='clientId: the identifier of the client.'
    )
    targetId: str = Field(
        ...,
        description='targetId: the identifier of the DO on which the operation is to be invoked; the DOIP service could itself be the target.',
    )
    operationId: str = Field(
        '0.DOIP/Op.Retrieve',
        const=True,
        description='operationId: the identifier of the operation to be performed.',
    )
    attributes: Optional[Union[Attributes, Attributes1]] = Field(
        None,
        description='attributes: optional array of JSON properties; operation stipulated.',
    )
    authentication: Optional[
        Union[Authentication, Authentication1, Authentication2]
    ] = Field(
        None,
        description='authentication: optional JSON object used by clients to authenticate.',
    )
