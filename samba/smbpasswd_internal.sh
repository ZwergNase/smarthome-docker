#!/bin/bash

if [ $# -eq 0 ]; 
	then echo "missing username"
	exit 2
fi

if [ $# -ne 1 ]; 
	then echo "only one username"
	exit 2
fi

adduser --system --ingroup samba --disabled-password $1
smbpasswd -a -c smb.conf $1
