# Repositories

You can define your repositories in this directory. Do so by putting `*.json`
files into this directory containing the repository's details, e.g

```json
{
  "type": "DOIP",
  "id": "linkahead",
  "attributes": {
    "typeDo": "0.TYPE/DO",
    "typeFdo": "21.T11969/FDO_TYPE",
    "typeDataRef": "21.T11969/867134e94b3ec5afc6fe",
    "typeMDRef": "21.T11969/a02253b264a9f2f1cf9a",
    "host": "localhost",
    "port": "8888",
    "serviceId": "Unknown",
    "publicKey": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmhq6sx/A430Fd8YgOcL4coD2mmcIgh1UroTjY+Z87QadCKnDlTrat8wDGTH+MJzRorT+RyKv/2gEyxTO9R1Kp9ARkNWasWIh/gLuQkFxbTWAEKLzOnNnl9MP7Cupapm//Pi7u5O1KHPVZ2cMh0sYloHOM/i0RZ6/yBIBkhgz0S1UeHb4CNF7rPVxXwnCDK6WhWzhwp/SqSXyoQ7qnX6DunECuX0HJ9HJ0NbJqFRlXnA8U6EbOlfQWpaUFxzKGi6+DpQNeLKUAFhkrau5AnP93GagYG72uwGBLQpu1QxPyQSTfGpyCQHER9kqeI6Yg/WszsAXEEdlVgCj/IcKSqnk6QIDAQAB"
  }
}
```

You can change the repository by setting the `repositoriesDir` java property at
start up (e.g. with 

```shell
java -DrepositoriesDir="/path/to/repositoriesDir" -jar fdo-manager-service.jar`
```

