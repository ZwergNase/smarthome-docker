#!/bin/bash

sudo docker run -ti --rm  --name knxd-v0.14.3 --mount source=knxd_data,target=/home/knxd --device=/dev/ttyAMA0:/dev/ttyKNX0 --network=host oliverf/knxd-arm32v7:v0.14.3 knxd_tpuart.ini
