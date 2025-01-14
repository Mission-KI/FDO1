#!/bin/sh

# Settings
dir_name="temp_dir"
default_api_url="https://gitlab.indiscale.com/fdo/fdo-manager-service/-/raw/main/api/src/main/resources/api.yaml"

# Check openapi-python-client and install if necessary
if [ -z "$(which openapi-python-client)" ]; then
  echo 'openapi-python-client not found, installing'
  pip install openapi-python-client
fi

# Create temporary folder
if [ -d "$dir_name" ]
then
  echo 'Temporary folder already exists, aborting.'
  exit 0
else
  echo 'creating temporary folder'
  mkdir $dir_name
fi

# Generate client code
# Uses local path if specified, otherwise specified url. Fallback is api.yaml in the gitlab project main branch.
if [ -n "$API_CLIENT_PATH" ]; then
  echo 'generating python client code from path specified by environment variable'
  openapi-python-client generate \
  --path "$API_CLIENT_PATH" \
  --output-path "$dir_name/client_code"
elif [ -n "$API_CLIENT_URL" ]; then
  echo 'generating python client code from url specified by environment variable'
  openapi-python-client generate \
  --url "$API_CLIENT_URL" \
  --output-path "$dir_name/client_code"
else
  echo 'generating python client code from default url'
  openapi-python-client generate \
  --url $default_api_url \
  --output-path "$dir_name/client_code"
fi

# Install client as library
echo 'installing python client'
pip install "$dir_name/client_code/"

# Cleanup
echo 'starting cleanup'
rm -r $dir_name
echo 'Finished.'
