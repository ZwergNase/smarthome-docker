FROM    debian:stable-slim

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>"

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
		ca-certificates \
                wget \
                gnupg && \
        wget -qO - http://weewx.com/keys.html | apt-key add - && \
        wget -qO - http://weewx.com/apt/weewx.list | tee /etc/apt/sources.list.d/weewx.list && \
        apt-get update && \
        apt-get  --quiet --yes --no-install-recommends install \ 
                weewx && \
	wget -O weewx-wh23xx.zip https://github.com/matthewwall/weewx-wh23xx/archive/master.zip && \
	wee_extension --install weewx-wh23xx.zip && \
	wget -O weewx-fhem.zip https://github.com/matthewwall/weewx-fhem/archive/master.zip && \
	wee_extension --install weewx-fhem.zip && \
        apt-get -q -y clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN	wget -O weewx-wh23xx.zip https://github.com/matthewwall/weewx-wh23xx/archive/master.zip && \
	wee_extension --install weewx-wh23xx.zip

RUN     addgroup weewx && \
        adduser --system --ingroup weewx --disabled-password --uid 1000 weewx

WORKDIR /home/weewx

RUN	mv /etc/weewx/* . && \
	chown -R weewx:weewx * && \
	sed -i -e 's|/etc/weewx|/home/weewx|g' weewx.conf && \
	sed -i -e 's|/var/www/html/weewx|/home/weewx/html|g' weewx.conf && \
	sed -i -e 's|/var/lib/weewx|/home/weewx|g' weewx.conf

#USER    weewx

#CMD     ["perl", "fhem.pl", "/home/fhem/fhem.cfg"]
CMD /bin/bash
