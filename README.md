# Minecraft Casual Server

我的世界原版风格的轻量休闲服务器。

镜像由 GitHub Actions 在推送 `main` 时构建，并推送到 `ghcr.io/hm-gamesrv/minecraft-casual`。

| 版本   | 镜像 tag | 加载器   |
| ------ | -------- | -------- |
| 26.3   | `26.3`   | Fabric   |
| 1.21.1 | `1.21.1` | NeoForge |

## 1. 端口

| 端口  | 协议 | 适用版本 | 说明                           |
| ----- | ---- | -------- | ------------------------------ |
| 25565 | TCP  | 全部     | 游戏联机端口                   |
| 25575 | TCP  | 全部     | RCON 端口                      |
| 24454 | UDP  | 26.3     | 模组「简单的语音聊天」所用端口 |

## 2. 持久卷

| 宿主路径                                  | 容器路径             | 适用版本 | 说明                       |
| ----------------------------------------- | -------------------- | -------- | -------------------------- |
| `./minecraft-casual-world`                | `/app/world`         | 26.3     | 游戏世界存档               |
| `./minecraft-casual-1.21.1-world`         | `/app/world`         | 1.21.1   | 游戏世界存档               |
| `./minecraft-casual-1.21.1-simple_backup` | `/app/simple_backup` | 1.21.1   | simple_backup 模组备份路径 |

## 3. 环境变量

26.3 支持以下环境变量（启动时由 `26.3/init.sh` 写入 `server.properties` / `user_jvm_args.txt`）：

| 变量名                     | 默认值  | 说明                                                               |
| -------------------------- | ------- | ------------------------------------------------------------------ |
| `JVM_MEMORY`               | `6G`    | JVM 堆内存大小（同时作用于 `-Xms`/`-Xmx`），如 `4G`、`2500M`       |
| `JVM_AUTHLIB_INJECTOR_URL` | 空      | 外置登录（authlib-injector）Yggdrasil API 地址；置空则跳过外置登录 |
| `GAME_MAX_PLAYERS`         | `8`     | 服务器列表显示的玩家容量，达到上限后新玩家无法加入                 |
| `GAME_ONLINE_MODE`         | `true`  | 是否启用在线验证模式：`true` 开启，`false` 关闭                    |
| `GAME_RESOURCE_PACK`       | 空      | 强制启用的服务端资源包 URL                                         |
| `GAME_ENABLE_RCON`         | `false` | 是否启用 RCON                                                      |
| `GAME_RCON_PASSWORD`       | 空      | RCON 口令                                                          |

1.21.1 不支持环境变量，JVM 内存和外置登录地址直接写在 [`1.21.1/patch/user_jvm_args.txt`](1.21.1/patch/user_jvm_args.txt) 中。

## 4. 构建

在仓库根目录执行（构建需要联网）：

```bash
docker build -t minecraft-casual:26.3 ./26.3
docker build -t minecraft-casual:1.21.1 ./1.21.1
```

- **26.3**：按 [`26.3/manifest.json`](26.3/manifest.json) 从 Modrinth 下载模组并校验 SHA-512；
  Fabric server jar 同样从清单读取版本并校验
- **1.21.1**：从 NeoForge Maven 下载安装器，需要访问 `maven.neoforged.net`

## 5. 运行

Podman（26.3）：

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-casual:26.3

podman pull "$IMAGE"

podman run --rm -it \
    --name minecraft-casual-26.3 \
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

Podman（1.21.1，无环境变量）：

```bash
IMAGE=ghcr.io/hm-gamesrv/minecraft-casual:1.21.1

podman pull "$IMAGE"

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

使用 Docker 时把 `podman` 换成 `docker`，并去掉 `--userns keep-id` 与 `--network pasta`。
