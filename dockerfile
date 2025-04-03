# Base image 선택
FROM ubuntu:latest

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*

# 최신 Node Exporter 버전 가져오기 및 설치
ARG NODE_EXPORTER_VERSION=1.9.1  # 최신 버전 수동 지정
RUN wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-1.9.1.linux-amd64.tar.gz \
    && tar xvfz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz \
    && mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/ \
    && rm -rf node_exporter-*

# 최신 cAdvisor 다운로드 및 설치
RUN curl -L -o cadvisor https://github.com/google/cadvisor/releases/download/v0.52.1/cadvisor-v0.52.1-linux-amd64 \
    && chmod +x cadvisor \
    && mv cadvisor /usr/local/bin/

# 실행 스크립트 복사
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 컨테이너 실행 명령어
CMD ["/entrypoint.sh"]