#~/bin/bash
sudo docker run --detach --restart always --name knxd --mount source=knxd_data,target=/home/knxd --device=/dev/ttyAMA0:/dev/ttyKNX0 --network=host knxd
