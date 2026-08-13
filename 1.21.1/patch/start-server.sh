#!/bin/bash
set -euo pipefail

cd /app

if [ ! -d ./world ] || [ -z "$(ls -A ./world 2>/dev/null)" ]; then
    mkdir -p ./world
    cp -r ./datapacks ./world/
fi

exec java @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.248/unix_args.txt "$@"
