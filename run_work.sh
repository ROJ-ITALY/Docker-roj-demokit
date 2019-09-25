#!/bin/bash

# This is an example on how to run a docker yocto container.
docker run \
                --rm \
                -it \
                -v "$(pwd)/work:/tmp/work" \
                -v "$(pwd)/cache:/tmp/cache" \
                -v "$(pwd)/sources:/tmp/sources" \
                -v "$(pwd)/downloads:/tmp/downloads" \
                yocto-roj-demokit \
                --id="$(id -u):$(id -g)" \
                --work="/tmp/work" \
                --download="/tmp/downloads" \
                --source="/tmp/sources" \
                --cache="/tmp/cache" \
                "$@"
