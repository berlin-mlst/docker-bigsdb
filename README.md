# BIGSdb on docker

This is an attempt to dockerize BIGSdb, in accordance with the [installation manual](https://bigsdb.readthedocs.io/en/latest/) by Keith Jolley.

The Dockerfile presented is referenced by an image at [docker hub](https://hub.docker.com/r/berlinmlst/bigsdb/). 

**Please note that BIGSdb is not yet fully functional in the image described by the Dockerfile in this repository.** See our [current TODOs](#current-todos) below.

## Prerequisites

You need to have `docker` and `docker-compose` installed. Please read installation guides referring to the installation of [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/) for your operating system.

## How to spin up the service

First, clone the contents of this repository onto your computer by typing

    git clone https://github.com/berlin-mlst/docker-bigsdb
    
Then, cd into directory `docker-bigsdb` and type

    docker-compose up -d
    
Docker will then download the image (`berlinmlst/bigsdb`) and start customization according to scripts in directory `config`.

## Configuration

The directory `config` contains various configuration files pertaining to BIGSdb (e.g. database configuration files), Apache2, and PostgreSQL. 

## Present status

The image is not yet fully functional. 

Presently, you can only do the following:

  * open the bigsdb main page under http://localhost/cgi-bin/bigsdb.pl
  * open the test isolate database under http://localhost/cgi-bin/bigsdb.pl?db=test_isolates
  * open the test seqdef database under http://localhost/cgi-bin/bigsdb.pl?db=test_seqdef

## Current TODOs

  * customize sequence definition and isolate databases from template (chapter 4 of [installation manual](https://bigsdb.readthedocs.io/en/latest/))
  * run BIGSdb RESTful interface (chapter 3.13)
