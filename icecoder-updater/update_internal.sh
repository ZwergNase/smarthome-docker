#!/bin/bash
shopt -s extglob 

if [[ $# -ne 1 ]]; then
    echo "Illegal number of parameters / specify smartvisu version tag"
    exit 2
fi

cd /tmp
rm -Rf *

git clone --branch $1 https://github.com/icecoder/ICEcoder.git

mv ICEcoder/* .

rm -Rf ICEcoder

chown -R icecoder:icecoder /tmp
chmod 755 data lib plugins tmp

