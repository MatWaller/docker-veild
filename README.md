veild for Docker
===================

[![Docker Stars](https://img.shields.io/docker/stars/veil-project/veil.svg)](https://hub.docker.com/r/veil-project/veil/)
[![Docker Pulls](https://img.shields.io/docker/pulls/veil-project/veil.svg)](https://hub.docker.com/r/veil-project/veil/)
[![Build Status](https://travis-ci.org/kylemanna/docker-veild.svg?branch=master)](https://travis-ci.org/kylemanna/docker-veild/)
[![ImageLayers](https://images.microbadger.com/badges/image/veil-project/veil.svg)](https://microbadger.com/#/images/veil-project/veil)

Docker image to run a veild node in a container for easy deployment.


Requirements
------------

* Machine capible of running a ubuntu 14.04 or newer image.
* At least 10 GB to store the chain (AT LEAST)
* At least 1 GB RAM + 2 GB swap file

Really Fast Quick Start
-----------------------

One liner for Ubuntu 14.04 LTS machines with JSON-RPC enabled on localhost and adds upstart init script:

    curl https://raw.githubusercontent.com/matwaller/docker-veild/master/bootstrap-host.sh | sh -s trusty


Quick Start
-----------

1. Create a `veild-data` volume to persist the veild blockchain data, should exit immediately.  The `veild-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=veild-data
        docker run -v veild-data:/veil --name=veild-node -d \
            -p 58810:58810 \
            -p 127.0.0.1:58810:58810 \
            veil-project/veil

2. Verify that the container is running and veild node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        veil-project/veil     "veil_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   veild-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f veild-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
