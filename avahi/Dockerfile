FROM    arm32v7/debian:stable-slim as builder

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
        avahi-daemon && \
 	sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf 

VOLUME /etc/avahi/services
EXPOSE 5353/udp

ENTRYPOINT ["avahi-daemon"]
CMD []
