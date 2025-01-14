"""Tests for /profiles/id"""

import json
import datetime
from pathlib import Path
from http import HTTPStatus
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.profiles  \
    import list_profiles, get_profile
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_timeout, check_response
from .test_list_profiles import PATH_LOCAL as PATH_LISTPROFILE

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassGetProfile::"


class TestClassGetProfile:
    """Basic Tests for /profiles/id"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LISTPROFILE}test_http_profiles[{service["url"]}]'])])
        for service in services])
    def test_http_get_profile(self, url: str):
        """Tests profiles/id with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(url + "/profiles", timeout=10)
        profiles = json.loads(response.content.decode())['data']
        for profile in profiles:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = requests.get(f'{url}/profiles/{profile["id"]}',
                                    timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            endpoint_url = f'{url}/profiles/{profile["id"]}'
            self.assertions_helper(response, query_time, return_time,
                                   endpoint_url, profile["id"])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_get_profile_unknown_request(self, url: str):
        """Tests profiles/id with a request for a nonexistent resource,
        using http get. Checks response code and time.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        invalid_id = "ThisIsNotAProfile3198561Q"
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(f'{url}/profiles/{invalid_id}', timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        check_timeout(query_time, return_time,
                      response.headers.get('date', None))
        assert response.status_code == HTTPStatus.NOT_FOUND

    @pytest.mark.xfail(
        reason="Python Client crashes on link dicts that are none/null")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_get_profile[{service["url"]}]',
            f'{PATH_LISTPROFILE}test_client_profiles[{service["url"]}]'])])
        for service in services])
    def test_client_get_profile(self, url: str):
        """Tests profiles/id with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            response = list_profiles.sync_detailed(client=client)
            profiles = json.loads(response.content.decode())['data']
            for profile in profiles:
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = get_profile.sync_detailed(profile["id"],
                                                     client=client)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                endpoint_url = f'{url}/profiles/{profile["id"]}'
                self.assertions_helper(response, query_time, return_time,
                                       endpoint_url, profile["id"])

    @pytest.mark.xfail(
        reason="Python Client crashes because the 'detail' entry "
               "of the error dict is dropped somewhere")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_get_profile_unknown_request[{service["url"]}]'])])
        for service in services])
    def test_client_get_profile_unknown_request(self, url: str):
        """Tests profiles/id with a request for a nonexistent resource,
        using the python client. Checks response code and time.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            invalid_id = "ThisIsNotAProfile3198561Q"
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = get_profile.sync_detailed(f'{url}/profiles/{invalid_id}',
                                                 client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            check_timeout(query_time, return_time,
                          response.headers.get('date', None))
            assert response.status_code == HTTPStatus.NOT_FOUND

    # pylint: disable=too-many-arguments
    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime,
                          url: str, pid: str):
        """Asserts correct behaviour of /profiles/id.
        This includes response code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /profiles/id request.
        query_time  : datetime.datetime
                      Time from just before the request to /profiles/id is sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /profiles/id is sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        url         : string
                      URL of the endpoint under test, for example
                     "https://manager.testbed.pid.gwdg.de/api/v1/profiles/ID"
        pid         : string
                      ID of the current profile, for example "FDO_KIP"
        """
        content = check_response(response, query_time, return_time)
        # Correct content
        for key in ['data', 'links']:                   # ↓ structure
            assert key in content
        for key in ['id', 'attributes', 'links']:
            assert key in content['data']
        for key in ['self', 'collection']:
            assert key in content['links']
        assert content['data']['id'] == pid              # ↓ content
        assert content['data']['attributes']['pid'] not in [None, ""]
        assert content['links']['self'] == url
