# Debugging

## Things to Check

* RAM utilization -- veild is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The veil blockchain will continue to increase insize be sure you have enough disk space.

## Viewing veild Logs

    docker logs veild-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the veild node, but will not connect to already running containers or processes.

    docker run -v veild-data:/veil --rm -it wallercrypto/docker-veild bash -l

You can also attach bash into running container to debug running veild

    docker exec -it veild-node bash -l


