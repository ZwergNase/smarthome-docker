#!/bin/bash

sudo docker run --detach  --restart=always --name homebrdige --mount source=homebridge_data,target=/home/nodejs --network=host oliverf/homekit:latest

# --detach                                      	im Hintergrund ausführen / run in background
# --restart=always                              	Container automatisch (neu)starten / (re)start container automaticly 
# --name=homebridge                             	Container "homebridge" nennen / name container "homebridge"
# --mount souce=homebridge_data,target=/home/nodejs     /home/nodejs im Volume homebridge_data sichern / save /home/nodejs in volume homebridge_data 
# --network=host					Vollzugriff auf host-Netzwerk (wegen avahi Multicast) / full access host-network (for avahi multicast)
# oliverf/homebridge:latest   		                Image / name of the image
