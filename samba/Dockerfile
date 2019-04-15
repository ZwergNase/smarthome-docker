FROM    debian:stable-slim

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
			tzdata \
			samba && \
		apt-get -q -y clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN	adduser --system --disabled-password samba

WORKDIR	/home/samba

COPY	smb.conf .

CMD [ "smbd", "--foreground", "--log-stdout", "--configfile=/home/samba/smb.conf"]