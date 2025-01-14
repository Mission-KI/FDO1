#!/bin/sh
cd /var/log/nginx/

mv access.log.0 access.log.1
mv access.log access.log.0
kill -USR1 `cat /var/run/nginx.pid`
sleep 1
