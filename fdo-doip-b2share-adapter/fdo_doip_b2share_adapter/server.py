import json
from collections.abc import Iterator

from doip_sdk import DOIPHandler, ServerResponse, ResponseStatus, write_json_segment, write_empty_segment, DOIPServer

import requests

from fdo_doip_b2share_adapter.models import DigitalObject

# Todo: read communities from service
# B2Share_url = 'http://141.5.106.114:5000'
B2Share_url = 'https://b2share.testbed.pid.gwdg.de'
EUDAT_community = 'e9b9792e-79fb-4b07-b6b4-b9c2bd06d095'
FDO_community = 'af4db316-c781-4085-a166-a84bffefc15d'
# FDO_community = '5f38f74f-5af1-4759-891d-470f53dbfb0f'
# Prefix: 21.T11975
service_target_id = '21.T11975/service'


def create_draft(segment: dict, file_info: dict, community: dict, community_id: str):
    header = {"Content-Type": "application/json"}
    params = {"access_token": segment['authentication']['token']}
    metadata = {
        "titles": [{"title": file_info['attributes']['content']['name']}],
        "community": community_id,
        "open_access": True,
        "creators": [{"creator_name": "B2SHARE DOIP Adapter"}],
        "descriptions": [
            {
                "description": "A simple description",
                "description_type": "Other"
            }
        ]
    }
    if len(community) > 0:
        metadata['community_specific'] = community
    else:
        metadata['community_specific'] = {}
    response = requests.post(B2Share_url + '/api/records/', params=params,
                             data=json.dumps(metadata), headers=header, allow_redirects=True, verify=False)
    return json.loads(response.text)


def publish_record(record_id: str, params: dict):
    header = {'Content-Type': 'application/json-patch+json'}
    commit = '[{"op": "add", "path":"/publication_state", "value": "submitted"}]'
    url = B2Share_url + "/api/records/" + record_id + "/draft"
    response = requests.patch(url, data=commit, params=params, headers=header, allow_redirects=True, verify=False)
    return json.loads(response.text)


def run_search(query):
    query_url = B2Share_url + '/api/records'
    # Send request
    params = {
        'q': query
        #        'size': 50,
        #        'sort': 'mostrecent'
        #        'access_token': access_token
    }
    results = requests.get(query_url, params=params, allow_redirects=True, verify=False)
    return json.loads(results.text)['hits']


def finalize_operation(self, response):
    write_json_segment(
        socket=self.request,
        message=response.model_dump(exclude_none=True)
    )
    write_empty_segment(socket=self.request)


