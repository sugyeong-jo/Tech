# Docker 실행 및 종료

```bash
//Docker login
docker login

//Docker 시작
docker start [Docker container]

//Docker 접속
docker attach [Docker container]

//Docker 종료
docker stop [Docker contatiner]
```


#  Docker image 관련 명령어
- 동작중인 이미지 확인
```bash
docker images 
```
- 이미지 삭제
```bash
docker rmi [이미지id] 
```
- 컨테이너 삭제 전 이미지를 삭제 할 경우
```bash
docker rmi -f [이미지id] 
```

# Docker container 관련 명령어
- 동작중인 컨테이너 확인
```bash
docker ps 
```
- 모든 컨테이너 확인
```bash
docker ps -a
```
- 컨테이너 삭제
```bash
docker rm [컨테이너id], [컨테이너id] 
```
- 컨테이너 모두 삭제
```bash
docker rm 'docker ps -a -q'
```


#### Reference
- https://brunch.co.kr/@hopeless/10
