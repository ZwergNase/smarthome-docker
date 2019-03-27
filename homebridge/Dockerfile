FROM    oliverf/nodejs

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV     DEBIAN_FRONTEND noninteractive

RUN	    addgroup node && \
        adduser --system --ingroup node --disabled-password --uid 1000 node

RUN     npm install -g --unsafe-perm homebridge && \
        npm install -g homebridge-fhem  && \
        npm install -g --unsafe-perm homebridge-config-ui-x

COPY    config.json /home/node/.homebridge/
RUN     chown -R node:node /home/node

USER	node

CMD /usr/bin/homebridge