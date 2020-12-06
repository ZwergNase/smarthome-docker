#!/bin/bash

sudo docker run -ti  --restart=always --name mariadb --mount source=mariadb_data,target=/home/mariadb --publish 3306:3306 oliverf/mariadb-amd64 /bin/bash

# --detach                                      im Hintergrund ausführen / run in background
# --restart=always                              Container automatisch (neu)starten / (re)start container automaticly 
# --name=mariadb                                Container "mariadb" nennen / name container "mariadb"
# --mount souce=knxd_data,target=/home/knxd     /home/mysql im Volume mariadb_data sichern / save /home/mysql in volume mariadb_data 
# --device=/dev/ttyAMA0:/dev/ttyKNX0            serielen Port in Container durchreichen (falls benötigt) / pass serial port to container (if needed)
# --network=host                                gemeinsames Netzwerk mit Host (für Multicast nötig) / shared network with host (neccesary for multicast)
# oliverf/knxd:latest                           Image / name of the image
# knxd_tpuart.ini                               ini-Datei auswählen / choose ini-file
