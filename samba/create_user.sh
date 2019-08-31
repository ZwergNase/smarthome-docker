sudo docker run --rm -ti --name=samba --mount=source=samba_data,target=/home/samba oliverf/samba-arm32v7:latest smbpasswd -a -c smb.conf $1
