# =================
# 资源下载
# =================
FROM alpine:3 AS download

RUN apk add --no-cache \
    wget

RUN mkdir -p /download \
    && wget -qO /download/fabric-server.jar \
    https://meta.fabricmc.net/v2/versions/loader/26.2/0.19.4/1.1.2/server/jar

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
ENV JAVA_MEMORY=4G
ENV GAME_MAX_PLAYERS=8
ENV GAME_ONLINE_MODE=true
ENV GAME_AUTHLIB_INJECTOR_URL="https://mcskin.dsrv.top/api/yggdrasil"
ENV GAME_MANAGEMENT_SERVER_SECRET=""

RUN mkdir -p /app /app/world && chown 1000:1000 /app /app/world

COPY --from=install --chown=1000:1000 ["/app","/app"]

EXPOSE 25565/tcp 25575/tcp

VOLUME [ "/app/world" ]

WORKDIR /app
USER 1000:1000
CMD ["sh", "/app/start-server.sh"]
