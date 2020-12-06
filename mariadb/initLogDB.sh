#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "usage: initDB.sh username password database"
    exit 2
fi

docker run -ti --rm --mount source=mariadb_data,target=/home/mariadb oliverf/mariadb:latest $1 $2 $3
