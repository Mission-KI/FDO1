import requests
import os
import json
import subprocess

class HandleInterface:

    prefix =None
    handleServerUrl = None
    httpPort = None
    apiEndpoint = '/api/handles/'
    headers = {
    'Authorization': 'Handle clientCert="true", renegotiate="true"',
    'content-type': 'application/json',
    'Accept': '*/*'
    }




    def __init__(self, prefix, url, certs, httpPort=8000 ):
        self.prefix = prefix
        self.httpPort = str(httpPort)
        self.handleServerUrl = url + ':' + self.httpPort + self.apiEndpoint
        self.certs = certs
        
    def _self_service(self):
        return vars(self)
    
    def _body_to_binary(self,body):
        return json.dumps(body).encode('utf8')
    
    def _binary_to_body(self, binary):
        return json.loads(binary.decode('utf8'))
    
    def _get_handle_response(self, response):
        if not len(response) == 2:
            return False
        handle_response_part =  response[1].split("\n")[-1]
        return json.loads(handle_response_part)


    def put(self, index, body):
        #to be killed use put_subprocess
        if not self.prefix in index:
            request = self.handleServerUrl + "/".join([self.prefix, index])
        if self.prefix in index:
            request = self.handleServerUrl + index
        data = self._body_to_binary(body)
        response = requests.put(
            url=request,
            json = body,
            cert=self.certs, 
            verify=False,
            allow_redirects=True)
        return response

    def put_subprocess(self, index, body):
        if not self.prefix in index:
            request = self.handleServerUrl + "/".join([self.prefix, index])
        if self.prefix in index:
            request = self.handleServerUrl + index
        curl = f"""curl --insecure --key {self.certs[1]} --cert {self.certs[0]} -H 'Authorization: Handle clientCert="true"'  -H "content-type:application/json" --data "{body}" -X PUT {request}"""
        response = subprocess.getstatusoutput(curl)
        handle_response = self._get_handle_response(response)
        return handle_response

    def get(self, index):
        if not self.prefix in index:
            request = self.handleServerUrl + "/".join([self.prefix, index])
        if self.prefix in index:
            request = self.handleServerUrl + index
        response = requests.get(url=request,verify=False)
        return json.loads(response.content.decode('utf-8'))

if __name__ == '__main__':
    pass