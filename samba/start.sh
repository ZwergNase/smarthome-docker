#!/bin/bash

nmbd --foreground --log-stdout &
smbd --foreground --log-stdout --configfile=/home/samba/smb.conf