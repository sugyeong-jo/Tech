# ssh 코드 얻기
1. mysql 로그인
```bash
mysql -p
```
2. ssh key 얻기
```sql
select host, user, authentication_string from mysql.user;
```

# mysql 기본 명령어
**user 조회**
```sql
SELECT USER, host FROM USER;
```

**DB 조회**
```sql
SHOW DATABASES;
```

**현재 사용중인 DB 확인**
```sql
SELECT DATABASE();
```

**현재 사용중인 DB 변경**
```sql
USE <DB>
```

**DB 테이블 확인**
```sql
SHOW TABLES;
```
