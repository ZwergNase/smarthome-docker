#!/bin/bash
sudo ./chown.sh
owserver --foreground --error-level=2 -c owserver.conf
