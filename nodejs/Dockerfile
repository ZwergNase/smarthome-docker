FROM    debian:stable-slim

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
			tzdata \
			curl \
			ca-certificates \
    		build-essential && \
		apt-get -q -y clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN     curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN	apt-get --quiet --yes --no-install-recommends install \
			gyp \
            nodejs