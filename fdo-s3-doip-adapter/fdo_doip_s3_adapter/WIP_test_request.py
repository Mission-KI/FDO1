
import doip_frames
from doip_frames import *

TESTCREATEREQUEST1 = (CreateRequest(
    targetId = '21.T11967/service',
    clientId = 'aaaaa',
    operationId = '0.DOIP/Op.Create"',
    authentication = {
        "key":'fake_access_key'
        },
    input = {
        "type": "User",
        "attributes": {
          "content": {
            "username": "user",
            "password": "password"
            }
          }
        }
),[])

TESTCREATERESPONSE1 = RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=doip_frames.Retrieve_response.DoipDoSerialization(id='aaaaa', type='User', attributes={'content': {'username': 'user', 'password': 'password'}, 'metadata': {'createdon': '1729512539.57938', 'createdby': 'anonymous', 'modifiedon': '1729512539.57938', 'modifiedby': 'anonymous'}}, elements=None, signatures=''))
TESTCREATEREQUEST2 = (CreateRequest(
    targetId = '21.T11967/service',
    clientId = 'aaaaa',
    operationId = '0.DOIP/Op.Create"',
    authentication = {
        "key":'fake_access_key'
        }),
        [bytearray(b'{"type": "Document","attributes": {"content": {"id": "","name": "Hello World"}},"elements": [{"id": "file","type": "text/plain","attributes": {"filename": "helloworld.txt"}}]}'), bytearray(b'{"id":"file"}'), b'@', b'Hello World\n', b'#'])

TESTCREATERESPONSE2 = RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=doip_frames.Retrieve_response.DoipDoSerialization(id='aaaaa', type='Document', attributes={'content': {'id': '', 'name': 'Hello World'}, 'metadata': {'createdon': '1729512539.57938', 'createdby': 'anonymous', 'modifiedon': '1729512539.57938', 'modifiedby': 'anonymous'}}, elements=doip_frames.Retrieve_response.Elements(id='file', length=None, type='text/plain', attributes={'filename': 'helloworld.txt'}), signatures=''))
TESTRETRIVE = RetrieveRequest(
    targetId='aaaaa',
    operationId='0.DOIP/Op.Retrieve',
    authentication = {
        "key":'fake_access_key'
        }
)

TESTRETRIVE2 = RetrieveRequest(
    targetId='aaaaa',
    operationId='0.DOIP/Op.Retrieve',
    authentication = {
        "key":'fake_access_key'
        },
    attributes={"elements":"file"}
)

TESTRETRIVERESPONSEDATA = RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=None)
TESTRETRIVEDATA = ['@', 'Hello World\n', '#']


TESTUPDATEREQUEST1 = (UpdateRequest(
    targetId = '21.T11967/service',
    clientId = 'aaaaa',
    operationId = '0.DOIP/Op.Create"',
    authentication = {
        "key":'fake_access_key'
        }),
        [bytearray(b'{"type": "Document","attributes": {"content": {"id": "","name": "Hello World"}},"elements": [{"id": "file","type": "text/plain","attributes": {"filename": "helloworld.txt"}}]}'), bytearray(b'{"id":"file"}'), b'@', b'Hello World\n', b'#'])

TESTUPDATERESPONSE = RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=doip_frames.Retrieve_response.DoipDoSerialization(id='aaaaa', type='Document', attributes={'content': {'username': 'user', 'password': 'password', 'id': '', 'name': 'Hello World'}, 'metadata': {'createdon': '1729512539.57938', 'createdby': 'anonymous', 'modifiedon': '1729512539.57938', 'modifiedby': 'anonymous'}}, elements=doip_frames.Retrieve_response.Elements(id='file', length=None, type='text/plain', attributes={'filename': 'helloworld.txt'}), signatures=''))

TESTSEARCHREQUEST = SearchRequest(
    targetId = "21.T11967/service",
    operationId = "0.DOIP/Op.Search",
    authentication = {
        "key":'fake_access_key'
        },
    attributes = {
      "query": "{'Prefix': 'aaaaa12345678' }",
      "sortFields": "[createdon, createdby, modifiedby,'ETag']"
    }    
)

TESTSEARCHRESPONSE = [RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=doip_frames.Retrieve_response.DoipDoSerialization(id='aaaaa12345678', type='Document', attributes={'content': {'id': '', 'name': 'Hello World'}, 'metadata': {'createdon': '1729512539.57938', 'createdby': 'anonymous', 'modifiedon': '1729512539.57938', 'modifiedby': 'anonymous'}}, elements=doip_frames.Retrieve_response.Elements(id='file', length=None, type='text/plain', attributes={'filename': 'helloworld.txt'}), signatures='')), RetrieveResponse(requestId=None, status='0.DOIP/Status.001', output=doip_frames.Retrieve_response.DoipDoSerialization(id='aaaaa123456789', type='Document', attributes={'content': {'id': '', 'name': 'Hello World'}, 'metadata': {'createdon': '1729512539.57938', 'createdby': 'anonymous', 'modifiedon': '1729512539.57938', 'modifiedby': 'anonymous'}}, elements=doip_frames.Retrieve_response.Elements(id='file', length=None, type='text/plain', attributes={'filename': 'helloworld.txt'}), signatures=''))]