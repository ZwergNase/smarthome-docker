#!/bin/bash

sudo docker run --detach  --restart=always --name knxd --mount source=knxd_data,target=/home/knxd --device=/dev/ttyAMA0:/dev/ttyKNX0 --network=host oliverf/knxd:latest knxd_tpuart.ini

# --detach                                      im Hintergrund ausführen / run in background
# --restart=always                              Container automatisch (neu)starten / (re)start container automaticly 
# --name=knxd                                   Container "knxd" nennen / name container "knxd"
# --mount souce=knxd_data,target=/home/knxd     /home/knxd im Volume knxd_data sichern / save /home/knxd in volume knxd_data 
# --device=/dev/ttyAMA0:/dev/ttyKNX0            serieln Port in Container durchreichen (falls benötigt) / pass serial port to container (if needed)
# --network=host                                gemeinsames Netzwerk mit Host (für Multicast nötig) / shared network with host (neccesary for multicast)
# oliverf/knxd:latest                           Image / name of the image
# knxd_tpuart.ini                               ini-Datei auswählen / choose ini-file