FROM    oliverf/nodejs

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV     DEBIAN_FRONTEND noninteractive

RUN	addgroup nodejs && \
        adduser --system --ingroup nodejs --disabled-password --uid 1000 nodejs && \
	usermod -a -G video nodejs

RUN     apt-get update && \
	apt-get --quiet --yes --no-install-recommends install \
		ffmpeg && \
	apt-get -q -y clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	npm install -g --unsafe-perm --production homebridge && \
        npm install -g --unsafe-perm --production homebridge-fhem  && \
        npm install -g --unsafe-perm --production homebridge-config-ui-x && \
	npm install -g homebridge-camera-ffmpeg

COPY    config.json /home/nodejs/.homebridge/
RUN     chown -R nodejs:nodejs /home/nodejs

USER	nodejs

CMD /usr/bin/homebridge
