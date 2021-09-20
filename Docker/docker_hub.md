
1. Commit
```bash
docker commit [container] [image_name]:[tag]
```
예:
```bash
docker commit j_python j_python:0.2
```
2. push
```bash
docker login
docker tag [image_name]:[tag] [docker_user_id]/[image_name]:[tag]
docker push [docker_user_id]/[image_name]:[tag]
```
예:
```bash
docker tag j_python:0.2 sugyeong/j_python:0.2
docker push sugyeong/j_python:0.2
```

#### reference
- https://nicewoong.github.io/development/2018/03/06/docker-commit-container/