class ExampleHandler(DOIPHandler):

    def hello(self, first_segment: dict, _: Iterator[bytearray]):
        if first_segment.get('targetId', '') == service_target_id:
            response = ServerResponse(status=ResponseStatus.SUCCESS)
        else:
            response = ServerResponse(status=ResponseStatus.UNKNOWN_DO, output={'message': 'targetID not correct'})
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_empty_segment(socket=self.request)

    def list_operations(self, first_segment: dict, _: Iterator[bytearray]):
        # Update list when more Operations are supported
        if first_segment.get('targetId', '') == service_target_id:
            output = ["0.DOIP/Op.Hello", "0.DOIP/Op.ListOperations",
                      "0.DOIP/Op.Search", "0.DOIP/Op.Create", "0.DOIP/Op.Retrieve"]
            response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)
        else:
            # Todo: here we need to check if the target_id is equal to a DO
            response = ServerResponse(status=ResponseStatus.UNKNOWN_DO, output={'message': 'targetID not correct'})
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_empty_segment(socket=self.request)

    def create(self, first_segment: dict, segments: Iterator[bytearray]):
        if first_segment.get('targetId', '') != service_target_id:
            response = ServerResponse(status=ResponseStatus.UNKNOWN_DO)
            finalize_operation(self, response)
            return
        if 'token' not in first_segment['authentication'].keys():
            output = {'message': 'only token authorization allowed'}
            response = ServerResponse(status=ResponseStatus.INVALID, output=output)
            finalize_operation(self, response)
            return
        # Create Draft
        file_info = json.loads(segments.__next__().decode('utf8'))
        if file_info.get('type') == 'Document':
            # We have a regular (list of) Document(s)
            # All Documents are stored in the EUDAT Community Schema
            community_specific = {}
            result = create_draft(first_segment, file_info, community_specific, EUDAT_community)

            # Prepare data upload
            record_id_data = result["id"]
            file_bucket_id = result["links"]["files"].split('/')[-1]
            url = B2Share_url + '/api/files/' + file_bucket_id
            header = {"Accept": "application/json", "Content-Type": "application/octet-stream"}
            params = {"access_token": first_segment['authentication']['token']}

            # Get file information if files are send
            if 'elements' in file_info.keys():
                for element in file_info['elements']:
                    filename = element['attributes']['filename']
                    file_id = segments.__next__()
                    byte_length = segments.__next__()
                    file = segments.__next__()
                    end_segment = segments.__next__()
                    r = requests.put(url + '/' + filename, data=file, params=params, headers=header,
                                     allow_redirects=True,
                                     verify=False)

            result = publish_record(record_id_data, params)
            # Todo: this should be the ePIC PID not the internal ID

            output = {"id": result["metadata"]["ePIC_PID"]}
            response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)
        elif file_info.get('type') == 'FDO':
            # Create FDO of configuration type 14
            community_specific = {
                "5f38f74f-5af1-4759-891d-470f53dbfb0f": {
                    "FDO_Profile_Ref": file_info['attributes']['content']['21.T11969/bcc54a2a9ab5bf2a8f2c'],
                    "FDO_Rights_Ref": file_info['attributes']['content']['21.T11969/90fa2a1e224ae3e54139'],
                    "FDO_Type_Ref": file_info['attributes']['content']['21.T11969/2bb5fec05c00bb89793e'],
                    "FDO_Data_Ref": file_info['attributes']['content']['21.T11969/867134e94b3ec5afc6fe'][0],
                    "FDO_MD_Ref": file_info['attributes']['content']['21.T11969/a02253b264a9f2f1cf9a'][0]
                }
            }
            result = create_draft(first_segment, file_info, community_specific, FDO_community)
            record_id_fdo = result["id"]
            params = {"access_token": first_segment['authentication']['token']}
            result = publish_record(record_id_fdo, params)
            output = {"id": result["metadata"]["ePIC_PID"]}
            response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)
        else:
            response = ServerResponse(status=ResponseStatus.UNKNOWN_DO)
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_empty_segment(socket=self.request)

    def retrieve(self, first_segment: dict, _: Iterator[bytearray]):
        target_id = first_segment.get('targetId')
        if not target_id:
            output = {'message': 'targetId not specified'}
            response = ServerResponse(status=ResponseStatus.INVALID, output=output)
            finalize_operation(self, response)
            return
        file_id = target_id.lstrip('http://hdl.handle.net/')
        hit = run_search('\"' + file_id + '\"')
        output = DigitalObject(id=file_id, type="Document", attributes=hit['hits'][0])
        response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)

        if first_segment.get('attributes'):
            if first_segment['attributes'].get('element'):
                print('Get Element (file) ')
            elif first_segment['attributes'].get('includeElementData'):
                print('Get Element and Metadata')
            else:
                print('Get only Metadata')
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_empty_segment(socket=self.request)

    def update(self, first_segment: dict, _: Iterator[bytearray]):
        response = ServerResponse(status=ResponseStatus.SUCCESS)
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_empty_segment(socket=self.request)

    def delete(self, first_segment: dict, _: Iterator[bytearray]):
        target_id = first_segment.get('targetId')
        if not target_id:
            output = {'message': 'targetId not specified'}
            response = ServerResponse(status=ResponseStatus.INVALID, output=output)
            finalize_operation(self, response)
            return
        # remove resolver before searching
        hit = run_search('\"' + target_id.lstrip('http://hdl.handle.net/') + '\"')
        if hit.get('hits'):
            record_id = hit['hits'][0]['id']
            bucket_id = hit['hits'][0]['files'][0]['bucket']
            if hit['total'] > 1:
                output = {'message': 'Not unique search result' + record_id}
                response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)
            else:
                output = {'message': 'Deleted record_id' + record_id}
                response = ServerResponse(status=ResponseStatus.SUCCESS, output=output)
        else:
            output = {'message': 'could not find target_id'}
            response = ServerResponse(status=ResponseStatus.UNKNOWN_ERROR, output=output)
        finalize_operation(self, response)

    def search(self, first_segment: dict, _: Iterator[bytearray]):
        # Get query from DOIP request
        query = first_segment['attributes']['query']
        # Build url using the query
        hits = run_search(query)

        search_result = {'results': [], 'size': hits['total']}
        for hit in hits['hits']:
            search_result['results'].append(hit)

        response = ServerResponse(status=ResponseStatus.SUCCESS)
        write_json_segment(
            socket=self.request,
            message=response.model_dump(exclude_none=True)
        )
        write_json_segment(
            socket=self.request,
            message=search_result
        )
        write_empty_segment(socket=self.request)


if __name__ == '__main__':
    HOST, PORT = '0.0.0.0', 9999
    with DOIPServer(HOST, PORT, ExampleHandler) as server:
        server.start()
