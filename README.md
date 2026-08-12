# minecraft-casual

## 1. 简述

我的世界原版风格的轻量休闲服务器

**支持游戏版本：**

| MC 版本 | 镜像 tag        |
| ------- | --------------- |
| 1.21.1  | `1.21.1-latest` |

## 2. 构建与运行

### 2.1. 构建并运行（Docker）

```bash
docker build -t minecraft-casual:1.21.1-temp . && \
    docker run --rm -it \
        -p 25565:25565/tcp \
        -p 25575:25575/tcp \
        minecraft-casual:1.21.1-temp
```

### 2.2. 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-casual:1.21.1-latest

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name mc-casual-1.21.1 \
    --userns keep-id \
    --network pasta \
    -p 25565:25565/tcp \
    -p 25575:25575/tcp \
    -v ./world:/app/world \
    -v ./simple_backup:/app/simple_backup \
    "$IMAGE"
```
