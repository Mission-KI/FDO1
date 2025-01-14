#!/bin/sh

SRV_DIR=/hs/srv_1

# ### Copy configuration and empty database ###
if [ ! -e "${SRV_DIR}/config.dct" ] ; then
    cp -r /hs/templates/* "${SRV_DIR}"
fi

# ### Update configuration ###
# update config.dct
sed "s/HANDLE_SERVER_IPV4_ADDRESS/${HANDLE_SERVER_IPV4_ADDRESS}/g" /hs/templates/config.dct > "$SRV_DIR/config.dct"

# update siteinfo.json
sed "s/HANDLE_SERVER_IPV4_ADDRESS/${HANDLE_SERVER_IPV4_ADDRESS}/g" /hs/templates/siteinfo.json > "$SRV_DIR/siteinfo.json"

# update batch file
sed "s/HANDLE_SERVER_IPV4_ADDRESS/${HANDLE_SERVER_IPV4_ADDRESS}/g" /hs/templates/setup.batch.hdl > "/hs/setup.batch.hdl"

# ### Configure private handle network ###
mkdir -p /root/.handle
sed "s/HANDLE_SERVER_IPV4_ADDRESS/${HANDLE_SERVER_IPV4_ADDRESS}/g" /hs/templates/bootstrap_handles > /root/.handle/bootstrap_handles
echo '{' > /root/.handle/config.dct
echo '"auto_update_root_info" = "no"' >> /root/.handle/config.dct
echo '}' >> /root/.handle/config.dct

# actually run the server
bin/hdl-server "$SRV_DIR"
