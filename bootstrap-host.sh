#!/bin/bash
#
# Configure broken host machine to run correctly
#
set -ex

VEIL_IMAGE=${VEIL_IMAGE:-wallercrypto/docker-veild}

distro=$1
shift

memtotal=$(grep ^MemTotal /proc/meminfo | awk '{print int($2/1024) }')

#
# Only do swap hack if needed
#
if [ $memtotal -lt 2048 -a $(swapon -s | wc -l) -lt 2 ]; then
    fallocate -l 2048M /swap || dd if=/dev/zero of=/swap bs=1M count=2048
    mkswap /swap
    grep -q "^/swap" /etc/fstab || echo "/swap swap swap defaults 0 0" >> /etc/fstab
    swapon -a
fi

free -m

if [ "$distro" = "trusty" -o "$distro" = "ubuntu:14.04" ]; then
    # echo deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-bionic InRelease > /etc/apt/sources.list.d/docker.list

    # Handle other parallel cloud init scripts that may lock the package database
    # TODO: Add timeout
    while ! apt-get update --allow-unauthenticated; do sleep 10; done

    while ! apt-get install -y lxc-docker; do sleep 10; done
fi

# Always clean-up, but fail successfully
docker kill veild-node 2>/dev/null || true
docker rm veild-node 2>/dev/null || true
stop docker-veild 2>/dev/null || true

# Always pull remote images to avoid caching issues
if [ -z "${VEIL_IMAGE##*/*}" ]; then
    docker pull $VEIL_IMAGE
fi

# Initialize the data container
docker volume create --name=veild-data
docker run -v veild-data:/veil --rm $VEIL_IMAGE veil_init

# Start veild via upstart and dockfree -mer
curl https://raw.githubusercontent.com/MatWaller/docker-veild/master/init/upstart.init > /etc/init/docker-veild.conf
start docker-veild

set +ex
echo "Resulting vel.conf:"
docker run -v veild-data:/veil --rm $VEIL_IMAGE cat /veil/.veil/veil.conf
2