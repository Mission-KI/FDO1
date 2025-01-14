
import time
import logging
import doip_frames

from pydantic_core import ValidationError
from interface_sthree import S3DOIPInterface
from adapter import Doip_Server_Interface
from interface_handle import HandleInterface
from uuid import uuid1
from doip_sdk import DOIPHandler, ServerResponse, ResponseStatus, write_json_segment, write_empty_segment, DOIPServer


logger = logging.getLogger(__name__)
logging.basicConfig(filename='log.log', level=logging.DEBUG)



#! SERVER CONFIG, CHANGE TO YOUR SETTING
PREFIX = 'YOUR_PREFIX'
HOST = '0.0.0.0'
PORT = 'YOUR_ADAPTER_PORT_AS_INT'

IP = '141.5.107.142'

ENDPOINT = 'YOUR_ENDPOINT'
BUCKETNAME  = "YOUR_BUCKET_NAME"

HANDLEURL = 'URL_OF_YOUR_HANDLESERVER'
HANDLEPORT = 'HTTP_PORT_OF_YOUR_HANDLESERVER'

HANDLECERT = ('PATH_TO_YOUR_HANDLECERT','PATH_TO_OUR_HANDLEKEY')

PUBLICKEY = 'YOUR PUBLIC KEY'

PROTOCOL = 'DOIP'
PROTOCOLVERSION = '1'

AWSSECRETKEY = 'YOUR AWS SECRET KEY'

serviceTarget = PREFIX + '/service'

s3Interface = S3DOIPInterface(ENDPOINT, BUCKETNAME, AWSSECRETKEY)
s3_error_responses = ['NoSuchKey', 'NoAuthKey']
handle_error_responses = [101,100,102,300,301,302,400,401,402,403,404]

handleInterface = HandleInterface(prefix=PREFIX, url=HANDLEURL, certs=HANDLECERT, httpPort=HANDLEPORT)
BACKENDINTERFACE = Doip_Server_Interface(handle_interface=handleInterface,s3_interface=s3Interface,s3_error_responses=s3_error_responses,handle_error_responses=handle_error_responses)


class S3Server(DOIPHandler):
    port = 9998
    host = IP
    protocol = PROTOCOL
    protocolVersion = PROTOCOLVERSION
    publicKey = PUBLICKEY
    availableOperations = [
                '0.DOIP/Op.Hello',
                '0.DOIP/Op.ListOperations',
                '0.DOIP/Op.Create',
                '0.DOIP/Op.Delete',
                '0.DOIP/Op.Update',
                '0.DOIP/Op.Retrieve',
                '0.DOIP/Op.Search',
            ]
    s3Interface = s3Interface
    handler = BACKENDINTERFACE
    serviceTarget = serviceTarget


    def hello(self, firstSegment, *_ ):
        logging.debug('**Hello Call**')
        request = self._create_dataframe(doip_frames.HelloRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if not request.targetId == serviceTarget:
            response = self._create_std_output_frame(ResponseStatus.UNKNOWN_DO.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        response = self._create_std_output_frame(ResponseStatus.SUCCESS.value)
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response)
        return

    def list_operations(self,firstSegment, *_):
        logging.debug('**ListOperations Call**')
        request = self._create_dataframe(doip_frames.ListOperationsRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if not request.targetId == serviceTarget:
            response = self._create_std_output_frame(ResponseStatus.UNKNOWN_DO.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        response = doip_frames.ListOperationsResponse(status=ResponseStatus.SUCCESS.value,output=self.availableOperations)
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response)
        return

    def create(self, firstSegment, segments):
        logging.debug('**Create Call**')
        request = self._create_dataframe(doip_frames.CreateRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if not request.targetId == serviceTarget:
            response = self._create_std_output_frame(ResponseStatus.UNKNOWN_DO.value)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if not request.clientId:
            request.clientId = str(uuid1())
        if not self.prefix in request.clientId:
            request.clientId = self.prefix + '/' + request.clientId
        response = self.handler.create(request,list(segments))
        if type(response) == doip_frames.ERRORResponse:
            response = self._create_std_output_frame(response.status,output=response.output)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response)
        return

    def delete(self, firstSegment, *_):
        logging.debug('**Delete Call**')
        request = self._create_dataframe(doip_frames.DeleteRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        flag, status = self.handler.delete(request)
        if type(response) == doip_frames.ERRORResponse:
            response = self._create_std_output_frame(response.status,output=response.output)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response)
        return

    def retrieve(self,firstSegment, *_):
        logging.debug('**Retrieve Call**')
        request = self._create_dataframe(doip_frames.RetrieveRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        response, data = self.handler.retrieve(request)
        if type(response) == doip_frames.ERRORResponse:
            response = self._create_std_output_frame(response.status,output=response.output)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response, data=data)
        return

    def search(self, firstSegment, *_):
        logging.debug('**Search Call**')
        request = self._create_dataframe(doip_frames.SearchRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        response = self.handler.search(request)
        if type(response) == doip_frames.ERRORResponse:
            response = self._create_std_output_frame(response.status,output=response.output)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        self._send_response(response)
        return

    def update(self,firstSegment, segments):
        logging.debug('**Update Call**')
        request = self._create_dataframe(doip_frames.UpdateRequest,firstSegment)
        if not request:
            response = self._create_std_output_frame(ResponseStatus.INVALID)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        response = self.handler.update(request,list(segments))
        if type(response) == doip_frames.ERRORResponse:
            response = self._create_std_output_frame(response.status,output=response.output)
            if request.requestId:
                response.requestId = request.requestId
            self._send_response(response)
            return
        if request.requestId:
            response.requestId = request.requestId
        self._send_response(response)
        return

    def _create_dataframe(self,request,firstSegment,segments=None):
        try:
            requestFrame = request(**firstSegment)
            return requestFrame
        except ValidationError as error:
            return False

    def _create_std_output_frame(self, responsecode,output=None,data=None):
        if not output:
            output={
                "id":"21.T11958/service",
                "type":"DOIPServiceInfo",
                "attributes":{"ipAddress":self.host,
                      "port":self.port,
                      "protocol":self.protocol,
                      "protocolVersion":self.protocolVersion,
                      "publicKey":self.publicKey,}}
        return doip_frames.ERRORResponse(status=responsecode,output=output)
    
    def _send_response(self, response, toggle=True, data=None):
        if not toggle:
            write_json_segment(socket=self.request, message=response.model_dump(exclude_none=True))
            write_empty_segment(socket=self.request)
        elementsContent = None
        message = response.model_dump(exclude_none=True)
        try:
            if 'elementsContent' in message['output'].keys():
                elementsContent = message['output'].pop('elementsContent')
        except:
            pass
        if data:
            elementsContent = data
        write_json_segment(socket=self.request, message=message)
        time.sleep(1)
        if elementsContent:
            socket = self.request
            for element in elementsContent:
                message_byte = bytes(element,'utf8')
                socket.sendall(message_byte + b'\n')
        write_empty_segment(socket=self.request)

if __name__ == "__main__":
    with DOIPServer(HOST, PORT, S3Server) as server:
        server.start()
ServerResponse