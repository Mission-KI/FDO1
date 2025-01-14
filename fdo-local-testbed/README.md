# Local FDO Testbed
The FDO Testbed, which was created in the FDO One project,  has several components
like repositories, handle nodes etc. In order to allow (automated) testing,
this repository code and configuration files and lets you create a local version of the testbed.

Currently this includes:

* A private/local PID/handle network, based on Handle.net
* A LinkAhead repository which is connected to the handle system with prefix `TEST`.
* A Cordra repository which is connected to the handle system with prefix `TEST.CORDRA`
* A FDO Manager Service which is configured to interact with both repositories.

Please refer to the `tutorial.md` to learn more about the components involved
in this testbed and how you can experiment with the testbed.
## Run the Testbed

### Prerequisites

* Pull/Update all submodules: `git submodule update --init --recursive` if you
* Install docker and GNU make.

### Start

* Run `make start`

### Stop

* Run `make stop`

### Usage

By default the services are available here:
- [LinkAhead](https://localhost:10443/)
- [Cordra](https://localhost:8443/)
- [Handle](http://172.27.0.2:8000/)
- [FDO Service](http://localhost:8081/api/v1/swagger-ui/index.html)

You can use the config files that are located in `fdo-manager/repositories`
(prefixed with a ".") when you want to connect to one of the repositories using
the fdo-manager-library.

### Help

* Run `make help` for a little help on the make targets.
* Run `make info` to print a list of urls for the services of this testbed.

# Contact

* (Lead) Timm Fitschen <t.fitschen@indiscale.com>

# License

LGPL 3.0 or later. <https://www.gnu.org/licenses/lgpl-3.0.en.html>

# Copyright

* Copyright (C) 2024 Timm Fitschen <t.fitschen@indiscale.com>
* Copyright (C) 2024 IndiScale GmbH <info@indiscale.com>









