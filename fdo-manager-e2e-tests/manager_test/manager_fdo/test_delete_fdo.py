"""Tests for /fdo delete calls"""

import json
import datetime
from pathlib import Path
from http import HTTPStatus
import pytest
import requests

import fdo_manager_service_api_client.types as client_types
from fdo_manager_service_api_client import Client
from fdo_manager_service_api_client.api.fd_os import base_delete
from fdo_manager_service_api_client.api.repositories import list_repositories

from ..service_index import services_to_test_changes as services
from ..test_utils.utils import created_fdos, purged_fdos, root_dir
from ..test_utils.assertions import check_timeout
from ..manager_repository.test_list_repositories \
    import PATH_LOCAL as PATH_LISTREPO
from ..manager_fdo.test_create_fdo \
    import PATH_LOCAL_CHECKS as PATH_CREATE_CHECKS
from ..manager_fdo.test_resolve_pid \
    import PATH_LOCAL as PATH_RESOLVE
from ..manager_logging.test_list_log_events \
    import PATH_LOCAL as PATH_LOGGING

PATH_FILE = str(Path(__file__).relative_to(root_dir))
PATH_LOCAL_PURGE = PATH_FILE + "::TestClassPurgeFDO::"


@pytest.mark.order(after=[
    f"{PATH_CREATE_CHECKS}test_create_fdo_outside_systems_check",
    f"{PATH_RESOLVE}test_http_resolve_fdo",
    f"{PATH_RESOLVE}test_client_resolve_fdo",
    f"{PATH_LOGGING}test_http_log_createfdo"])
