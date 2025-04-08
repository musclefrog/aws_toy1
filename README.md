# aws_toy1

< 환경 : Manager노드 1개, Worker노드 3개, Storage노드 1개 >
1. 각 노드에 Docker, Docker-Compose 패키지를 설치 & 매니저 노드에 Ansible 설치
2. docker swarm init/join 등을 통해 Swarm환경 구성하기
3. registry_set.yml 실행
   - 각 노드 user1의 Sudo권한 사용시 Password 입력을 NO로 설정 -> Ansible 구동 시 각 노드 접근에 대한 막힘을 방지
   - 사설 Registry Http 접근 허용을 위한 설정파일
4. creatingImg.yml 실행
   - Storage노드에 사설 레지스트리 생성 -> DockerHub에서 공식 모니터링 이미지 Pull후 Tag을 통해 커스터마이징
     -> 커스텀 이미지 사설 레지스트리로 Push
5. deployImg.yml 실행 - 사설 레지스트리로부터 각 노드에 이미지 배포(Pull)
6. docker stack -c docker-compose.yml monitoring 명령어를 통해 스택 배포
