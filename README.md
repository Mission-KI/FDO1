# FDO1 - Fair Digital Objects for Data Spaces

Implementation of Fair Digital Objects (FDOs) for standardized data exchange between data spaces.

## Overview

This project develops an infrastructure for machine-readable (meta)data exchange based on FDO principles. 
For more information about the FDO concept, visit [FAIR Digital Objects](https://fairdo.org/).

### Key Features

* **Standardization**: Unified format for data and metadata
* **Interoperability**: Seamless exchange between different data spaces
* **Persistent Identification**: Legally traceable through PIDs
* **Integration**: Compatibility with Eclipse Dataspace Components (EDC)

> **Note**: Each component in this project has its own detailed README file. Please refer to the specific component's documentation for detailed information about setup, configuration, and usage.

## Module Structure

### Core Components

* **[fdo-manager-service](./fdo-manager-service)**: Core service for FDO management
* **[fdo-manager-sdk](./fdo-manager-sdk)**: SDK for FDO Manager integration
* **[fdo-manager-clients](./fdo-manager-clients)**: Client libraries
* **[fdo-doip-request-models](./fdo-doip-request-models)**: DOIP request models

### Adapters

* **[fdo-aas-adapter](./fdo-aas-adapter)**: Asset Administration Shell integration
* **[fdo-edc-adapter](./fdo-edc-adapter)**: Eclipse Dataspace Components connector
* **[fdo-doip-b2share-adapter](./fdo-doip-b2share-adapter)**: B2SHARE integration
* **[fdo-s3-doip-adapter](./fdo-s3-doip-adapter)**: S3 storage integration

### User Interface

* **[fdo-manager-webui](./fdo-manager-webui)**: Web-based management interface

### Testing & Development

* **[fdo-manager-e2e-tests](./fdo-manager-e2e-tests)**: End-to-end tests
* **[fdo-local-testbed](./fdo-local-testbed)**: Local test environment
* **[fdo-test-handle-system](./fdo-test-handle-system)**: Handle system tests
* **[fdo-testbed-jupyter-notebooks](./fdo-testbed-jupyter-notebooks)**: Jupyter notebooks for testing

### Deployment

* **[fdo-manager-deploy](./fdo-manager-deploy)**: Deployment configurations

## Installation

```bash
git clone https://github.com/Mission-KI/FDO1.git
cd FDO1
# Further installation instructions in respective module READMEs
```

## Benefits

* Simplified data exchange for enterprises
* Standardized FAIR metadata
* Legally compliant data management

## Development

See individual module READMEs for development details.

## FAIR Principles Implementation

* **Findable**: Unique and persistent identification
* **Accessible**: Secure access and exchange
* **Interoperable**: Cross-system compatibility
* **Reusable**: Sustainable data structuring

## License

This project is licensed under the MIT License.

## Contact

Git MISSION-KI <git-mission-ki@acatech.de>
