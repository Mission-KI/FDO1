"""Tests for /info"""

import datetime
from pathlib import Path
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.info import get_info
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_response

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassInfo::"


class TestClassInfo:
    """Basic Tests for /info"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_info(self, url: str):
        """Tests info with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(url + "/info", timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        self.assertions_helper(response, query_time, return_time)

    @pytest.mark.xfail(
        reason="Python Client crashes on link dicts that are none/null")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_info[{service["url"]}]'])])
        for service in services])
    def test_client_info(self, url: str):
        """Tests info with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = get_info.sync_detailed(client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time)

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime):
        """Asserts correct behaviour of /info.
        This includes response code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /info request.
        query_time  : datetime.datetime
                      Time from just before the request to /info was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /info was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        """
        content = check_response(response, query_time, return_time)
        # Correct content format
        for key in ['data', 'links']:
            assert key in content
        for key in ['fdoServiceVersion', 'fdoSdkVersion', 'serviceProvider',
                    'links']:
            assert key in content['data']
        # Version is f.e. 0.1.0-rc7, we want 010 to be numeric
        fdo_service_version = content['data']['fdoServiceVersion']
        assert fdo_service_version.split('-')[0].replace('.', '').isnumeric()
