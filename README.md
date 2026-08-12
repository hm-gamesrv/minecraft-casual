# Minecraft Casual Server

## 1. 简述

我的世界原版风格的轻量休闲服务器

**支持游戏版本：**

| MC 版本 | 镜像 tag        |
| ------- | --------------- |
| 1.21.1  | `1.21.1-latest` |

## 2. 资源占用信息

### 2.1. 端口

| 端口号 | 协议 | 说明         |
| ------ | ---- | ------------ |
| 25565  | TCP  | 游戏联机端口 |
| 25575  | TCP  | RCON 端口    |

### 2.2. 持久卷

| 容器路径             | 说明                       |
| -------------------- | -------------------------- |
| `/app/world`         | 游戏世界存档               |
| `/app/simple_backup` | simple_backup 模组备份路径 |

## 3. 构建与运行

### 3.1. 构建并运行（Docker）

```bash
docker build -t minecraft-casual:1.21.1-temp ./1.21.1 && \
    docker run --rm -it \
        -p 25565:25565/tcp \
        -p 25575:25575/tcp \
        -v ./world:/app/world \
        -v ./simple_backup:/app/simple_backup \
        minecraft-casual:1.21.1-temp
```

### 3.2. 运行服务器（Podman）

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
