"""Configures against which manager services the tests are run"""

import os

# Register known manager services
localhost = {
    "url": os.environ.get("FDO_MANAGER_LOCALHOST",    # Default port is 8081
                          "http://localhost:8081/api/v1"),
    "auth": None,
    "attributes": ['test', 'local'],
    "repos": {"mock-repo-1": {"auth": None,
                              "attributes": [],
                              "links": {}},
              "mock-repo-2": {"auth": None,
                              "attributes": [],
                              "links": {}},
              "mock-repo-3": {"auth": None,
                              "attributes": [],
                              "links": {}},
              "Linkahead":   {"auth": ('', ''),
                              "attributes": ['persistent'],
                              "links": {"handle": {"url":
                                                   "http://172.27.0.2:8000/api/handles/"}}},
              "Cordra":      {"auth": ('', ''),
                              "attributes": ['persistent'],
                              "links": {
                                  "retrieve": {
                                      "url": "http://172.27.0.1:8082/cordra/doip/0.DOIP/Op.Retrieve",
                                      "api_version": "Cordra-V1"},
                                  "handle": {
                                      "url": "http://172.27.0.2:8000/api/handles/"}}}}
}
gwdg_testbed = {
    "url": "https://manager.testbed.pid.gwdg.de/api/v1",
    "attributes": ['test', 'remote', 'persistent'],
    "repos": {"Linkahead":   {"auth": ('', ''),
                              "attributes": ['persistent'],
                              "links": {}},
              "Cordra":      {"auth": ('', ''),
                              "attributes": ['persistent'],
                              "links": {"retrieve": "https://cordra.testbed.pid.gwdg.de/cordra/doip/0.DOIP/Op.Retrieve",  # pylint: disable=line-too-long
                                        "handle": "https://hdl.handle.net/api/handles/"}}}
}

# Aggregate into list & filter for valid
services = [service for service in [localhost,
                                    gwdg_testbed] if service["url"] is not None]

# Select according to criteria
services_to_test = [
    service for service in services if "local" in service["attributes"]]
# exchange the following lines if you want to include the gwdg_testbed servers
# as well:
# services_to_test_changes = services
services_to_test_changes = [
    service for service in services if "persistent" not in service["attributes"]]
