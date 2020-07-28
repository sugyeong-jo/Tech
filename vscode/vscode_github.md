# Github 연결

처음 github 연결을 하려 하면 permission denined가 뜰 수 있다. 
### 1. 폴더 sudo 권한 주기

```
chmod -R user_name folder_name
```

- user_name : sugyeong
- folder_name : sugyeong


### 2. Github 로그인 정보 저장

일단 현재 세팅 상태를 확인해보자. 

```
$ git config --list --show-origin
```

자격은 다음과 같이 저장할 수 있다.
```
$ git config --global user.name "John Doe"
$ git config --global user.email johndoe@example.com
```
- https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup