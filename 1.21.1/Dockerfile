# =================
# 资源下载
# =================
FROM eclipse-temurin:25-jre AS builder

ARG NEOFORGE_VERSION=21.1.255

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /downloads

RUN wget -q https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar \
    && java -jar neoforge-${NEOFORGE_VERSION}-installer.jar --fat-offline \
    && java -jar neoforge-${NEOFORGE_VERSION}-installer-fat.jar --install-server ./app

# ===================
# 主镜像
# ===================
FROM eclipse-temurin:25-jre

ENV TZ=Asia/Shanghai

RUN mkdir -p /app && chown 1000:1000 /app

COPY --from=builder --chown=1000:1000 ["/downloads/app", "/app"]
COPY --chown=1000:1000 ["./patch/", "/app"]

EXPOSE 25565/tcp 25575/tcp

VOLUME [ "/app/world", "/app/simple_backup" ]

WORKDIR /app
USER 1000:1000
CMD ["bash", "/app/start-server.sh"]
