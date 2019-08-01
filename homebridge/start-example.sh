#!/bin/bash

sudo docker run --detach  --restart=always --name homebrdige --mount source=homebridge_data,target=/home/nodejs --publish 51826:51826 --publish 8080:8080 oliverf/homekit:latest

# --detach                                      	im Hintergrund ausführen / run in background
# --restart=always                              	Container automatisch (neu)starten / (re)start container automaticly 
# --name=homebridge                             	Container "homebridge" nennen / name container "homebridge"
# --mount souce=homebridge_data,target=/home/nodejs     /home/nodejs im Volume homebridge_data sichern / save /home/nodejs in volume homebridge_data 
# --publish 51828:51826 --publish 8080:8080          	Ports 51826 und 8080 zugänglich machen / allow access on port 51826 and 8080
# oliverf/homebridge:latest   		                Image / name of the image
