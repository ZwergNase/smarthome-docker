#!/bin/bash

sudo docker run --detach --restart=always --name mariadb --mount source=mariadb_data,target=/home/mariadb --publish 3306:3306 oliverf/mariadb:latest 

# --detach                                         im Hintergrund ausführen / run in background
# --restart=always                                 Container automatisch (neu)starten / (re)start container automaticly 
# --name=mariadb                                   Container "mariadb" nennen / name container "mariadb"
# --mount souce=mariadb_data,target=/home/mariadb  /home/mysql im Volume mariadb_data sichern / save /home/mysql in volume mariadb_data 
# --pulblish 3306:3306                             Port 3306 zugänglich machen / allow access on port 3306
# oliverf/mariadb:latest                           Image / name of the image
