#!/bin/sh
set -eu

set_game_property() {
    key=$1
    value=$2
    if [ -n "$value" ]; then
        escaped=$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')
        sed -i "s|^${key}=.*|${key}=${escaped}|" "/app/server.properties"
    fi
}

set_jvm_property() {
    key=$1
    value=$2
    if [ -n "$value" ]; then
        escaped=$(printf '%s' "$value" | sed 's/[|&\\]/\\&/g')
        sed -i "s|{{ ${key} }}|${escaped}|g" "/app/user_jvm_args.txt"
    else
        sed -i "/{{ ${key} }}/d" "/app/user_jvm_args.txt"
    fi
}

JVM_MEMORY=${JVM_MEMORY:-4G}
JVM_AUTHLIB_INJECTOR_URL=${JVM_AUTHLIB_INJECTOR_URL:-https://mcskin.dsrv.top/api/yggdrasil}

GAME_MAX_PLAYERS=${GAME_MAX_PLAYERS:-8}
GAME_ONLINE_MODE=${GAME_ONLINE_MODE:-true}
GAME_MANAGEMENT_SERVER_SECRET=${GAME_MANAGEMENT_SERVER_SECRET:-}
GAME_RESOURCE_PACK=${GAME_RESOURCE_PACK:-}

set_game_property max-players "$GAME_MAX_PLAYERS"
set_game_property online-mode "$GAME_ONLINE_MODE"
set_game_property management-server-secret "$GAME_MANAGEMENT_SERVER_SECRET"
set_game_property resource-pack "$GAME_RESOURCE_PACK"

set_jvm_property JAVA_MEMORY "$JVM_MEMORY"
set_jvm_property JAVA_AUTHLIB_INJECTOR_URL "$JVM_AUTHLIB_INJECTOR_URL"

exec "$@"