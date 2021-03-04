#!/bin/bash


# nach USB-Geräten mit ID 04fa:2490 suchen (Dallas Semiconductor DS1490F 2-in-1 Fob, 1-Wire adapter)
# discovesearch for USB-devices with ID 04fa:2490 (Dallas Semiconductor DS1490F 2-in-1 Fob, 1-Wire adapter)

mapfile -t < <(lsusb -d 04fa:2490| sed -n "s/Bus \(...\) Device \(...\).*/--device \/dev\/bus\/usb\/\1\/\2/p")
for var in "${MAPFILE[@]}"
do
#	echo ${var}
	DEVICE_OPTION+=" ${var}"
done

sudo docker run --detach --restart=always --name=owserver --mount source=owserver_data,target=/home/owserver ${DEVICE_OPTION} --publish 4304:4304 oliverf/owserver-arm32v7:latest

# --detach                                      	im Hintergrund ausführen / run in background
# --restart=always                              	Container automatisch (neu)starten / (re)start container automaticly
# --name=owserver                               	Container "owserver" nennen / name container "owserver"
# --mount souce=owserver_data,target=/home/owserver	/home/owserver im Volume owserver_data sichern / save /home/owserver in volume owserver_data
# ${DEVICE_OPTIONS}					gefundene USB-Geräte einbinden / pass discovered USB-devices into container
# --publish 4304:4304			                Port 4304 zugänglich machen / allow access on port 4304
# oliverf/owserverlatest	                	Image / name of the image
