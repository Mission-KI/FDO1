class Handler_Interfaces:
    handle_error_responses = None
    s3_error_responses = None
    invalid_handle_response = "InvalidDo"
    unknown_handle_response = "UnknownDo"
    handle_body = [{
        "index":1,
        "type":"S3_OBJ",
        "data": {
           "format":"string",
           "value":"" } },
    {
	"index":2,
	"type":"FDO_Profile_Ref",
	"data": {
		"format":"string",
		"value":"21.T11969/141bf451b18a79d0fe66" }},
    {
        "index":3,
        "type":"FDO_Rights_Ref",
        "data": {
                "format":"string",
                "value":"21.1/thisIsAnFdoRightsSpecification" }},
    {
        "index":4,
        "type":"FDO_Type_Ref",
        "data": {
                "format":"string",
                "value":"21.1/thisIsAnFdoType" }},
    {
	"index":5,
        "type":"FDO_Data_Refs",
        "data": {
                "format":"string",
                "value":"todo-demo" }},
    {
        "index":6,
        "type":"FDO_MD_Refs",
        "data": {
                "format":"string",
                "value":"todo-demo" }},

    ]

    def __init__(self, s3_interface, handle_interface, s3_error_responses, handle_error_responses):
        self.s3_interface = s3_interface
        self.handle_interface = handle_interface
        self.s3_error_responses = s3_error_responses
        self.handle_error_responses = handle_error_responses

    def create(self, handle, metadata, body, accesskey):
        print(metadata)
        response = self.handle_interface.get(handle)
        if not response['responseCode'] == 100:
            return self.invalid_handle_response
        response =  self.s3_interface.create(handle, accesskey, metadata, body )
        if response in self.s3_error_responses:
            return response
        self.handle_body[0]['data']['value'] = self.s3_interface.endpoint +'/' +self.s3_interface.bucket_name
        response = self.handle_interface.put_subprocess(handle,self.handle_body)
        if not response['responseCode'] == 1:
            self.s3_interface.delete(handle, accesskey)
            return self.invalid_handle_response
        return response

    def update(self,handle, metadata, body, accesskey):
        response = self.handle_interface.get(handle)
        if response in self.handle_error_responses:
            return self.unknown_handle_response
        response = self.s3_interface.retrieve(handle, accesskey)
        if response in self.s3_error_responses:
            return response
        tmp_do_metadata, tmp_do_data = self._get_do_data(response)
        response = self.s3_interface.update(handle, accesskey, metadata, body)
        if response in self.s3_error_responses:
            self.s3_interface.create(handle, accesskey, tmp_do_metadata, tmp_do_data, )
            return self.invalid_handle_response
        return response

    def retrieve(self, handle, accesskey):
        response = self.handle_interface.get(handle)
        if response['responseCode'] in self.handle_error_responses:
            return self.unknown_handle_response
        return self.s3_interface.retrieve(handle, accesskey)

    def delete(self, handle, accesskey):
        response = self.handle_interface.get(handle)
        if response['responseCode'] in self.handle_error_responses:
            return self.unknown_handle_response
        response = self.s3_interface.retrieve(handle, accesskey)
        if response in self.s3_error_responses:
            return response
        tmp_do_metadata, tmp_do_data = self._get_do_data(response)
        response_delete = self.s3_interface.delete(handle,accesskey)
        if response_delete in self.s3_error_responses:
            return response
        self.handle_body[0]['data']['value'] = 'Deleted by the order of the Barrel of Whisky Society'
        response = self.handle_interface.put_subprocess(handle,'TODO UPDATE S#@ BODY AS JSON')
        if not response['responseCode'] == 1:
            self.s3_interface.create(handle, accesskey,tmp_do_metadata,tmp_do_data)
            return self.invalid_handle_response
        return response_delete

    def _get_do_data(response):
        return None, None


if __name__ == '__main__':
    pass
