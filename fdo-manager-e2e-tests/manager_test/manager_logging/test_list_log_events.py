"""Tests for /logging"""

import json
import datetime
from pathlib import Path
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.logging import list_log_events

from ..service_index import services_to_test as services
from ..test_utils.utils import created_fdos, purged_fdos, root_dir
from ..test_utils.assertions import check_timeout, check_response
from ..manager_fdo.test_create_fdo import PATH_LOCAL as PATH_CREATEFDO
from ..manager_fdo.test_resolve_pid import PATH_LOCAL as PATH_RESOLVEFDO
# from ..manager_fdo.test_delete_fdo import PATH_LOCAL_PURGE as PATH_PURGEFDO
# ToDo: Workaround for circular import, fix             pylint: disable=fixme
PATH_PURGEFDO = \
    "manager_test/manager_fdo/test_delete_fdo.py::TestClassPurgeFDO::"

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassLogEvents::"


class TestClassLogEvents:
    """Basic Tests for /logging"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_log(self, url: str):
        """Tests basic logging entries with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(url + "/logging", timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        self.assertions_helper(response, query_time, return_time)

    @pytest.mark.xfail(
        reason="Python Client crashes on link dicts that are none/null")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_log[{service["url"]}]'])])
        for service in services])
    def test_client_log(self, url: str):
        """Tests basic logging entries with an unauthenticated client
        by matching with already tested results.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response_http = requests.get(url + "/logging", timeout=10)
        with Client(base_url=url) as client:
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = list_log_events.sync_detailed(client=client)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            self.assertions_helper(response, query_time, return_time)
            # Ensure that the log returned by client matches the log returned
            # by http - already checked, so this doubles as content check
            assert json.loads(response.content.decode()) == \
                json.loads(response_http.content.decode()), \
                "Logs returned by client and http methods do not match"

    @pytest.mark.order(after=[f"{PATH_RESOLVEFDO}test_http_resolve_fdo"
                              f"{PATH_CREATEFDO}test_http_create_fdo",
                              f"{PATH_CREATEFDO}test_client_create_fdo"])
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_log_createfdo(self, url: str):
        """Tests logging entries for created fdos with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(url + "/logging", timeout=10)
        if url not in created_fdos:
            pytest.skip('Cannot check FDOs if none have been created.')
        for created_fdo in created_fdos[url]:
            self.assertions_fdo_logs(response, created_fdo)

    @pytest.mark.order(after=[f"{PATH_RESOLVEFDO}test_http_resolve_fdo"
                              f"{PATH_PURGEFDO}test_http_purge_fdo",
                              f"{PATH_PURGEFDO}test_client_purge_fdo"])
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_log_purgefdo(self, url: str):
        """Tests logging entries for purged fdos with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        response = requests.get(url + "/logging", timeout=10)
        if url not in purged_fdos:
            pytest.skip('Cannot check FDO purge if none have been purged.')
        for purged_fdo in purged_fdos[url]:
            self.assertions_purge_logs(response, purged_fdo)

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime):
        """Asserts correct basic behaviour of /logging.
        This includes response code and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /logging request.
        query_time  : datetime.datetime
                      Time from just before the request to /logging was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from just after the request to /logging was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        """
        content = check_response(response, query_time, return_time)
        # Check content
        assert 'data' in content
        for logentry in content['data']:
            for key in ['id', 'type', 'attributes']:
                assert key in logentry
            for key in ['operation', 'timestamp']:
                assert key in logentry['attributes']

    def assertions_fdo_logs(self,
                            response: requests.Response | client_types.Response,
                            created_fdo: dict):
        """Asserts for a given created fdo that a corresponding
        correct entry is in the log.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /logging request.
        created_fdo : dict
                      Dictionary containing information obtained during the
                      creation of FDOs. Includes FDO repo, url and creation time
                      and should be saved to test_utils.created_fdos by the test
                      that created the object.
        """
        content = json.loads(response.content.decode())
        for logentry in content['data']:
            attributes = logentry['attributes']
            # Check all create entries for one that matches the created FDO
            if 'create' in attributes['operation'].lower() \
                    and created_fdo['url'].endswith(attributes['fdo']['pid']):
                response = requests.get(created_fdo['url'], timeout=10)
                created_fdo_content = json.loads(response.content.decode())
                check_timeout(attributes['timestamp'], created_fdo['time'],
                              timeout=5)
                assert created_fdo_content['data'] == attributes['fdo'], \
                    "Log entry content does not match created FDO"
                assert attributes['repositories']['fdo'] == created_fdo['repo']
                return
        pytest.fail("No corresponding log entry found")

    def assertions_purge_logs(self,
                              response: requests.Response | client_types.Response,
                              created_fdo: dict):
        """Asserts for a given created fdo that a corresponding
        correct entry is in the log.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /logging request.
        created_fdo : dict
                      Dictionary containing information obtained during the
                      creation of FDOs. Includes FDO repo, url and creation time
                      and should be saved to test_utils.created_fdos by the test
                      that created the object.
        """
        content = json.loads(response.content.decode())
        for logentry in content['data']:
            attributes = logentry['attributes']
            # Check all create entries for one that matches the purged FDO
            if 'delete' in attributes['operation'].lower() \
                    and created_fdo['url'].endswith(attributes['fdo']['pid']):
                assert attributes['repositories']['fdo'] == created_fdo['repo']
                fdo_data = attributes['fdo']
                if 'data' in created_fdo:
                    assert fdo_data['dataPid'] == created_fdo['data']
                if 'metadata' in created_fdo:
                    assert fdo_data['metadataPid'] == created_fdo['metadata']
                return
        pytest.fail("No corresponding log entry found")
