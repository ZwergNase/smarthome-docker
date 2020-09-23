#!/bin/bash

sudo docker run --detach  --restart=always --name zigbee2mqtt --mount source=zigbee2mqtt_data,target=/home/zigbee2mqtt --device /dev/ttyACM0:/dev/ttyACM0 oliverf/zigbee2mqtt
:latest

# --detach							im Hintergrund ausführen / run in background
# --restart=always						Container automatisch (neu)starten / (re)start container automaticly
# --name=zigbee2mqtt						Container "zigbee2mqtt" nennen / name container "zigbee2mqtt"
# --mount souce=zigbee2mqtt_data,target=/home/zigbee2mqtt	/home/zigbee2mqtt im Volume zigbee2mqtt_data sichern / save /home/zigbee2mqtt in volume zigbee2mqtt_data
# oliverf/zigbee2mqtt:latest					Image / image
