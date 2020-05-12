#!/bin/bash

sudo docker run --detach  --restart=always --name fhem-of --mount source=fhem_data,target=/home/fhem --mount source=weewx_share,target=/var/www/weewx --device /dev/ttyUSB0:/dev/ttyUSB0 --publish 8083-8085:8083-8085 fhem-of:arm32v7

# --detach                                      im Hintergrund ausführen / run in background
# --restart=always                              Container automatisch (neu)starten / (re)start container automaticly 
# --name=fhem                                   Container "fhem" nennen / name container "fhem"
# --mount souce=fhem_data,target=/home/fhem     /home/fhem im Volume fhem_data sichern / save /home/fhem in volume fhem_data 
# --publish 8083-8085:8083-8085                 Ports 8083-8085 zugänglich machen / allow access on port 8083-8085
# oliverf/fhem:latest                           Image / name of the image
