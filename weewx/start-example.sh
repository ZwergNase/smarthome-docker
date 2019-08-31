#!/bin/bash

#sudo docker run --detach  --restart=always --name pywws --mount source=pywws_data,target=/home/pywws --device=/dev/usb/hiddev0:/dev/usb/hiddev0 pywws:arm32v7
sudo docker run -ti --rm --name weewx --mount source=weewx_data,target=/home/weewx --mount source=weewx_share,target=/var/www/html/weewx --privileged weewx:arm32v7 weewxd /home/weewx/weewx.conf

# --detach                                      im Hintergrund ausführen / run in background
# --restart=always                              Container automatisch (neu)starten / (re)start container automaticly 
# --name=pywws                                  Container "pywws" nennen / name container "pywws"
# --mount souce=pywws_data,target=/home/pywws   /home/pywws im Volume pywws_data sichern / save /home/pywws in volume pywws_data 
# oliverf/pywws:latest                           Image / name of the image
