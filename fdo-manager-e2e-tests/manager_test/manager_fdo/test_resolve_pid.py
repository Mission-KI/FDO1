"""Tests for /fdo/prefix/suffix"""

import datetime
import json
from pathlib import Path
from http import HTTPStatus
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.fd_os import resolve_pid
from ..service_index import services_to_test as services
from ..test_utils.utils import created_fdos, root_dir
from ..test_utils.assertions import check_timeout, check_response
from ..manager_fdo.test_create_fdo import PATH_LOCAL as PATH_CREATEFDO

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL = PATH_FILE + "::TestClassResolvePID::"


@pytest.mark.order(after=[f"{PATH_CREATEFDO}test_http_create_fdo",
                          f"{PATH_CREATEFDO}test_client_create_fdo"])
class TestClassResolvePID:
    """Basic Tests for /fdo/prefix/suffix"""

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_resolve_fdo(self, url: str):
        """Tests fdo/prefix/id with a get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        if url not in created_fdos:
            pytest.skip('Cannot check FDOs if none have been created.')
        for created_fdo in created_fdos[url]:
            assert created_fdo['url'].startswith(f'{url}/fdo/'), \
                "Url of created FDO is in wrong repository"
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = requests.get(created_fdo['url'], timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            # Add dataPid, metadataPid to fdo entry
            content = json.loads(response.content.decode())
            if content['data']['dataPid'] is not None:
                created_fdo['data'] = content['data']['dataPid']
            if content['data']['metadataPid'] is not None:
                created_fdo['metadata'] = content['data']['metadataPid']
            # Check correct response
            self.assertions_helper(response, query_time, return_time,
                                   created_fdo['repo'], created_fdo['url'])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_http_resolve_fdo_unknown_request(self, url: str):
        """Tests fdo/prefix/id with an invalid get request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        invalid_id = "ThisIsNotASuffix145670935"
        query_time = datetime.datetime.now(datetime.timezone.utc)
        response = requests.get(f'{url}/fdo/invalid.prefix/{invalid_id}',
                                timeout=10)
        return_time = datetime.datetime.now(datetime.timezone.utc)
        # Correct error
        assert response.status_code == HTTPStatus.NOT_FOUND
        # Answer within one second
        check_timeout(query_time, return_time, response.headers['date'])

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_resolve_fdo[{service["url"]}]'])])
        for service in services])
    def test_client_resolve_fdo(self, url: str):
        """Tests fdo/prefix/id with an unauthenticated client.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            for created_fdo in created_fdos[url]:
                pid = created_fdo['url'].split(f'{url}/fdo/')[1]
                prefix, suffix = pid.split('/')
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = resolve_pid.sync_detailed(prefix, suffix,
                                                     client=client)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                self.assertions_helper(response, query_time, return_time,
                                       created_fdo['repo'], created_fdo['url'])

    @pytest.mark.xfail(
        reason="Server returns 500 instead of 404 for unknown fdo pid")
    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL}test_http_resolve_fdo_unknown_request[{service["url"]}]'])])
        for service in services])
    def test_client_resolve_fdo_unknown_request(self, url: str):
        """Tests fdo/prefix/id with an unauthenticated client
        with an invalid request.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            for created_fdo in created_fdos[url]:
                invalid_id = "ThisIsNotASuffix145670935"
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = resolve_pid.sync_detailed('invalid.prefix/',
                                                     invalid_id, client=client)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                self.assertions_helper(response, query_time, return_time,
                                       created_fdo['repo'], created_fdo['url'])
                # Correct error
                assert response.status_code == HTTPStatus.NOT_FOUND
                # Answer within one second
                check_timeout(query_time, return_time,
                              response.headers['date'])

    # pylint: disable=too-many-arguments
    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime,
                          repo: str, url: str):
        """Asserts correct behaviour of fdo/prefix/id. This includes response
        code, content and reasonable response time.

        Parameters
        ----------
        response    : requests.Response | fdo_[...]_client.types.Response
                      Response from the /fdo/prefix/id request.
        query_time  : datetime.datetime
                      Time from before the request to /fdo/prefix/id was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        return_time : datetime.datetime
                      Time from after the request to /fdo/prefix/id was sent,
                      using datetime.datetime.now(datetime.timezone.utc)
        repo        : string
                      ID of the repo the current FDO is saved in.
        url         : string
                      URL of the endpoint under test, for example
                      "https://manager.testbed.pid.gwdg.de/api/v1/fdo/21.T11965/6bf05391-974d-41e0-974b-7512ac3af8b2"
        """                                    # pylint: disable=line-too-long
        content = check_response(response, query_time, return_time)
        # Correct content
        self.assertions_content(content, repo, url)

    def assertions_content(self, content: dict, repo: str, url: str):
        """Asserts correct content of fdo/prefix/id response.

        Parameters
        ----------
        content     : dict
                      Content from the /fdo/prefix/id request response.
        repo        : string
                      ID of the repo the current FDO is saved in.
        url         : string
                      URL of the endpoint under test,
                      for example "https://manager.testbed.pid.gwdg.de/api/v1/fdo/21.T11965/6bf05391-974d-41e0-974b-7512ac3af8b2"
        """                                    # pylint: disable=line-too-long
        for key in ['data', 'links']:
            assert key in content
        for key in ['pid', 'isFdo', 'dataPid', 'metadataPid']:
            assert key in content['data']
        for key in ['self', 'collection']:
            assert key in content['links']
        assert '/' in content['data']['pid']
        assert url.endswith(content['data']['pid'])
        assert content['data']['isFdo'] in [True, False]
        if content['data']['isFdo']:
            # FDO has to have data and metadata
            assert content['data']['dataPid'] is not None
            assert content['data']['metadataPid'] is not None
            base_url = url.split('/fdo/')[0] + '/fdo/'
            data_url = base_url + content['data']['dataPid']
            metadata_url = base_url + content['data']['metadataPid']
            query_time = datetime.datetime.now(datetime.timezone.utc)
            data_response = requests.get(data_url, timeout=10)
            metadata_response = requests.get(metadata_url, timeout=10)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            # Check data and metadata entries for correct content
            data_content = check_response(data_response,
                                          query_time, return_time)
            metadata_content = check_response(metadata_response,
                                              query_time, return_time)
            self.assertions_content(data_content, repo, data_url)
            self.assertions_content(metadata_content, repo, metadata_url)
        assert content['links']['self'] == url
