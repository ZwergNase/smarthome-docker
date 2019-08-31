#!/bin/bash

sudo docker run -ti --name samba --mount source=samba_data,target=/home/samba --mount source=fhem_data,target=/home/fhem --mount source=weewx_data,target=/home/weewx --mount source=knxd_data,target=/home/knxd --mount source=homebridge2_data,target=/home/hombridge2 --mount source=homebridge_data,target=/home/hombridge --network=host oliverf/samba-arm32v7:latest 
