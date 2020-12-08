#!/bin/bash

sudo docker exec -ti -u root mariadb /bin/bash -c "/home/mariadb/initFhemDB_internal.sh $1 $2 $3"
