FROM ubuntu:18.04
MAINTAINER IndieBlock <mat@wallercrypto.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /veil

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} veil \
	&& useradd -u ${USER_ID} -g veil -s /bin/bash -m -d /veil veil

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends \
		git \
		ssh \
		build-essential \
		autotools-dev \
		automake \
		pkg-config \
		bsdmainutils \
		python3 \
		ca-certificates \
		dirmngr \
		gpg \
		libssl-dev \
		libevent-dev \
		libboost-system-dev \
		libboost-filesystem-dev \
		libboost-chrono-dev \
		libboost-test-dev \
		libboost-thread-dev \
		libminiupnpc-dev \
		libcap2 \
		libqrencode-dev \
		libtool \
		libzmq3-dev \
		libseccomp2 \
		mc \
		obfs4proxy \
		tor \
		wget \
		libdb++-dev \
		libgmp-dev \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& for server in $(shuf -e ha.pool.sks-keyservers.net \
			hkp://p80.pool.sks-keyservers.net:80 \
			keyserver.ubuntu.com \
			hkp://keyserver.ubuntu.com:80 \
			pgp.mit.edu) ; do \
		gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || : ; \
	done \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y \
		ca-certificates \
		wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./bin /usr/local/bin

VOLUME ["/veil"]

EXPOSE 58810 58810 18332 18333


RUN ssh-keyscan -t rsa github.com | ssh-keygen -lf - 

# clone & build the veil daemon.
RUN	git clone git://github.com/veil-project/veil ~/veil && cd ~/veil && ./autogen.sh && ./configure --with-incompatible-bdb && make -j8

WORKDIR /veil/veil

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["veil_oneshot"]