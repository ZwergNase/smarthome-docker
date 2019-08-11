FROM    arm32v7/debian:stable-slim as builder

LABEL	maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV	DEBIAN_FRONTEND noninteractive

RUN     apt-get update && \
	apt-get --quiet --yes --no-install-recommends install \
		git \
		ca-certificates

RUN	cd /tmp && \
	git clone https://github.com/Martin-Gleiss/smartvisu.git

FROM php:7.2-apache

ENV     DEBIAN_FRONTEND noninteractive
ENV     TZ Europe/Berlin
ENV	APACHE_RUN_USER smartvisu
ENV	APACHE_RUN_GROUP smartvisu

RUN     addgroup smartvisu && \
	adduser --system --ingroup smartvisu --disabled-password --uid 1000 smartvisu

COPY	--from=builder --chown=smartvisu:smartvisu /tmp/smartvisu /var/www/html/smartvisu

RUN	sed -i 's/<VirtualHost.*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf && \
	sed -i 's|</VirtualHost>|\t<Directory />\n\t\tOptions +FollowSymLinks\n\t</Directory>\n</VirtualHost>|' /etc/apache2/sites-available/000-default.conf && \
	sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
	chown smartvisu:smartvisu /var/run/apache2/

WORKDIR	/home/smartvisu

USER	smartvisu

RUN	mv /var/www/html/smartvisu/pages/* . && \
	rmdir /var/www/html/smartvisu/pages && \
	ln -s /home/smartvisu  /var/www/html/smartvisu/pages
