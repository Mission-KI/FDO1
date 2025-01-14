"""Tests for /hello"""

import datetime
from pathlib import Path
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.info import hello
from ..service_index import services_to_test as services
from ..test_utils.utils import root_dir
from ..test_utils.assertions import check_response

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassHello::"


class TestClassHello:
    """Basic Tests for /hello"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_hello(self, url: str):
        """Tests hello with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(url + "/hello", timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        self.assertions_helper(response, query_time, return_time)

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_hello[{service["url"]}]'])])
        for service in services])
    def test_client_hello(self, url: str):
        """Tests hello with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = hello.sync_detailed(client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time)

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime):
        """Asserts correct behaviour of /hello.
        This includes response code, message and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /hello request.
        query_time  : datetime.datetime
                      Time from just before the request to /hello was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /hello was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        """
        content = check_response(response, query_time, return_time)
        # Correct content
        assert 'Hello' in content["message"]
