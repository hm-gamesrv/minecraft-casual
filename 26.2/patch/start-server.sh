#!/bin/sh
set -eu

exec java @/app/user_jvm_args.txt -jar fabric-server.jar --nogui
