#!/bin/sh

export API_CLIENT_PATH=./fdo-local-testbed/fdo-manager/fdo-manager-service/api/src/main/resources/api.yaml
./install_python_client.sh
pip install -r requirements.txt
pytest --order-dependencies -vv
