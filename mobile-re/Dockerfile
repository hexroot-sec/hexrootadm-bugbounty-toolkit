# mobile-re — laboratório de engenharia reversa Android para estudo
# JADX + Apktool + Android platform-tools (adb) + Node.js (para o REA, instalado à parte pelo usuário)

FROM eclipse-temurin:21-jdk-jammy

ARG JADX_VERSION=1.5.1
ARG APKTOOL_VERSION=2.10.0
ARG NODE_MAJOR=22

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip wget ca-certificates bash \
    && rm -rf /var/lib/apt/lists/*

# Node.js (necessário para o REA)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# JADX
RUN wget -q "https://github.com/skylot/jadx/releases/download/v${JADX_VERSION}/jadx-${JADX_VERSION}.zip" -O /tmp/jadx.zip \
    && unzip -q /tmp/jadx.zip -d /opt/jadx \
    && ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx \
    && ln -s /opt/jadx/bin/jadx-gui /usr/local/bin/jadx-gui \
    && rm /tmp/jadx.zip

# Apktool
RUN wget -q "https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool" -O /usr/local/bin/apktool \
    && wget -q "https://github.com/iBotPeaches/Apktool/releases/download/v${APKTOOL_VERSION}/apktool_${APKTOOL_VERSION}.jar" -O /usr/local/bin/apktool.jar \
    && chmod +x /usr/local/bin/apktool

# Android platform-tools (adb)
RUN wget -q "https://dl.google.com/android/repository/platform-tools-latest-linux.zip" -O /tmp/pt.zip \
    && unzip -q /tmp/pt.zip -d /opt \
    && ln -s /opt/platform-tools/adb /usr/local/bin/adb \
    && rm /tmp/pt.zip

RUN useradd -m -u 1000 student
USER student
WORKDIR /data
VOLUME ["/data"]

CMD ["bash"]
