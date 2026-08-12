# =================
# 资源下载
# =================
FROM eclipse-temurin:25-jre AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget &&\
    rm -rf /var/lib/apt/lists/*

WORKDIR /downloads
RUN wget https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.248/neoforge-21.1.248-installer.jar
RUN java -jar neoforge-21.1.248-installer.jar --fat-offline &&\
    java -jar neoforge-21.1.248-installer-fat.jar --install-server ./app

# ===================
# 基座镜像
# ===================
FROM eclipse-temurin:25-jre

EXPOSE 25565/tcp 25575/tcp

VOLUME [ "/app/world", "/app/simple_backup" ]

ENV TZ=Asia/Shanghai

RUN mkdir -p /app && chown 1000:1000 /app
USER 1000:1000

COPY --from=builder --chown=1000:1000 ["/downloads/app", "/app"]
COPY --chown=1000:1000 ["./patch/", "/app"]

WORKDIR /app

CMD ["bash", "/app/start-server.sh"]