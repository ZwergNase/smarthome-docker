FROM    oliverf/smarthome-base:latest

LABEL   maintainer="Oliver Friesen<oliver.friesen@gmail.com>"

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt-get update && \
	apt-get  --quiet --yes --no-install-recommends install \
		apt-utils \
		git-core \
		build-essential \
		fakeroot \
		debhelper \
		autotools-dev \
		autoconf \
		automake \
		libtool \
		pkg-config \
		cmake \
		wget \
		cdbs \
		ca-certificates \
		nano \
		subversion && \
                apt-get -q -y clean && \
                rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN     adduser --system --disabled-password someuser

USER	someuser
