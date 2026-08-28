# =================
# 资源下载
# =================
FROM alpine:3 AS download

RUN apk add --no-cache \
    wget

RUN mkdir -p /download \
    && wget -qO /download/fabric-server.jar \
    https://meta.fabricmc.net/v2/versions/loader/26.2/0.19.5/1.1.2/server/jar

# =================
# 安装
# =================
FROM eclipse-temurin:25-jre-alpine AS install

RUN mkdir -p /app && chown 1000:1000 /app

WORKDIR /app

USER 1000:1000

COPY --from=download --chown=1000:1000 ["/download/fabric-server.jar","/app"]
RUN java -jar /app/fabric-server.jar --initSettings
COPY --chown=1000:1000 ["./patch/", "/app"]

# ===================
# 运行
# ===================
FROM eclipse-temurin:25-jre-alpine AS runtime

ENV TZ=Asia/Shanghai

RUN mkdir -p /app /app/world && chown 1000:1000 /app /app/world

COPY --from=install --chown=1000:1000 ["/app","/app"]

EXPOSE 25565/tcp 25575/tcp

VOLUME [ "/app/world" ]

WORKDIR /app
USER 1000:1000
CMD ["sh", "/app/start-server.sh"]
