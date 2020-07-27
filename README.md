# Shmdoc PoC application

Shmdoc is a tool that allows for a combination of automated and human-supplied analysis and annotation of scientific datasets.
It was developed as a proof of concept application for [VLIZ](http://www.vliz.be/) during [Open Summer of Code](http://www.osoc.be) 2020.

## Overview
### Features

* Automated **analysis** of `.xml`, `.json` and `.csv` files.
* Human-supplied **annotation** of the unit of certain data through an easy-to-use **web interface**.
* Data stored as **triples** for linked-data/semantic analysis capabilities.
* Extensible microservices software stack based on the [**mu.semte.ch** framework](https://mu.semte.ch/).

### Architecture
Shmdoc is a microservices-based application, meaning that the different parts of the application are contained in different entities that can each have their own independent implementation and dependencies.
These contained entities are called microservices, and they communicate with each other via HTTP.

Shmdoc is built with the [mu.semte.ch framework](https://mu.semte.ch/) which means that microservices are contained in **Docker containers**.
Management of the different microservices is done with `docker-compose`.

### Overview of microservices
[Architecture][./shmdoc_arch.png]

Shmdoc consists of a few microservices; some were already available in the mu.semte.ch framework. Others were built specifically for shmdoc.
* [`db` ](https://github.com/tenforce/docker-virtuoso): the database is the heart of this application. The `db`-service is the central location for all data storage.
* [`migrations`](https://github.com/mu-semtech/mu-migrations-service): service to import existing databases in the `db` service. This service can for example be used to import existing vocabularies into the database (as is done for the units vocabulary in this proof of concept.)
* [`resources`](https://github.com/mu-semtech/mu-cl-resources): The resources service allows the database to be accessed by a JSON-API, as is done by the `frontend` service.
It is configured by `/config/resoures/domain.lisp`.
* [`file-service`](https://github.com/mu-semtech/file-service): The `file-service` allows for file upload and download from the `db`-service. This service is used to upload files for analysis in this proof of concept.
* [`identifier`](https://github.com/mu-semtech/mu-identifier): A HTTP proxy that identifies the user-agent and makes sure that all user-agents behave as expected. It basically makes sure that browsers play nice with the services.
* [`dispatcher`](https://github.com/mu-semtech/mu-dispatcher): The `dispatcher` service dispatches HTTP requests that are sent to the application. The service is configured in `config/dispatcher/dispatcher.ex` as stated [here](https://github.com/mu-semtech/mu-dispatcher#Configuration).

built for shmdoc:

* [`shmdoc-analyzer`](https://github.com/shmdoc/shmdoc-analyzer-service): service that fetches files from the `db` service for automatic analysis.
* [`frontend`](https://github.com/shmdoc/frontend-shmdoc-osoc-poc): service that provides a front-end for our application. It accesses all services in a user-friendly way.

## Running the app

### Requirements
To run this application you, must install:
- [Docker](https://docs.docker.com/engine/install/)
- [Docker compose](https://docs.docker.com/compose/install/)

### Configuring your environment

This repository provides a main `docker-compose.yml`-file, as well as some environment-specific compose files. An easy way of configuring which additional compose files your setup should use, is to provide an [Environment File](https://docs.docker.com/compose/env-file/) (aka `.env`-file)

For development:
```
COMPOSE_FILE=docker-compose.yml:docker-compose.dev.yml
```
For production:
```
COMPOSE_FILE=docker-compose.yml:docker-compose.prod.yml
```

### Starting the stack
```
docker-compose up
```
See docker-compose's [cli-reference](https://docs.docker.com/compose/reference/overview/) for more information regarding the management of these kind of stacks.

With the standard production settings, you can now open up a browser and browse to `localhost` where you will be presented with the user interface.

## Development

(WIP)

## Documentation

### API-specification generation

The [OpenAPI resources generator](https://github.com/mu-semtech/cl-resources-openapi-generator) can be used to generate an [openapi](https://www.openapis.org/)-specification for the API exposed by mu-cl-resources.  
Following command will generate a `openapi.json`-file in `./doc`. Make sure to delete the old one should a file by this name already exist.
```
docker-compose -f docker-compose.yml -f docker-compose.doc.yml up
```

### User documentation
(WIP)
