#~/bin/bash
sudo docker run --detach  --restart always --name smartvisu --mount source=smartvisu_data,target=/home/smartvisu --publish 8080:8080 smartvisu
