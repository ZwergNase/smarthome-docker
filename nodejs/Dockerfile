FROM    debian:stable-slim

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
			tzdata \
			curl \
			ca-certificates \
    		build-essential && \
		curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
		apt-get update && \
		apt-get --quiet --yes --no-install-recommends install \
			gyp \
			nodejs \ 
			npm && \
		apt-get -q -y clean && \	
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
