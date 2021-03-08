#!/bin/bash

sudo docker run --detach  --restart=always --name fhem-of --mount source=fhem_data,target=/home/fhem --publish 8083-8085:8083-8085 --publish 2121:2121 --publish 1883:1883 oliverf/fhem-of:latest

# --detach						im Hintergrund ausführen / run in background
# --restart=always					Container automatisch (neu)starten / (re)start container automaticly
# --name=fhem-of					Container "fhem-of" nennen / name container "fhem-of"
# --mount souce=fhem_data,target=/home/fhem		/home/fhem im Volume fhem_data sichern / save /home/fhem in volume fhem_data
# --publish 8083-8085:8083-8085				Ports 8083-8085 zugänglich machen / allow access on port 8083-8085
# --publish 2121:2121					Port für smartvisu / port for smartvisu
# --publish 1883:1883					Port für mqtt / port for mqtt
# oliverf/fhem-of:latest				Image / name of the image
