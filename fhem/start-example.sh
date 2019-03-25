#!/bin/bash

sudo docker run --detach  --restart=always --name fhem --mount source=fhem_data,target=/home/fhem --publish 8083-8085:8083-8085 oliverf/fhem:latest

# --detach                                      im Hintergrund ausführen / run in background
# --restart=always                              Container automatisch (neu)starten / (re)start container automaticly 
# --name=fhem                                   Container "fhem" nennen / name container "fhem"
# --mount souce=fhem_data,target=/home/fhem     /home/fhem im Volume fhem_data sichern / save /home/fhem in volume fhem_data 
# --publish 8083-8085:8083-8085                 Ports 8083-8085 zugänglich machen / allow access on port 8083-8085
# oliverf/fhem:latest                           Image / name of the image