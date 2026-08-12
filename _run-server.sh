#!/bin/bash
set -e

podman run --rm -it \
    --name minecraft-casual-1.21.1 \
    --userns keep-id \
    -p 1314:1314/tcp \
    -p 1315:1315/tcp \
    -p 30001:30001/tcp \
    -p 30002:30002/udp \
    ghcr.io/hm-gamesrv/minecraft-casual:1.21.1-latest