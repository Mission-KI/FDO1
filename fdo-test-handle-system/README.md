# Private HANDLE.NET Server for Testing Purposes

This repository builds a HANDLE.NET server inside a docker container. The
server is configured to create a private handle network using a single Prefix,
"0.TEST".

This repository also contains a private keys for the 0.TEST/ADMIN handle and
more data which should never be public under normal circumstances. However,
this setup is intended for **testing purposes only**. In other words:

**DO NOT USE THIS IN PRODUCTION!**

## Run the HANDLE.NET server

```
docker compose up --build
```

## Test Web-based Handle Resolution

Open `https://172.28.0.2:8000` in your browser. You should see the HANDLE.NET
landing page where you can resolve a handle.


## Test Web-based Admin Tool

Open "https://172.28.0.2:8000/admin to see the admin tool.

### Authenticate

* Click `Authenticate` (top right). A form opens up.
* Uncheck `Get ID from Global`
* Insert fields:
    * Index: 300
    * Handle: 0.TEST/ADMIN
* Click `Select private key` and select the `handle_server/templates/admpriv.bin` file.
* Click `Authenticate` at the bottom of the form.

Now you can use the `Tools` from the menu to do stuff.

## Configure Your Client to Use the Private Network

This is known to work for clients based on the handle.net java-library version
>=9.3.1.

During start-up, the docker container outputs two configuration files to the
`.handle` directory. The files can be used to configure a java-based handle
client and override the default behaviour which would connect the clients to
the global handle system.

* The `resolver_site`. Handle clients use this file to build a local (non-default) resolver.
* The `local_nas` file is used by the java client to determine which handles
  are to be resolved with the locally defined resolver.

### Option 1 (recommended)

```
export JAVA_TOOL_OPTIONS="-Dnet.handle.configDir=${PATH_TO}/.handle"
```

You can just configure the client by passing the java system property
"net.handle.configDir" pointing to the `.handle` directory by path. This can be achieved by passing
`-Dnet.handle.configDir=${PATH_TO}/.handle` to the java executable or by exporting it they way shown above.

### Option 2

Copy the whole `.handle` directory to `$HOME/.handle`. Warning: This will
configure ALL handle clients running under your user account to use the private
handle network.

## Change IP Address of the Server

By default, the IP address of the server is configured to be `172.28.0.2`. The
server is only available in from your host machine because docker is creating
the network for you that way.

Should there be a problem, e.g. the address range is also used by your LAN or
by other docker networks, you can change the `.env` file. E.g. try `172.27`
instead of `172.28`.

Note: If you have started the server in the past you might need to remove the
docker network by hand before you can start the server with the new
IP address configuration: `docker network rm test-handle-net_hs_network`

## Wipe Database

You can remove all persistent data by removing the container and the volume:

1. `docker container rm test-handle-net_hs_server-1`
2. `docker volume rm test-handle-net_hs_srv1`

## Licence

(C) 2024 by Timm C. Fitschen (t.fitschen@indiscale.com) is licensed under CC BY 4.0
