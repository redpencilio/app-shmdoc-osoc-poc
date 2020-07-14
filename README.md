# Shmdoc PoC application

Proof of concept application for the schmdoc project by [VLIZ](http://www.vliz.be/). Built during [Open Summer of Code](http://www.osoc.be) 2020.


## Running the app

### Requirements

The application is built according to a microservice architecture supported by Docker. Requirements to run this stack are:
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