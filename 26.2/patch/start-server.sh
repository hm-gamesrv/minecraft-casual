#!/bin/sh
set -eu

exec java \
    -Xms4G \
    -Xmx4G \
    -XX:+UseZGC \
    -javaagent:authlib-injector-1.2.8.jar=https://mcskin.dsrv.top/api/yggdrasil \
    -jar fabric-server.jar --nogui
