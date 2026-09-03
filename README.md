# Minecraft Casual Server

## 简述

我的世界原版风格的轻量休闲服务器

**可用版本：**

| 版本 | 镜像 tag |
| --- | --- |
| 26.2 | `26.2` |
| 1.21.1 | `1.21.1` |

## 26.2

### 资源占用信息

#### 端口

| 端口号 | 协议 | 说明 |
| --- | --- | --- |
| 25565 | TCP | 游戏联机端口 |
| 25575 | TCP | RCON 端口 |
| 24454 | UDP | 模组“简单的语音聊天”所用端口 |

#### 持久卷

| 宿主路径 | 容器路径 | 说明 |
| --- | --- | --- |
| `./minecraft-casual-world` | `/app/world` | 游戏世界存档 |

#### 环境变量

| 变量名 | 必填 | 说明 |
| --- | --- | --- |
| `JVM_MEMORY` | 否 | JVM 堆内存大小（同时作用于 -Xms/-Xmx），如 4G、2500M |
| `JVM_AUTHLIB_INJECTOR_URL` | 否 | 外置登录（authlib-injector）Yggdrasil API 地址，置空则跳过外置登录 |
| `GAME_MAX_PLAYERS` | 否 | 服务器列表显示的玩家容量，达到上限后新玩家无法加入 |
| `GAME_ONLINE_MODE` | 否 | 是否启用在线验证模式：true=开启，false=关闭 |
| `GAME_RESOURCE_PACK` | 否 | 强制启用的服务端资源包 URL |
| `GAME_ENABLE_RCON` | 否 | 是否启用 RCON |
| `GAME_RCON_PASSWORD` | 否 | RCON 口令 |

### 构建与运行

#### 构建并运行（Docker）

```bash
docker build -t minecraft-casual:temp . && \
    docker run --rm -it \
        -e JVM_MEMORY=6G \
        -e JVM_AUTHLIB_INJECTOR_URL=your_jvm_authlib_injector_url \
        -e GAME_MAX_PLAYERS=8 \
        -e GAME_ONLINE_MODE=true \
        -e GAME_RESOURCE_PACK=your_game_resource_pack \
        -e GAME_ENABLE_RCON=false \
        -e GAME_RCON_PASSWORD=your_game_rcon_password \
        -p 25565:25565/tcp \
        -p 25575:25575/tcp \
        -p 24454:24454/udp \
        -v ./minecraft-casual-world:/app/world \
        minecraft-casual:temp
```

#### 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-casual:26.2

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name minecraft-casual-26.2 \
    --userns keep-id \
    --network pasta \
    -e JVM_MEMORY=6G \
    -e JVM_AUTHLIB_INJECTOR_URL=your_jvm_authlib_injector_url \
    -e GAME_MAX_PLAYERS=8 \
    -e GAME_ONLINE_MODE=true \
    -e GAME_RESOURCE_PACK=your_game_resource_pack \
    -e GAME_ENABLE_RCON=false \
    -e GAME_RCON_PASSWORD=your_game_rcon_password \
    -p 25565:25565/tcp \
    -p 25575:25575/tcp \
    -p 24454:24454/udp \
    -v ./minecraft-casual-world:/app/world \
    "$IMAGE"
```

## 1.21.1

### 资源占用信息

#### 端口

| 端口号 | 协议 | 说明 |
| --- | --- | --- |
| 25565 | TCP | 游戏联机端口 |
| 25575 | TCP | RCON 端口 |

#### 持久卷

| 宿主路径 | 容器路径 | 说明 |
| --- | --- | --- |
| `./minecraft-casual-1.21.1-world` | `/app/world` | 游戏世界存档 |
| `./minecraft-casual-1.21.1-simple_backup` | `/app/simple_backup` | simple_backup 模组备份路径 |

### 构建与运行

#### 构建并运行（Docker）

```bash
docker build -t minecraft-casual:temp . && \
    docker run --rm -it \
        -p 25565:25565/tcp \
        -p 25575:25575/tcp \
        -v ./minecraft-casual-1.21.1-world:/app/world \
        -v ./minecraft-casual-1.21.1-simple_backup:/app/simple_backup \
        minecraft-casual:temp
```

#### 运行服务器（Podman）

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-casual:1.21.1

if ! podman pull "$IMAGE"; then
    exit 1
fi

podman run --rm -it \
    --name minecraft-casual-1.21.1 \
    --userns keep-id \
    --network pasta \
    -p 25565:25565/tcp \
    -p 25575:25575/tcp \
    -v ./minecraft-casual-1.21.1-world:/app/world \
    -v ./minecraft-casual-1.21.1-simple_backup:/app/simple_backup \
    "$IMAGE"
```

