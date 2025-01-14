"""Tests for /repositories/id"""

import json
import datetime
from pathlib import Path
from http import HTTPStatus
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.repositories \
    import list_repositories, get_repository
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_timeout, check_response
from .test_list_repositories import PATH_LOCAL as PATH_LISTREPO

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassGetRepository::"


class TestClassGetRepository:
    """Basic Tests for /repositories/id"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LISTREPO}test_http_repositories[{service["url"]}]'])])
        for service in services])
    def test_http_get_repository(self, url: str):
        """Tests repositories/id with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(f"{url}/repositories", timeout=10)
        repositories = json.loads(response.content.decode())['data']
        for repo in repositories:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = requests.get(f'{url}/repositories/{repo["id"]}',
                                    timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            endpoint_url = f'{url}/repositories/{repo["id"]}'
            self.assertions_helper(response, query_time, return_time,
                                   endpoint_url, repo["id"])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_get_repository_unknown_request(self, url: str):
        """Tests repositories/id with a request for a nonexistent resource,
        using http get. Checks response code and time.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        invalid_id = "ThisIsNotARepository3198561Q"
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(f'{url}/repositories/{invalid_id}', timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        check_timeout(query_time, return_time)
        assert response.status_code == HTTPStatus.NOT_FOUND

    @pytest.mark.xfail(
        reason="Python Client crashes on link dicts that are none/null")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_get_repository[{service["url"]}]',
            f'{PATH_LISTREPO}test_client_repositories[{service["url"]}]'])])
        for service in services])
    def test_client_get_repository(self, url: str):
        """Tests repositories/id with an unauthenticated client.

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
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = get_repository.sync_detailed(repo["id"],
                                                        client=client)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                endpoint_url = f'{url}/repositories/{repo["id"]}'
                self.assertions_helper(response, query_time, return_time,
                                       endpoint_url, repo["id"])

    @pytest.mark.xfail(
        reason="Python Client crashes because the 'detail' entry "
               "of the error dict is dropped somewhere")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_get_repository_unknown_request[{service["url"]}]'])])
        for service in services])
    def test_client_get_repository_unknown_request(self, url: str):
        """Tests repositories/id with a request for a nonexistent resource,
        using the python client. Checks response code and time.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            invalid_id = "ThisIsNotARepository3198561Q"
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = get_repository.sync_detailed(
                f'{url}/repositories/{invalid_id}', client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            check_timeout(query_time, return_time)
            assert response.status_code == HTTPStatus.NOT_FOUND

    # pylint: disable=too-many-arguments
    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime,
                          url: str, pid: str):
        """Asserts correct behaviour of /repositories/id.
        This includes response code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /repositories/id request.
        query_time  : datetime.datetime
                      Time from before the request to /repositories/id was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from after the request to /repositories/id was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        url         : string
                      URL of the endpoint under test, for example
                      "https://manager.testbed.pid.gwdg.de/api/v1/repositories/Cordra"
        pid         : string
                      ID of the current repository, for example "Cordra"
        """
        content = check_response(response, query_time, return_time)
        # Correct content
        for key in ['data', 'links']:           # ↓ structure
            assert key in content
        for key in ['id', 'type', 'attributes', 'links']:
            assert key in content['data']
        for key in ['description', 'maintainer', 'attributes']:
            assert key in content['data']['attributes']
        for key in ['self', 'collection']:
            assert key in content['links']
        assert content['data']['id'] == pid      # ↓ content
        assert content['links']['self'] == url