class TestClassPurgeFDO:                           # pylint: disable=fixme
    """Basic Tests for /fdo delete calls with purge=true"""
    # ToDo: DeleteFDO on everything, then check, logs, then purge all etc.,
    #       create -> create check -> delete -> delete check -> purge

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LISTREPO}test_http_repositories[{service["url"]}]'])])
        for service in services])
    def test_http_purge_fdo(self, url: str):
        """Tests purge of a fdo with a delete request to /fdo/... with
        purge=true. Deletes some of the fdos saved in created_fdos[<service>].

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        if url not in created_fdos or len(created_fdos[url]) == 0:
            pytest.skip("Cannot test purge - Nothing to delete.")
        if url not in purged_fdos:
            purged_fdos[url] = []
        # delete a fdo in every available repository
        response = requests.get(url + "/repositories", timeout=10)
        repositories = json.loads(response.content.decode())['data']
        if len(repositories) == 0:
            pytest.skip("Cannot purge an FDO without repository.")
        for repo in repositories:
            local_fdos = filter(lambda x, rid=repo['id']: x['repo'] == rid,
                                created_fdos[url])
            for fdo in list(local_fdos)[::2]:
                query_time = datetime.datetime.now(datetime.timezone.utc)
                response = requests.delete(f"{fdo['url']}?purge=true",
                                           timeout=10)
                return_time = datetime.datetime.now(datetime.timezone.utc)
                self.assertions_helper(response, query_time, return_time)
                purged_fdos[url].append(fdo)
                created_fdos[url].remove(fdo)

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL_PURGE}test_http_purge_fdo[{service["url"]}]',
            f'{PATH_LISTREPO}test_client_repositories[{service["url"]}]'])])
        for service in services])
    def test_client_purge_fdo(self, url: str):
        """Tests purge of a fdo with an unauthenticated client.
        Deletes some of the fdos saved in created_fdos[<service>].

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        if url not in created_fdos or len(created_fdos[url]) == 0:
            pytest.skip("Cannot test purge - Nothing to delete.")
        # delete a fdo in every available repository
        with Client(base_url=url) as client:
            response = list_repositories.sync_detailed(client=client)
            repositories = json.loads(response.content.decode())['data']
            if len(repositories) == 0:
                pytest.skip("Cannot purge an FDO without repository.")
            for repo in repositories:
                local_fdos = filter(lambda x, rid=repo['id']: x['repo'] == rid,
                                    created_fdos[url])
                for fdo in list(local_fdos):
                    pid = fdo['url'].split(f'{url}/fdo/')[1]
                    prefix, suffix = pid.split('/')
                    query_time = datetime.datetime.now(datetime.timezone.utc)
                    response = base_delete.sync_detailed(client=client,
                                                         prefix=prefix, suffix=suffix, purge=True)
                    return_time = datetime.datetime.now(datetime.timezone.utc)
                    self.assertions_helper(response, query_time, return_time)
                    purged_fdos[url].append(fdo)
                    created_fdos[url].remove(fdo)

    @pytest.mark.parametrize("url", [pytest.param(service["url"], marks=[
        pytest.mark.dependency(scope='session', depends=[
            f'{PATH_LOCAL_PURGE}test_client_purge_fdo[{service["url"]}]'])])
        for service in services])
    def test_client_purge_unknown_fdo(self, url: str):
        """Tests purge of a nonexistent fdo.

        Parameters
        ----------
        url : str
              URL of the service to be tested without trailing slash,
              for example "https://manager.testbed.pid.gwdg.de/api/v1"
        """
        with Client(base_url=url) as client:
            prefix, suffix = "invalid.prefix", "ThisIsNotASuffix145670935"
            query_time = datetime.datetime.now(datetime.timezone.utc)
            response = base_delete.sync_detailed(client=client, prefix=prefix,
                                                 suffix=suffix, purge=True)
            return_time = datetime.datetime.now(datetime.timezone.utc)
            # Correct Error
            assert response.status_code == HTTPStatus.NOT_FOUND
            # Answer within one second
            check_timeout(query_time, return_time, response.headers['date'])

    def assertions_helper(self,
                          response: requests.Response | client_types.Response,
                          query_time: datetime.datetime,
                          return_time: datetime.datetime):
        """Asserts correct behaviour of /fdo purge calls.
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
        assert response.status_code == HTTPStatus.NO_CONTENT
        # Answer within one second
        check_timeout(query_time, return_time, response.headers['date'], 10)


@pytest.mark.order(after=["TestClassPurgeFDO"])
class TestClassPurgeFDOChecks:                        # pylint: disable=fixme
    """Tests whether FDO purge is reflected in outside systems"""

    @pytest.mark.parametrize("service", [pytest.param(service, marks=[
        pytest.mark.dependency(scope='session', depends=[])])
        for service in services])
    def test_purge_fdo_outside_systems_check(self, service: dict):
        """Tests successful purge of a fdo by checking directly with
        the repo and handle systems if possible.

        Parameters
        ----------
        service:    dict
                    Dictionary containing info of the service to be tested,
                    including url and information about available repos.
        """
        if service['url'] not in purged_fdos:
            pytest.skip('Cannot check FDOs if none have been purged.')
        any_checks_made = False
        for fdo in purged_fdos[service['url']]:
            repo = service["repos"][fdo['repo']]
            pid = fdo['url'].split(f"{service['url']}/fdo/")[1]
            # If possible, check with repo
            if "retrieve" in repo["links"] and repo["links"]["retrieve"]:
                api_config = repo["links"]["retrieve"]
                match api_config["api_version"]:
                    case "Cordra-V1":
                        url = api_config["url"]
                        response = requests.get(url, params={"targetId": pid},
                                                timeout=10)
                        assert response.status_code == HTTPStatus.NOT_FOUND
                        any_checks_made = True
            # If possible, check with handle system
            if "handle" in repo["links"] and repo["links"]["handle"] != "":
                # Handle system API lags for minutes - have to check
                # against frontend instead
                url = repo["links"]["handle"]["url"]
                response = requests.get(f'{url}{pid}?auth', timeout=10)
                assert response.status_code == HTTPStatus.NOT_FOUND
                any_checks_made = True
                if 'data' in fdo:
                    response = requests.get(f'{url}{fdo["data"]}?auth', timeout=10)
                    assert response.status_code == HTTPStatus.NOT_FOUND
                if 'metadata' in fdo:
                    response = requests.get(
                        f'{url}{fdo["metadata"]}?auth', timeout=10)
                    assert response.status_code == HTTPStatus.NOT_FOUND
        if not any_checks_made:
            pytest.skip('No checks with outside systems were possible.')
