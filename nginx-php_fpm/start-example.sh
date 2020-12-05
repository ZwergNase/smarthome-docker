#!/bin/bash

sudo docker run  --detach  --restart=always --name nginx-php --mount source=smartvisu_data,target=/var/www/html/smartvisu --mount source=icecoder_data,target=/var/www/html/ICEcoder -p 80:8080 oliverf/nginx-php_fpm-amd64 
