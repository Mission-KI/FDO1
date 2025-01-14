"""Tests for /profiles"""

import datetime
from pathlib import Path
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.profiles import list_profiles
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_response

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassListProfiles::"


class TestClassListProfiles:
    """Basic Tests for /profiles"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_profiles(self, url: str):
        """Tests profiles with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(url + "/profiles", timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        self.assertions_helper(response, query_time, return_time,
                               f"{url}/profiles")

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_profiles[{service["url"]}]'])])
        for service in services])
    def test_client_profiles(self, url: str):
        """Tests profiles with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = list_profiles.sync_detailed(client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time,
                                   f"{url}/profiles")

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime,
                          url: str):
        """Asserts correct behaviour of /profiles.
        This includes response code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /profiles request.
        query_time  : datetime.datetime
                      Time from just before the request to /profiles was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /profiles was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        url         : string
                      URL of the endpoint under test, for example
                      "https://manager.testbed.pid.gwdg.de/api/v1/profiles"
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
            for key in ['id', 'attributes', 'links']:             # ↓ structure
                assert key in entry
            for key in ['pid', 'description']:
                assert key in entry['attributes']
            for key in ['self', 'collection']:
                assert key in entry['links']
            assert entry['id'] not in [None, ""]                    # ↓ content
            assert entry['attributes']['pid'] not in [None, ""]
            assert entry['links']['self'] not in [None, ""]
