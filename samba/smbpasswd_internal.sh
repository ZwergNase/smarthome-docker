#!/bin/bash

echo "Change password for user samba:"
smbpasswd -a -c smb.conf samba
