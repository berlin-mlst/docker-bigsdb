# BIGSdb on docker

This is an attempt to dockerize BIGSdb, in accordance with the [installation manual](https://bigsdb.readthedocs.io/en/latest/) by Keith Jolley.

The Dockerfile presented is referenced by an image at [docker hub](https://hub.docker.com/r/berlinmlst/bigsdb/). Please note that BIGSdb is **not yet fully functional** in the image described by the Dockerfile in this repository.

## Prerequisites

You need to have docker and docker-compose installed. Please read installation guides referring to the installation of [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) for your operating system.

## How to spin up the service

First, clone the contents of this repository onto your computer by typing

    git clone https://github.com/berlin-mlst/docker-bigsdb
    
Then cd into directory 'docker-bigsdb' and type

    docker-compose up -d
    
Docker will then download the images (berlinmlst/bigsdb and postgres) and start customization according to scripts in directory config.

## Current TODOs

  * customization of menu_header.html
  * integration of all perl scripts in subdirectory 'scripts'
