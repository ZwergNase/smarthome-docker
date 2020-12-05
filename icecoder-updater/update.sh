#!/bin/bash

docker run -ti --rm --mount source=icecoder_data,target=/tmp oliverf/icecoder-updater:latest $1
