FROM    oliverf/smarthome-base:latest

LABEL   maintainer="Oliver Friesen <oliver.friesen@gmail.com>" 

ENV     DEBIAN_FRONTEND noninteractive

ENV     TZ Europe/Berlin

RUN     apt-get update && \
        apt-get --quiet --yes --no-install-recommends install \
		php  \
		php-mbstring \
		nginx \
		php-fpm \
		supervisor \ 
		curl && \
	apt-get -q -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN     addgroup --gid 1000 nginx && \
        adduser --disabled-login --shell /usr/sbin/nologin --gecos "" --ingroup nginx --uid 1000 nginx && \
        chmod go-wrx /home/nginx

WORKDIR	/home/nginx

COPY	--chown=nginx:nginx nginx.conf fpm-pool.conf php.ini supervisord.conf ./
RUN	rm /etc/nginx/nginx.conf && \
	ln -s /home/nginx/nginx.conf /etc/nginx/nginx.conf && \
	mkdir -p /var/www/html
COPY	--chown=nginx:nginx index.* /var/www/html/

RUN	chmod o+w /run && \
	chown -R nginx:nginx /var/log/nginx /var/log/supervisor

USER	nginx

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n", "-c", "/home/nginx/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
