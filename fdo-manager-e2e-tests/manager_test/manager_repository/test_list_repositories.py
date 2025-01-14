"""Tests for /repositories"""

import datetime
from pathlib import Path
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.repositories import list_repositories
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_response

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassListRepositories::"


class TestClassListRepositories:
    """Basic Tests for /repositories"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_repositories(self, url: str):
        """Tests repositories with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(url + "/repositories", timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        self.assertions_helper(response, query_time, return_time,
                               url + "/repositories")

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_repositories[{service["url"]}]'])])
        for service in services])
    def test_client_repositories(self, url: str):
        """Tests repositories with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = list_repositories.sync_detailed(client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time,
                                   url + "/repositories")

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime, url: str):
        """Asserts correct behaviour of /repositories.
        This includes response code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /repositories request.
        query_time  : datetime.datetime
                      Time from before the request to /repositories was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from after the request to /repositories was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        url         : string
                      URL of the endpoint under test, for example
                      "https://manager.testbed.pid.gwdg.de/api/v1/repositories"
        """
        # pylint: disable=duplicate-code
        content = check_response(response, query_time, return_time)
        # Correct content
        for key in ['data', 'links']:
            assert key in content
        for key in ['self', 'collection']:
            assert key in content['links']
        assert content['links']['self'] == url
        for entry in content['data']:                      # ↓ Check data
            for key in ['id', 'type', 'attributes', 'links']:     # ↓ structure
                assert key in entry
            for key in ['description', 'maintainer', 'attributes']:
                assert key in entry['attributes']
            for key in ['self', 'collection']:
                assert key in entry['links']
            assert entry['id'] not in [None, ""]                    # ↓ content
            assert entry['links']['self'] not in [None, ""]
