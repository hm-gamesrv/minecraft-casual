#!/bin/sh
set -eu

set_property() {
    key=$1
    value=$2
    if [ -n "$value" ]; then
        escaped=$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')
        sed -i "s|^${key}=.*|${key}=${escaped}|" "/app/server.properties"
    fi
}

JAVA_MEMORY=${JAVA_MEMORY:-4G}
GAME_MAX_PLAYERS=${GAME_MAX_PLAYERS:-8}
GAME_ONLINE_MODE=${GAME_ONLINE_MODE:-true}
GAME_AUTHLIB_INJECTOR_URL=${GAME_AUTHLIB_INJECTOR_URL:-https://mcskin.dsrv.top/api/yggdrasil}
GAME_MANAGEMENT_SERVER_SECRET=${GAME_MANAGEMENT_SERVER_SECRET:-}
GAME_RESOURCE_PACK=${GAME_RESOURCE_PACK:-}

set_property max-players "$GAME_MAX_PLAYERS"
set_property online-mode "$GAME_ONLINE_MODE"
set_property management-server-secret "$GAME_MANAGEMENT_SERVER_SECRET"
set_property resource-pack "$GAME_RESOURCE_PACK"

{
    printf '%s%s\n' '-Xms' "${JAVA_MEMORY}"
    printf '%s%s\n' '-Xmx' "${JAVA_MEMORY}"
    printf '%s\n' '-XX:+UseZGC'
    if [ -n "$GAME_AUTHLIB_INJECTOR_URL" ]; then
        printf '%s"%s"\n' '-javaagent:authlib-injector-1.2.8.jar=' "$GAME_AUTHLIB_INJECTOR_URL"
    fi
} > /app/user_jvm_args.txt

exec java @/app/user_jvm_args.txt -jar fabric-server.jar --nogui
