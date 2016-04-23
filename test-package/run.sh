#!/bin/bash

# you may need to run `xhost local:root`

docker run -it --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/$1:/tmp/ring.deb:ro \
    --device /dev/snd \
    --device /dev/video0 \
    -e DISPLAY=unix$DISPLAY \
    debian:unstable \
    /bin/bash -c "dpkg -i /tmp/ring.deb; \
                  apt-get update && \
                  apt-get -fy install && \
                  gnome-ring"
