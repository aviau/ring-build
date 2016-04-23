#!/bin/bash

docker kill ring-test-package
docker rm ring-test-package

docker run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/$1:/tmp/ring.deb:ro \
    --device /dev/snd \
    --device /dev/video0 \
    -e DISPLAY=unix$DISPLAY \
    --name ring-test-package \
    debian:unstable \
    /bin/bash -c "dpkg -i /tmp/ring.deb; \
                  apt-get update && \
                  apt-get -fy install && \
                  gnome-ring"
