"""Commonly needed asserts"""

import os
import json
import datetime
from http import HTTPStatus
import requests

import fdo_manager_service_api_client.types as client_types
from ..test_utils import utils

DEFAULT_TIMEOUT = int(os.environ.get("DEFAULT_TIMEOUT", "5"))


def check_timeout(query_time: datetime.datetime | str,
                  return_time: datetime.datetime | str,
                  response_time: datetime.datetime | str | None = None,
                  timeout: float | int = DEFAULT_TIMEOUT):
    """
    Given a timeout in seconds as well as query and return times, checks that
    the time elapsed between query and return does not exceed the given timeout.
    If the optional response time is supplied, also checks that it lies between
    query and return time.

    Any times supplied as string are parsed using str_to_time(). Fails if
    query_time or return_time format cannot be parsed. If response time format
    cannot be parsed, response time is not checked.

    Query and return times are re-ordered based on which one is first, so calls
    of check_return_time(query_time, return_time) and (return_time, query_time)
    return the same result.

    Parameters
    ----------
    query_time      : datetime.datetime | str
                      Time directly before the query was sent, for example
                      using datetime.datetime.now(datetime.timezone.utc).
    return_time     : datetime.datetime | str
                      Time directly after the query returned, for example
                      using datetime.datetime.now(datetime.timezone.utc).
    response_time   : datetime.datetime | str | None, optional -> None
                      Time parsed from the query response.
    timeout         : int | float, optional -> one second
                      Maximum allowed time between query and return in seconds.
    """
    # Parse strings
    if isinstance(query_time, str):
        query_time = utils.str_to_time(query_time)
        assert query_time is not None, "Could not parse query_time"
    if isinstance(return_time, str):
        return_time = utils.str_to_time(return_time)
        assert return_time is not None, "Could not parse return_time"
    if isinstance(response_time, str):
        response_time = utils.str_to_time(response_time)
    # Check whether needed time was within timeout length
    time_delta = return_time - query_time
    assert abs(time_delta.total_seconds()) < timeout, "Timeout exceeded."
    # Ensure realistic response time - response cannot come before call
    if response_time is not None:
        # Check whether the times are in correct order, and delete the
        # microseconds from the first time as the response_time does not
        # always contain microseconds - ex.: 12:46:00:514 -> 12:46:00, but
        # 12:46:00:112 <= 12:46:00:514 while 12:46:00:112 > 12:46:00
        before_time = min(query_time, response_time).replace(microsecond=0)
        after_time = max(query_time, response_time)
        assert before_time <= response_time <= after_time


def check_response(response: requests.Response | client_types.Response,
                   query_time: datetime.datetime,
                   return_time: datetime.datetime) -> dict:
    """
    Asserts that response code is 200, response was within 1 second and
    returns the parsed content of the response.

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

    Returns
    -------
    content     : dict
                  Parsed content of the given response object
    """
    # No errors
    assert response.status_code == HTTPStatus.OK
    # Answer within one second
    check_timeout(query_time, return_time,
                  response.headers.get('date', None))
    # Parse content
    return json.loads(response.content.decode())
