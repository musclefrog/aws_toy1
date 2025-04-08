1. server.lst 에서 [worker] worker들의 ip를 입력 합니다.
2. [manager]는 yml을 실행하는 swarm을 만드는 관리자의 ip를 입력합니다.
3. [all] 관리자 이외의 ip를 넣어주세요.
4. [promote_ip]는 worker에서 promote를 승격할 worker의 ip를 입력합니다.
5. ansible-playbook -i server.lst swarm-join.yml 명령어를 입력합니다. (swarm을 만들고 worker들을 swarm에 join하는 과정)
6. ansible-playbook -i server.lst manager-promote.yml 명령어를 입력합니다 (swarm에 있는 worker들을 매니저로 승격합니다.)