#!/bin/sh

echo -n $'{"targetId": "TEST/linkahead", "operationId": "0.DOIP/Op.Hello"}\n#\n' | timeout 5 openssl s_client -ign_eof -connect local-fdo-testbed-linkahead-1:8888 2>/dev/null | grep "0.TYPE/DOIPServiceInfo" | sed -e "s/^{[^{]*//" -e "s/}$//" > /hs/linkahead.serviceinfo.json
