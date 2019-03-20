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
		        libpath-tiny-perl && \
		apt-get -q -y clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN		addgroup fhem && \
		adduser --system --ingroup fhem --disabled-password --uid 1000 fhem && \
		usermod -a -G dialout fhem

WORKDIR /opt/fhem/

COPY	--from=builder --chown=fhem:fhem /tmp/fhem .

COPY	--from=builder --chown=fhem:fhem /tmp/fhem/fhem.cfg /home/fhem/fhem.cfg

RUN     chown -R fhem:fhem ../fhem

USER	fhem

RUN     mv log ~/log && \
    	mv www/gplot ~/gplot && \
        ln -s ~/log log && \
	    ln -s ~/gplot www/gplot && \
        rm fhem.cfg && \
        ln -s ~/fhem.cfg fhem.cfg

EXPOSE  8083 8084 8085 7072

CMD     ["perl", "fhem.pl", "fhem.cfg"]