sudo docker run -ti --rm --device /dev/ttyAMA0:/dev/ttyUSB0 oliverf/knxd-arm32v7:v0.12 knxd -e 1.0.1 -E 1.0.200:10 -t 0xfff -f 9 -D -T -R -S -b tpuarts:/dev/ttyUSB0
