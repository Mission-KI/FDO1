"""Utility functions and variables"""

from pathlib import Path
import os
import datetime
import email.utils

# Package root directory
root_dir = Path(os.path.dirname(os.path.abspath(__file__))).parent.parent

# Makes information on fdos created in this run available to other tests
created_fdos = {}
purged_fdos = {}


def str_to_time(time_str: str) -> datetime.datetime | None:
    """
    Takes a string containing a time representation in an unknown format
    and tries to parse it using a number of supported formats. Returns None
    if the contained time format cannot be parsed.
    Returned datetime is always timezone-aware.

    This function is intended to be used when the format of a time string
    returned by a server is unknown.

    Parameters
    ----------
    time_str    : str
                  Time string in a supported format.
                  Supported formats: RFC 2822: '%a, %d %b %Y %H:%M:%S',
                                     for example "Fri, 28 May 2021 10:17:15"
                                     ISO 8601:
                                     for example "2024-03-19T12:13:44.181"
                                     RFC 3339: '%Y-%m-%dT%H:%M:%S.%fZ',
                                     for example "2024-08-20T10:31:54.16Z"

    Returns
    -------
    time_obj    : datetime.datetime | None
                  Datetime object representing the time in the input string.
                  Returns None if format or timezone not supported.
    """
    # RFC 2822:   "Fri, 28 May 2021 10:17:15 GMT"
    try:
        # Note: parsedate_to_datetime uses RFC 2822 according to documentation,
        #       current version is RFC 5322.
        parsed_time = email.utils.parsedate_to_datetime(time_str)
        # If no timezone is set, set to UTC
        if parsed_time.tzinfo is None:
            parsed_time = parsed_time.replace(tzinfo=datetime.timezone.utc)
        return parsed_time
    except Exception:                 # pylint: disable=broad-exception-caught
        pass  # Not the correct format, try next

    # ISO 8601:    "2024-03-19T12:13:44.16Z"
    try:
        parsed_time = datetime.datetime.fromisoformat(time_str)
        if parsed_time.tzinfo is None:
            parsed_time = parsed_time.replace(tzinfo=datetime.timezone.utc)
        return parsed_time
    except Exception:                 # pylint: disable=broad-exception-caught
        pass
    try:
        # fromisoformat does not always parse RFC 3339 strings in python
        # versions <=3.10 successfully, this is a workaround for these errors
        parsed_time = datetime.datetime.strptime(
            time_str, '%Y-%m-%dT%H:%M:%S.%fZ')
        if parsed_time.tzinfo is None:
            parsed_time = parsed_time.replace(tzinfo=datetime.timezone.utc)
        return parsed_time
    except Exception:                 # pylint: disable=broad-exception-caught
        pass

    # No valid parse:
    return None
