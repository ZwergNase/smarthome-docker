sudo docker run --detach --restart=always --volume=avahi_data:/etc/avahi/services --net=host --name=avahi avahi
