# realtime server monitoring
## network 환경
<node 구성>
- manager: 3
- worker: 3
- storage: 1

<각 노드 ip>
- manager: `211.183.3.100`
- submanager: `211.183.3.101`
- submanager2: `211.183.3.102`

- worker1: `211.183.3.201`
- worker2: `211.183.3.202`
- worker3: `211.183.3.203`

- storage: `211.183.3.150`      

```           
                            +-----------------------+
                            |   📦 Storage VM       |
                            |   211.183.3.150       |
                            +----------+-----------+
                                       |
                                       |
          +----------------------------+------------------------------+
          |                            |                              |
+---------------------+   +----------------------+   +----------------------+
|  🖥️ Manager VM      |  |  🖥️ Sub-Manager VM   |  |  🖥️ Sub-Manager2 VM   |
|  211.183.3.100       |  |  211.183.3.101       |  |  211.183.3.102         |
|  (Hosts Dashboards)  |  |                      |  |                        |
+----------+-----------+  +----------+-----------+  +------------+-----------+
           \__________________________|_________________________/
                     🐳 Docker Swarm + Monitoring (Prometheus)
                                      |
                 +--------------------+----------------------+
                 |                    |                      |
           +-----+--------+    +------+-------+      +-------+------+
           | 🧱 Worker 1  |    | 🧱 Worker 2 |      | 🧱 Worker 3  |
           | 211.183.3.201 |   | 211.183.3.202 |     | 211.183.3.203 |
           +-------------+     +---------------+     +---------------+
```

## 파일 설명
- `README.md`: server 환경 소개 및 실행 방식 설명
- `registry_set.yml`: http를 통해 사설 저장소 접근 허용 설정, ssh 접속 시 sudo 비밀번호 입력 생략을 위한 설정 및 Docker 재시작
- `createImg.yml`: 사설 저장소 생성, Docker Image 생성, 이미지 커스터마이징, 사설 저장소로 push
- `deployImg.yml`: NodeExporter, cAdvisor, Prometheus, Grafana 이미지 pull
- `swarm-join.yml`: Docker Swarm 실행 및 worker 조인
- `docker-compose.yml`: Docker Swarm 모니터링 스택 배포
- `grafana_template.json`: Grafana dashboard import용 json 파일
- `prometheus.yml`: Prometheus를 통한 모니터링 대상 설정
- `server.lst`: 환경에 맞는 ip 등록


## 설치 방법
1. 각 YML 파일의 IP를 환경에 맞게 변경
	- `creatingImg.yml` -> storage IP 설정
	- `deployImg.yml` -> storage IP 설정
	- `docker-compose.yml` -> storage IP 설정
	- `registry_set.yml` -> storage IP 설정
	- `swarm-join.yml` -> manager IP 설정
	- `prometheus.yml` -> 모든 노드 IP 설정
	- `server.lst` -> 모든 노드 IP 설정

2. 모든 노드) Python, Docker, Docker Compose 패키지를 설치
	- `sudo apt install -y python3-pip && sudo apt install docker && sudo apt install docker-compose`
	
3. manager) Ansible 설치
	- `sudo apt install ansible`
	
4. manager) Docker registry 구성
	- `ansible-playbook -i server.lst registry_set.yml -k`

5. manager) Docker Swarm 환경 구성
	- `ansible-playbook -i server.lst swarm-join.yml`
	
6. manager) submanager, submanager2를 매니저로 승격
	- `docker node promote submanager submanager2`

7. manager) Docker Image 생성 및 사설 registry로 push
	- `ansible-playbook -i server.lst createImg.yml -k`
	
8. manager) 사설 Docker registry로부터 각 노드에 Image 배포
	- `ansible-playbook -i server.ls deployImg.yml`
	
9. manager) Docker stack을 사용하여 배포
	- `docker stack deploy -c docker-compose.yml monitoring`

## Grafana 시각화
1. browser에서 `http://<manager_IP>:9090/targets` 접속
	- 모든 노드의 cAdvisor, Node Exporter의 state가 'up' 상태인지 확인

2. browser에서 `http://<manager_IP>:3000` 접속
	- menu > `Data sources` > `Add data source` > Prometheus 선택
	- Connection: `http://<manager_IP>:9090`
	- `Save & test`
	- `building a dashboard` > `Import dashboard` > `discard`
	- `Upload dashboard JSON file` > `grafana_template.json` 파일 `Import`