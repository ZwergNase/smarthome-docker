FROM    oliverf/builder as builder

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV     DEBIAN_FRONTEND noninteractive

RUN     svn --non-interactive --trust-server-cert co https://svn.fhem.de/fhem/trunk/fhem /tmp/fhem

FROM    debian:stable-slim

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
			tzdata \
			usbutils \
			perl \
			libtime-hires-perl \
			libdevice-serialport-perl \
			libjson-perl \
			libio-socket-ssl-perl \
		    libpath-tiny-perl  \
			curl \
			ca-certificates \
    		build-essential && \
		apt-get -q -y clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Nodejs
RUN     curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN	    apt-get --quiet --yes --no-install-recommends install \
			gyp \
            nodejs && \
    	apt-get -q -y clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Alexa
RUN     npm install -g --unsafe-perm --production alexa-fhem

# fhem
RUN		addgroup fhem && \
		adduser --system --ingroup fhem --disabled-password --uid 1000 fhem && \
		usermod -a -G dialout fhem

WORKDIR /opt/fhem/

COPY	--from=builder --chown=fhem:fhem /tmp/fhem .

COPY    32_WifiLight.pm FHEM/

COPY	--chown=fhem:fhem fhem.cfg /home/fhem/fhem.cfg

RUN     chown -R fhem:fhem ../fhem

USER	fhem

RUN     mv log ~/log && \
    	mv www/gplot ~/gplot && \
        ln -s ~/log log && \
	    ln -s ~/gplot www/gplot		

EXPOSE  8083 8084 8085 7072

CMD     ["perl", "fhem.pl", "/home/fhem/fhem.cfg"]



