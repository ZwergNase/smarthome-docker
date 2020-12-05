#~/bin/bash

sudo docker run --detach  --restart=always --name portainer --mount source=portainer_data,target=/data --volume=/var/run/docker.sock:/var/run/docker.sock --publish 9000:9000 portainer/portainer-ce:latest

# --detach                                              im Hintergrund ausführen / run in background
# --restart=always                                      Container automatisch (neu)starten / (re)start container automaticly 
# --name=portainer                                      Container "portainer" nennen / name container "portainer"
# --mount portainer_data,target=/data                   /data im Volume portainer_data sichern / save /data in volume portainer_data 
# --volume=/var/run/docker.sock:/var/run/docker.sock    Socket um Docker-Dienst zu kontrollieren / socket to control docker-daemon
# --publish 9000:9000                                   Ports 9000 zugänglich machen / allow access on port 9000
# portainer/portainer-ce:latest                         Image / name of the image
