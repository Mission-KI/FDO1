# FDO-DOIP-B2SHARE-adapter

This is a DOIP-adapter for B2SHARE, which enables it to support FDO operations.

## Usage

The adapter is already dockerized. To use it, simply take the [`docker-compose.yml`](docker-compose.yml) file and use it
directly or adapt it to your need. To start the adapter, run:

```shell
$ docker compose up --detach
```

To stop the adapter, run:

```shell
$ docker compose down
```

## For developer

This project is managed by [Poetry][1]. Please make sure that you have Poetry installed on your machine. Then, clone
this project and install its dependencies using the commands:

```shell
# Clone the project
$ git clone git@gitlab.gwdg.de:fdo-testbed-2024/fdo-doip-b2share-adapter.git

# Navigate into the project root directory
$ cd fdo-doip-b2share-adapter

# Install dependencies
$ poetry install
```

[1]: https://python-poetry.org/
