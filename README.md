#####WIP

< 환경 : Manager노드 2개, Worker노드 3개, Storage노드 1개 >

manager 1: 211.183.3.143  
manager 2: 211.183.3.144
storage: 211.183.3.150
worker1: 211.183.3.201
woker2: 211.183.3.202
woker3: 211.183.3.203


                            +---------------------+
                            |   📦 Storage VM     |
                            |   211.183.3.150      |
                            +----------+----------+
                                       |
                                       |
          +----------------------------+-----------------------------+
          |                                                          |
+---------------------+                                    +---------------------+
|  🖥️ Manager 1 VM      |                                    |  🖥️ Manager 2 VM      |
|  211.183.3.143       |                                    |  211.183.3.144       |
|  (Hosts Dashboards)  |                                    |                     |
+----------+-----------+                                    +----------+----------+
           |                                                          |
           |          🐳 Docker Swarm + Monitoring (Prometheus)       |
           +-------------------+------------------+------------------+
                               |                  |
                        +------+--+         +-----+----+       +-----+----+
                        | 🧱 Worker 1 VM |     | 🧱 Worker 2 VM |     | 🧱 Worker 3 VM |
                        | 211.183.3.201 |     | 211.183.3.202 |     | 211.183.3.203 |
                        +-------------+     +-------------+     +-------------+


### 설치 방법


1. 각 노드에 (all) Docker, Docker-Compose 패키지를 설치
   - sudo apt install docker && sudo apt install docker-compose 
3. 매니저 노드에 Ansible 설치
    - sudo apt install ansible
#### sudo /etc/hostname 수정 
### sudo apt update
####sudo apt install sshpass - y   
4. 매니저 노드에서 레지스트리 구성
   - ansible-playbook -i server.lst registry_set.yml -k
5. docker swarm init/join 등을 통해 Swarm환경 구성하기
  - ansible-playbook -i docker-server.lst swarm-join.yml -k
6. docker node promote submanager # submanger를 subleader로 승급
7. ansible-playbook -i server.lst createImg.yml -k
   - 각 노드 user1의 Sudo권한 사용시 Password 입력을 NO로 설정 -> Ansible 구동 시 각 노드 접근에 대한 막힘을 방지
   - 사설 Registry Http 접근 허용을 위한 설정파일
   - Ansible Playbook 실행 후 storage 서버에서 docker image ls 로 이미지 업로드 된 것 검증, 다른 노드에는 아직 이미지 X
8.ansible-playbook -i server.lst deployImg.yml #
  - 각각의 노드에서 docker image ls 로 
7. ansible-playbook -i server.lst creatingImg.yml # 레지스트리에 커스텀 이미지 생성????
   - Storage노드에 사설 레지스트리 생성 -> DockerHub에서 공식 모니터링 이미지 Pull후 Tag을 통해 커스터마이징
     -> 커스텀 이미지 사설 레지스트리로 Push
8. ansible-playbook -i server.ls deployImg.yml  # 앤서블 플레이북을 사용하여 사설 레지스트리로부터 각 노드에 이미지 배포(Pull)
9. docker stack -c docker-compose.yml monitoring # 도커를 사용하여 스택 배포
