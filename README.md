# aws_toy1

| 2025.4.2 - 2025.4.10

### 1. 프로젝트 주제: 실시간 서버 상태 모니터링 컨테이너

### 2. 프로젝트 개요
- 컨테이너를 실행하면 서버의 **CPU 사용률, 메모리 사용량, 네트워크 트래픽 등**을 자동으로 수집
- cAdvisor를 사용하여 컨테이너 상태 수집
- Prometheus를 통해 메트릭을 수집하고, Grafana에서 시각화하여 실시간 서버 상태 및 컨테이너 상태 확인 가능
- Docker Hub에 올려서 누구나 pull해서 사용할 수 있고, 실행한 서버의 상태를 Grafana 대시보드로 실시간 모니터링

### 3. 기술 스택
- Docker + Prometheus + Grafana, Node Exporter (Linux 시스템 메트릭 수집)
- cAdvisor
- promQL

### 4. 구성 요소
- Node Exporter -> 서버의 상태 정보를 수집하는 에이전트
- Prometheus -> 수집한 데이터를 저장하는 모니터링 툴
- Grafana -> 데이터를 시각화하여 보기 쉽게 정리하는 대시보드

### 5. 최종 목표 
- 사용자가 docker hub에서 이미지 pull 후 `docker run -d --name node-exporter --net=host prom/node-exporter` 명령어 실행하면 서버 상태 메트릭이 확인 가능하도록 할 것.