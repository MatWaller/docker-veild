veild config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v veild-data:/veil --name=veild-node -d \
            -p 58810:58810 \
            -p 127.0.0.1:58810:58810 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            wallercrypto/docker-veild

Or you can use your very own config file like that:

        docker run -v veild-data:/veil --name=veild-node -d \
            -p 58810:58810 \
            -p 127.0.0.1:58810:58810 \
            -v /etc/myveilconf.conf:/veil/.veil/veil.conf \
            wallercrypto/docker-veild
