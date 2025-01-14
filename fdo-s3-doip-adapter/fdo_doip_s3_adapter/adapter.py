import json

from operator import itemgetter
from collections.abc import MutableMapping
from datetime import datetime

import doip_frames
from doip_frames import *
from interface_sthree import S3DOIPInterface
from interface_handle import HandleInterface
from handler_interfaces import Handler_Interfaces
from doip_sdk import ResponseStatus


class Doip_Server_Interface:

    def __init__(self, s3_interface:S3DOIPInterface, handle_interface:HandleInterface,s3_error_responses, handle_error_responses):
        self.s3_interface = s3_interface
        self.handle_interface = handle_interface
        self.encode_format = 'utf8'
        self.handler = Handler_Interfaces(s3_interface, handle_interface, s3_error_responses,handle_error_responses)
    
    def _check_authentication(self, request):
        return 'token' in vars(request.authentication)
    
    def _get_user(self,request):
        if not 'user' in vars(request.authentication):
            return 'anonymous'
        return request.authentication
    
    def _decode_segment(self, binarySegment):
        try:
            return binarySegment.decode('utf8')
        except:
            return None
    
    def _process_segment(self,segment):
        try:
            return json.loads(segment)
        except json.JSONDecodeError:
            return {}
    
    def _flatten_dict(self, d: MutableMapping, parent_key: str = '', sep: str ='.') -> MutableMapping:
        items = []
        for k, v in d.items():
            new_key = parent_key + sep + k if parent_key else k
            if isinstance(v, MutableMapping):
                items.extend(self._flatten_dict(v, new_key, sep=sep).items())
            else:
                items.append((new_key, v if v else ''))
        return dict(items)
    
    def _unflatten_dict(self, d: MutableMapping, sep: str = '.') -> MutableMapping:
        result = {}
        for key, value in d.items():
            parts = key.split(sep)
            d_nested = result
            for part in parts[:-1]:
                if part not in d_nested:
                    d_nested[part] = {}
                d_nested = d_nested[part]
            d_nested[parts[-1]] = value
        return result
    
    def _update_metadata(self, metadata, user, action):
        timestamp = str(datetime.now().timestamp())
        metadata.update({
            f'attributes.metadata.{action}on': timestamp,
            f'attributes.metadata.{action}by': user
        })
        return

    def _generate_metadata(self, request,create=True):
        metadata = self._flatten_dict(request.input.model_dump())
        user = self._get_user(request)
        if create:
            self._update_metadata(metadata,user,'created')
        self._update_metadata(metadata,user,'modified')
        return metadata
    
    def _proc_first_segment(self, binarySegment):
        segment = self._decode_segment(binarySegment)
        processedSegment = self._process_segment(segment)
        return processedSegment
    
    def _segments_to_payload(self, segments):
        payload = {}
        id = None
        for binarysegment in segments:
            segment = self._decode_segment(binarysegment)
            processedSegment = self._process_segment(segment)
            if 'id' in processedSegment:
                id = processedSegment['id']
                payload.update({id:[]})
                continue
            if id:
                payload[id].append(segment)
                continue
        return payload
    
    def _request_to_request_body(self, request, segments):
        if not segments:
            return request, '{}'
        meta_payload = self._proc_first_segment(segments.pop(0))
        if not meta_payload:
            return None, None
        #str is ne notloesung bis mir was besseres einfällt. DOIP ist so ein Müll
        elements_list = str([Elements(**x) for x in meta_payload.pop('elements')])
        request.input = DoipDoSerialization(**meta_payload)
        request.input.elements = elements_list
        body = self._segments_to_payload(segments)
        return request, body

    def create(self,request:CreateRequest, segments):
        if not self._check_authentication(request=request):
            return ERRORResponse(status=ResponseStatus.UNAUTHENTICATED.value,output=None)
        if not request.clientId:
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        request, body_unencoded = self._request_to_request_body(request,list(segments))
        if not request:
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if not request.input.id:
            request.input.id = request.clientId
        metadata = self._generate_metadata(request=request)
        body_encoded = str(body_unencoded).encode(self.encode_format)
        response = self.handler.create(request.clientId,metadata=metadata,body=body_encoded,accesskey=request.authentication.token)
        if response == 'NOAuthKey':
            return ERRORResponse(status=ResponseStatus.UNAUTHORIZED.value,output=None)
        if response == 'NoSuchKey':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        if response == 'InvalidDo':
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if response == 'UnknownDo':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        do, _ = self._retrieve(request.clientId, request.authentication.token)
        return do

    def update(self, request:UpdateRequest, segments):
        if not self._check_authentication(request=request):
            return ERRORResponse(status=ResponseStatus.UNAUTHENTICATED.value,output=None)
        do, data = self._retrieve(request.clientId, request.authentication.token)
        request, body_unencoded = self._request_to_request_body(request,list(segments))
        if not request:
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if not request.input.id:
            request.input.id = request.clientId
        data.update(body_unencoded)
        body_encoded = str(data).encode(self.encode_format)
        new_metadata = self._generate_metadata(request=request,create=False)
        metadata = self._flatten_dict(do.model_dump()['output'])
        metadata.update(new_metadata)
        response = self.handler.update(request.clientId,metadata=metadata,body=body_encoded,accesskey=request.authentication.token)
        if response == 'NOAuthKey':
            return ERRORResponse(status=ResponseStatus.UNAUTHORIZED.value,output=None)
        if response == 'NoSuchKey':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        if response == 'InvalidDo':
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if response == 'UnknownDo':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        do, _ = self._retrieve(request.clientId, request.authentication.token)
        return do
        

    def retrieve(self, request:RetrieveRequest):
        if not self._check_authentication(request=request):
            return ERRORResponse(status=ResponseStatus.UNAUTHENTICATED.value,output=None)
        metadata, data = self._retrieve(request.targetId, request.authentication.token)
        if type(metadata) == ERRORResponse:
            return metadata, None
        if not request.attributes:
            return metadata, None
        if not 'elements' in vars(request.attributes):
            return metadata
        return RetrieveResponse(status=ResponseStatus.SUCCESS.value, output= None), data[request.attributes.elements]
    
    def _retrieve(self, targetId, key):
        retrieved_obj = self.handler.retrieve(targetId, key)
        if retrieved_obj == 'NOAuthKey':
            return ERRORResponse(status=ResponseStatus.UNAUTHORIZED.value,output=None), None
        if retrieved_obj == 'NoSuchKey':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None), None
        if retrieved_obj == 'InvalidDo':
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if retrieved_obj == 'UnknownDo':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        metadata = self._unflatten_dict(retrieved_obj['Metadata'])
        #List elements are not supported by doip requestes...
        elemten = metadata['elements']
        element_cast = None
        if not elemten == '':
            elemten = list(eval(elemten))[0]
            element_cast = doip_frames.Retrieve_response.Elements(**elemten.dict())
        metadata["elements"] = element_cast
        std_serializ = doip_frames.Retrieve_response.DoipDoSerialization(**metadata)
        retrieve_response = RetrieveResponse(
            status=ResponseStatus.SUCCESS.value,
            output= std_serializ
        )
        data = retrieved_obj['Body'].read().decode(self.encode_format)
        if not data == '':
            data = json.loads(data.replace("\'", "\""))
        return retrieve_response, data        

    def search(self, request:SearchRequest):
        if not self._check_authentication(request=request):
            return ERRORResponse(status=ResponseStatus.UNAUTHENTICATED.value,output=None)
        try:
            searchQuery = json.loads(request.attributes.query.replace("'","\""))
        except json.JSONDecodeError:
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if not 'Prefix' in searchQuery.keys():
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        response = self.s3_interface.search(query=searchQuery,accesskey=request.authentication.token)
        if not response:
            return ERRORResponse(status=ResponseStatus.UNAUTHORIZED.value,output=None)
        if not 'Contents' in response.keys():
            return SearchResponse(size=0,results=[])
        result_List = list(response['Contents'])
        if request.attributes.pageSize:
            result_List = result_List[:request.attributes.pageSize]
        if request.attributes.sortFields:
            sort_Fields = request.attributes.sortFields.replace('[','').replace(']','').split(',')
            for field in sort_Fields:
                try:
                    result_List = sorted(result_List, key=itemgetter(field))
                except KeyError:
                    continue
        resultList = result_List
        if request.attributes.type == "full":
            listOfFullObject = []
            for result in result_List:
                do, _ = self._retrieve(result['Key'], request.authentication.token)
                listOfFullObject.append(do.output)
            resultList = listOfFullObject
        return SearchResponse(size=len(resultList),results=resultList)

    def delete(self,request:DeleteRequest):
        if not self._check_authentication(request=request):
            return ERRORResponse(status=ResponseStatus.UNAUTHENTICATED,output=None)
        response = self.s3Interface.delete(request.targetId, request.authentication.token)
        if response == 'NOAuthKey':
            return ERRORResponse(status=ResponseStatus.UNAUTHORIZED.value,output=None)
        if response == 'NoSuchKey':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        if response == 'InvalidDo':
            return ERRORResponse(status=ResponseStatus.INVALID.value,output=None)
        if response == 'UnknownDo':
            return ERRORResponse(status=ResponseStatus.UNKNOWN_DO.value,output=None)
        return DeleteRequest(ResponseStatus.SUCCESS.value)

if __name__ == '__main__':
    pass
