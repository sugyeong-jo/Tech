
1. Commit
```bash
docker commit [container] [image_name]:[tag]
```
예:
```bash
docker commit j_python j_python:0.1
```
2. push
```bash
docker login
docker tag [image_name]:[tag] [docker_id_user]/[image_name]:[tag]
```
예:
```bash
docker tag j_python:0.1 sugyeong/j_python:0.1
```

3.
4. 
#### reference
- https://nicewoong.github.io/development/2018/03/06/docker-commit-container/
