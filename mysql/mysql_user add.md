# Mysql 사용자 추가 (user add)

## 1. root계정으로 mysql 로그인

``` bash
mysql -u root -p
```
패스워드 입력 후 다음 코드 실행

## 2. 사용자 계정 만들기
- 로컬에서 접속 가능한 사용자 추가
```mysql
create user '사용자'@'localhost' identified by '비밀번호';
```
>만약 원격에서 접속가능한 사용자에게 권한을 부여하고자 하면, *localhost* 부분에 ip를 입력해주면 됨

## 3.  DB 권한 부여
```mysql
grant all privileges on *.* to '사용자'@'localhost';
grant all privileges on DB이름.* to '사용자'@'localhost';
```
- 모든 DB에 접근가능하도록 하려면 ```*.*```, 특정 DB에만 접근가능하도록 하려면 ```DB이름```으로 지정해주면 된다.

## 4. 사용자 계정 삭제

```mysql
drop user '사용자'@'localhost';
```

**Reference**
- https://cjh5414.github.io/mysql-create-user/ 