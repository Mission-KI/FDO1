#!/bin/sh


cd /opt/cordra/data/webapps-temp/*cordra.war*.dir/webapp/WEB-INF/

java -cp tools/*:classes/*:lib/* net.cnri/cordra/util/cmdline/SchemaImporter -b https://localhost:8443 -u admin -j /opt/cordra/schema/FDO.js -s /opt/cordra/schema/FDO.json -n FDO --password cordra
java -cp tools/*:classes/*:lib/* net.cnri/cordra/util/cmdline/SchemaImporter -b https://localhost:8443 -u admin -j /opt/cordra/schema/Document.js -s /opt/cordra/schema/Document.json -n Document --update --password cordra
