# =================
# 资源下载
# =================
FROM alpine:3 AS download

RUN apk add --no-cache \
    wget \
    jq

COPY manifest.json /manifest.json

# https://fabricmc.net/use/server/
RUN set -eu; \
    mkdir -p /download; \
    mc=$(jq -r '.minecraft' /manifest.json); \
    loader=$(jq -r '.fabric.loader' /manifest.json); \
    installer=$(jq -r '.fabric.installer' /manifest.json); \
    wget -q --tries=3 --timeout=30 -O /download/fabric-server.jar \
        "https://meta.fabricmc.net/v2/versions/loader/$mc/$loader/$installer/server/jar"; \
    echo "$(jq -r '.fabric.sha512' /manifest.json)  /download/fabric-server.jar" | sha512sum -c -

# 模组：按 manifest.json 从 Modrinth 下载，并校验 SHA-512
RUN set -eu; \
    mkdir -p /download/mods; \
    jq -r '.mods[] | "\(.project_id) \(.version_id) \(.sha512) \(.filename)"' /manifest.json > /tmp/mods.txt; \
    while read -r project version sha512 filename; do \
        wget -q --tries=3 --timeout=30 -O "/download/mods/$filename" \
            "https://cdn.modrinth.com/data/$project/versions/$version/$filename"; \
        echo "$sha512  /download/mods/$filename" | sha512sum -c -; \
    done < /tmp/mods.txt

# =================
# 安装
# =================
FROM eclipse-temurin:25-jre-alpine AS install

RUN mkdir -p /app && chown 1000:1000 /app

WORKDIR /app

USER 1000:1000

COPY --from=download --chown=1000:1000 ["/download/fabric-server.jar","/app"]
RUN java -jar /app/fabric-server.jar --initSettings
COPY --from=download --chown=1000:1000 ["/download/mods", "/app/mods"]
COPY --chown=1000:1000 ["./patch/", "/app"]

# ===================
# 运行
# ===================
FROM eclipse-temurin:25-jre-alpine AS runtime

ENV TZ=Asia/Shanghai

RUN mkdir -p /app /app/world && chown 1000:1000 /app /app/world

COPY --from=install --chown=1000:1000 ["/app","/app"]
COPY --chown=1000:1000 ["./init.sh", "/usr/local/bin/init.sh"]

EXPOSE 25565/tcp 25575/tcp 24454/udp

VOLUME [ "/app/world" ]

WORKDIR /app
USER 1000:1000
ENTRYPOINT [ "sh", "/usr/local/bin/init.sh" ]
CMD ["sh", "/app/start-server.sh"]
