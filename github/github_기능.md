## git 올리기
1. ```git add <filename>``` : 깃 올리기
    - ```git add --all```: 달라진거 모두 올리기
2. ```git commit -m "message"``` : commit
3. ```git push```: push

## error 정리
```
Another git process seems to be running in this repository, e.g.
an editor opened by 'git commit'. Please make sure all processes
are terminated then try again. If it still fails, a git process
may have crashed in this repository earlier:
remove the file manually to continue.
```
- 말그대로 지우면 된다.
```bash
rm -f .git/index.lock
```

