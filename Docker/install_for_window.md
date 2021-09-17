Window 10에 docker로 개발환경 만들기!

# Step 1: resource file 다운로드
- install linux distro 
    -  예: UBUNTU 
- Install Docker Desktop on Window
- Install Github for window
- Install visual studio code
- WSL2 설치 및 활성화
    - Docker는 WSL2 이어야 함 
```bash
wsl -l -v #WSL 버전 확인
wsl --set-version [distro] 2 #distro version 2로 만들기 예: wsl --set-version ubuntu 2 

```

# Step 2: Docker image 만들기 
## 2-1: 직접 이미지 작성
### 2-1-1: Dockerfile 작성
파일이름은 `Dockerfile`로 작성
```vim
FROM python:latest
MAINTAINER sugyeong.jo@unist.ac.kr

RUN pip install --upgrade pip
RUN pip install pandas
RUN pip install numpy
RUN pip install mip
RUN pip install sklearn
RUN pip install scipy
RUN pip install matplotlib
```
- `FROME` : docker hub에 올라와 있는 image 이름 
    - 'official' image는 안정적! 
    - {image name}:{tag} 순서
- `MAINTAINER` : 작성자 이름
- `RUN` : command 명령
- 기타 명령어는 공식 홈페이지 참고


### 2-1-2: Docker image 생성
```bash
docker build -t [이미지id]:[tag] [Dockfile 있는 경로]
```
예:
```bash
docker build -t j_python:0.1 ./
```
## 2-2: docker hub에 있는 image 사용
### 도커이미지 찾기
```bash
docker search --filter "is-official=true" python 

docker search python
```

## 2-3: Docker image 당겨오기 
```bash
docker pull [이미지id]:[tag
```

# Step 3: Docker container 만들기
```bash
docker run -it --volumn="[host system directory]:[container directory]" --name [container name] [이미지id]:[tag] [ARG...]
```
- `run` : 명령어로 컨테이너 생성
- `it` : 컨테이너와 터미널로 입출력 가능하도록 함

예:
```bash
docker run -it --volume="C:\Users\jclar\Documents\dataset:/home/workspace" --name j_python j_python:0.1 /bin/bash

docker run -it --volume="F:\UNIST\OneDrive - UNIST\Attachments\data:/home/workspace" --name j_python j_python:0.1 /bin/bash
```
- onedrive path도 가능! 
- 마지막 `bin/bash`는 바로 사용할 수 있게 하기 위해서~!

#### Reference
- (1) https://docs.docker.com/desktop/windows/install/
- (1) https://docs.microsoft.com/ko-kr/windows/wsl/tutorials/wsl-containers
- (1) https://docs.microsoft.com/en-us/windows/wsl/wsl-config
- (2-1, 2-3) https://musclebear.tistory.com/113?category=797910
- (2-1) https://docs.docker.com/develop/develop-images/baseimages/
- (2-1) https://cultivo-hy.github.io/docker/image/usage/2019/03/14/Docker%EC%A0%95%EB%A6%AC/
- (2-1, 2-2) https://tootouch.github.io/setting/docker_image_build/
- (2-2) https://docs.docker.com/engine/reference/builder/
- (3) https://docs.docker.com/engine/reference/commandline/create/
