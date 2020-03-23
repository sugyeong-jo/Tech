# Mysql 설치 (Install)

## 1. mysql  인증모듈설치

``` shell
sudo apt-get install libapache2-mod-auth-mysql
```

## 2. mysql 설치
```shell
sudo apt-get install mysql-server mysql-client
```



## 3.  mysql  실행

```bash
mysql
```

이렇게 입력했더니 다음같은 에러가 나왔다!

> ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)

### 3-1. error 해결

(1) 찾아보니 이건 Mysql을 새로 설치하면 암호가 없어서 발생하는 문제라고 한다.
이 문제를 해결하기 위해 다음을 입력해서 관리자 권한으로 mysql에 접속한다.

```bash
sudo mysql -u root
```
이때 password 는 수도권한에 대한 password 였다.

(2) 그럼 mysql 이 작동되고, 이제 root에 대한 비밀번호를 변경해 주면 된다.
```mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
```
- 여기서 *root*는 비밀번호이다. 

(3) mysql을 종료하고

```mysql
exit
```

(4) 서비스를 재 구동한다.
```bash
sudo service mysql restart
```

### 4. mysql다시 접속!

```bash
mysql -u root -p
```

잘 접속 될 겁니다!

**Reference**
- https://opentutorials.org/course/195/1465
- https://sosobaba.tistory.com/217
