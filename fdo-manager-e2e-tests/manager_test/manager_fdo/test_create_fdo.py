"""Tests for /fdo"""

import json
import datetime
from pathlib import Path
from http import HTTPStatus
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.fd_os import create_fdo
from fdo_manager_service_api_client.api.repositories import list_repositories
from fdo_manager_service_api_client.models \
    import CreateFDOBody, TargetRepositories

from ..service_index import services_to_test_changes as services
from ..test_utils.utils import created_fdos, root_dir
from ..test_utils.assertions import check_timeout
from ..manager_repository.test_list_repositories \
    import PATH_LOCAL as PATH_LISTREPO

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassCreateFDO::"
PATH_LOCAL_CHECKS = PATH_FILE + "::TestClassCreateFDOChecks::"


class TestClassCreateFDO:                           # pylint: disable=fixme
    """Basic Tests for /fdo"""
    # ToDo: This will be asking for authentication as soon as authentication
    #       passthrough is available. Then add a 'request denied' assert, move
    #       this to AuthenticatedClient, and revisit the http funcs

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LISTREPO}test_http_repositories[{service["url"]}]'])])
        for service in services])
    def test_http_create_fdo(self, url: str):
        """Tests creation of a fdo with a post request, adds data on
        created fdos to created_fdos[<service>].

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        # ensure setup of created_fdos
        if url not in created_fdos:
            created_fdos[url] = []
        # create a fdo in every available repository
        response = requests.get(url + "/repositories", timeout=10)
        repositories = json.loads(response.content.decode())['data']
        if len(repositories) == 0:
            pytest.skip("Cannot create an FDO without repository.")
        for repo in repositories:
            request_files = {
                'repositories': (None, '{"fdo": "' + repo["id"] + '"}',
                                 'application/json'),
                'data':      ("exampledata.txt",
                              b"This is example data for test calls.", None),
                'metadata':  ('examplemetadata.txt',
                              b"This is example metadata for test calls.", None)
            }
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = requests.post(f"{url}/fdo", files=request_files,
                                     timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time)
            # Add to collection to f.e. later check correct log entry
            created_fdos[url].append({'url': response.headers['location'],
                                      'repo': repo["id"], 'deleted': False,
                                      'time': response.headers['date']})

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_create_fdo[{service["url"]}]',
            f'{PATH_LISTREPO}test_client_repositories[{service["url"]}]'])])
        for service in services])
    def test_client_create_fdo(self, url: str):
        """Tests creation of a fdo with an unauthenticated client using
        assertions_helper(). Adds the locations of created fdos to
        created_fdos[<service>].

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        # ensure setup of created_fdos
        if url not in created_fdos:
            created_fdos[url] = []
        # create a fdo in every available repository
        with Client(base_url=url) as client:
            response = list_repositories.sync_detailed(client=client)
            repositories = json.loads(response.content.decode())['data']
            if len(repositories) == 0:
                pytest.skip("Cannot create an FDO without repository.")
            for repo in repositories:
                body = CreateFDOBody(
                    repositories=TargetRepositories(fdo=repo["id"]),
                    data=client_types.File(file_name="exampledata.txt",
                                           payload=b"Example data"),
                    metadata=client_types.File(file_name="examplemetadata.txt",
                                               payload=b"Example metadata"))
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = create_fdo.sync_detailed(client=client, body=body)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                self.assertions_helper(response, query_time, return_time)
                created_fdos[url].append({'url': response.headers['location'],
                                          'repo': repo["id"], 'deleted': False,
                                          'time': response.headers['date']})

    @pytest.mark.xfail(
        reason="Server accepts empty bytestring without name as valid file")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_create_fdo[{service["url"]}]'])])
        for service in services])
    def test_http_create_fdo_empty(self, url: str):
        """Tests creation of an invalid fdo with a post request.
        The fdo has empty bytestrings without name as data and metadata files.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(url + "/repositories", timeout=10)
        repositories = json.loads(response.content.decode())['data']
        for repo in repositories:
            request_files = {
                'repositories': (None, '{"fdo": "' + repo["id"] + '"}',
                                 'application/json'),
                'data': ("", b'', None),
                'metadata': ('', b'', None)}
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = requests.post(url + "/fdo", files=request_files,
                                     timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            # Correct Error
            assert response.status_code == HTTPStatus.BAD_REQUEST
            # Answer within one second
            check_timeout(query_time, return_time, response.headers['date'])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_client_create_fdo[{service["url"]}]'])])
        for service in services])
    def test_client_create_fdo_empty(self, url: str):
        """Tests creation of an empty fdo with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            response = list_repositories.sync_detailed(client=client)
            repositories = json.loads(response.content.decode())['data']
            for repo in repositories:
                body = CreateFDOBody(
                    repositories=TargetRepositories(fdo=repo["id"]),
                    data=client_types.File(
                        file_name="",
                        payload=b'This is example data for test calls.'),
                    metadata=client_types.File(
                        file_name="",
                        payload=b'This is example metadata for test calls.'))
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = create_fdo.sync_detailed(client=client, body=body)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                # Correct Error
                assert response.status_code == HTTPStatus.BAD_REQUEST
                # Answer within one second
                check_timeout(query_time, return_time,
                              response.headers['date'])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_create_fdo[{service["url"]}]'])])
        for service in services])
    def test_http_create_fdo_malformed(self, url: str):
        """Tests creation of a fdo with a malformed post request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(url + "/repositories", timeout=10)
        repositories = json.loads(response.content.decode())['data']
        for repo in repositories:
            repo_files = (None,
                          '{"fdo": "' + repo["id"] + '"}', 'application/json')
            data_files = ("exampledata.txt",
                          b"This is example data for test calls.", None)
            meta_files = ('examplemetadata.txt',
                          b"This is example metadata for test calls.", None)
            # Delete or replace components of the call with None and check
            # that the call is not accepted as valid.
            for request_files in [
                {'repositories': repo_files,
                 'data': data_files, 'metadata': None},
                {'repositories': None,
                 'data': data_files, 'metadata': meta_files},
                {'repositories': repo_files,
                 'data': None, 'metadata': meta_files},
                {'repositories': repo_files, 'data': data_files},
                {'data': data_files, 'metadata': meta_files},
                {'repositories': repo_files, 'metadata': meta_files},
                {'repositories': (None, '{"fdo": "' + repo["id"] + '"}'),
                 'data': data_files, 'metadata': meta_files}
            ]:
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = requests.post(url + "/fdo", files=request_files,
                                         timeout=10)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                # Correct Error
                assert response.status_code in [
                    HTTPStatus.BAD_REQUEST, HTTPStatus.UNSUPPORTED_MEDIA_TYPE]
                # Answer within one second
                check_timeout(query_time, return_time,
                              response.headers['date'])

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime):
        """Asserts correct behaviour of /fdo.
        This includes response code and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /fdo request.
        query_time  : datetime.datetime
                      Time from just before the request to /fdo was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /fdo was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        """
        # No errors
        assert response.status_code == HTTPStatus.CREATED
        # Answer within one second
        check_timeout(query_time, return_time, response.headers['date'])


@pytest.mark.order(after=["TestClassCreateFDO"])
class TestClassCreateFDOChecks:                        # pylint: disable=fixme
    """Tests integrating outside systems for FDOs created with /fdo"""

    @pytest.mark.parametrize("service", [pytest.param(service, marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_create_fdo_outside_systems_check(self, service: dict):
        """Tests successful creation of a fdo by checking directly with
        the repo and handle systems if possible.

        Parameters
        ----------
        service:    dict
                    Dictionary containing info of the service to be tested,
                    including url and information about available repos.
        """
        if service['url'] not in created_fdos:
            pytest.skip('Cannot check FDOs if none have been created.')
        any_checks_made = False
        for created_fdo in created_fdos[service['url']]:
            repo = service["repos"][created_fdo['repo']]
            pid = created_fdo['url'].split(f"{service['url']}/fdo/")[1]
            # If possible, check with repo
            if "retrieve" in repo["links"] and repo["links"]["retrieve"]:
                api_config = repo["links"]["retrieve"]
                match api_config["api_version"]:
                    case "Cordra-V1":
                        url = api_config["url"]
                        response = requests.get(url, params={"targetId": pid},
                                                timeout=10)
                        assert response.status_code == HTTPStatus.OK
                        content = json.loads(response.content.decode())
                        assert content["id"] == pid
                        any_checks_made = True
            # If possible, check with handle system
            if "handle" in repo["links"] and repo["links"]["handle"] != "":
                url = repo["links"]["handle"]["url"]
                self.assertions_helper_handle(url, pid)
                any_checks_made = True
        if not any_checks_made:
            pytest.skip('No checks with outside systems were possible.')

    def assertions_helper_handle(self, url: str, pid: str, kind: str = 'fdo'):
        """Asserts correct response format of the handle system for a fdo.

        Parameters
        ----------
        url  : str
               URL of the API endpoint of the handle system,
               for example "https://hdl.handle.net/api/handles/"
        pid  : str
               PID of the fdo to be checked, including prefix and suffix.
               For example "some.prefix/eb2a7c04-8970-41bb-a36c-d5670f25d66b"
        kind : str, optional = 'fdo'
               Type of the record to check,
               f.e. 'fdo', 'metadata', 'data', 'profile' or 'service'
        """
        # Check successful response
        response = requests.get(f'{url}{pid}', timeout=10)
        assert response.status_code == HTTPStatus.OK
        # Parse content
        content = json.loads(response.content.decode())
        attributes = {}
        for entry in content['values']:
            attributes[entry['type']] = entry['data']['value']
        # General assertions
        assert content["handle"] == pid
        # Type specific assertions
        # ToDo: Add combination of URL and 10320/loc as a check?
        #       Either one would need to be there
        match kind:
            case 'fdo':
                self._assert_service(url, attributes)
                self._assert_data(url, attributes)
                self._assert_metadata(url, attributes)
                self._assert_service(url, attributes)
                # ToDo: Re-add when implemented
                # self._assert_type(url, attributes, kind)
            case 'data':
                self._assert_service(url, attributes)
            case 'metadata':
                self._assert_service(url, attributes)
            case 'profile':
                self._assert_service(url, attributes)
            case 'service':
                assert "0.TYPE/DOIPServiceInfo" in attributes
                attributes = json.loads(attributes["0.TYPE/DOIPServiceInfo"])["attributes"]
                assert "ipAddress" in attributes
                assert "port" in attributes

    # 'Private' helper methods to check syntactical correctness of attributes

    def _assert_service(self, url, attributes):
        assert "0.TYPE/DOIPService" in attributes
        self.assertions_helper_handle(url, attributes["0.TYPE/DOIPService"],
                                      'service')

    def _assert_data(self, url, attributes):
        assert "FDO_Data_Refs" in attributes
        data_ref = attributes["FDO_Data_Refs"]
        if data_ref[0] == "[":
            data_ref = data_ref[1:-1]
        # ToDo: Check whether data ref is a handle or sth else (url?)
        self.assertions_helper_handle(url, data_ref, 'data')

    def _assert_metadata(self, url, attributes):
        assert "FDO_MD_Refs" in attributes
        mdata_ref = attributes["FDO_MD_Refs"]
        if mdata_ref[0] == "[":
            mdata_ref = mdata_ref[1:-1]
        # ToDo: Check whether metadata ref is a handle or sth else (url?)
        self.assertions_helper_handle(url, mdata_ref, 'metadata')

    def _assert_profile(self, url, attributes):
        assert "FDO_Profile_Ref" in attributes
        self.assertions_helper_handle(url, attributes["FDO_Profile_Ref"],
                                      'profile')

    # pylint: disable=unused-argument
    def _assert_type(self, url, attributes, kind):
        assert "FDO_Type_Ref" in attributes
        if kind == 'fdo':
            assert attributes["FDO_Type_Ref"] == '0.TYPE/FDO'
