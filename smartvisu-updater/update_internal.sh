#!/bin/bash
shopt -s extglob 

if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters / specify smartvisu version tag"
    exit 2
fi

cd /tmp
rm -Rf !(pages|config.ini)

git clone --branch $1 https://github.com/Martin-Gleiss/smartvisu.git

if [ -d pages ]
then
	mv smartvisu/pages smartvisu/pages_$1
fi
if [ -f config.ini  ]
then
        mv smartvisu/config.ini smartvisu/config.ini_$1
fi

mv smartvisu/* .

rm -Rf smartvisu

chown -R smartvisu:smartvisu /tmp
