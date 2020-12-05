#!/bin/bash

docker run -ti --rm --mount source=smartvisu_data,target=/tmp oliverf/smartvisu-updater:latest $1
