#~/bin/bash

sudo docker run --detach  --restart=always --name yacht --mount source=yacht_data,target=/config --volume=/var/run/docker.sock:/var/run/docker.sock --publish 9001:8000 selfhostedpro/yacht:latest

# --detach                                              im Hintergrund ausführen / run in background
# --restart=always                                      Container automatisch (neu)starten / (re)start container automaticly
# --name=yacht						Container "yacht" nennen / name container "yacht"
# --mount yacht_data,target=/config			/config im Volume yacht_data sichern / save /config in volume yacht_data
# --volume=/var/run/docker.sock:/var/run/docker.sock    Socket um Docker-Dienst zu kontrollieren / socket to control docker-daemon
# --publish 9001:8000                                   Ports 8000 als 9001 zugänglich machen / allow access to port 8000 via 9001
# selfhostedpro/yacht:latest				Image / name of the image
