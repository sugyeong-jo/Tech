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

---
## 테이블 관련
**DB 테이블 확인**
```sql
SHOW TABLES;
```

**DB 테이블 추가**
```sql

```
**DB 테이블 수정**
```sql

```

**DB 테이블 제거**
```sql
DROP TABLE 테이블명 [CASCADE CONSTRAINT];
or
DROP TABLE PLAYER;
```
- DROP TABLE 명령어를 사용하면 테이블의 모든 데이터 및 구조를 삭제한다.
- CASCADE CONSTRAINT 옵션은 해당 테이블과 관계가 있었던 참조되는 제약조건에 대해서도 삭제한다는 것을 의미한다. 
    - SQL Server에서는 CASCADE 옵션이 존재하지 않는다. 테이블 삭제 전에 참조하는 FOREIGN KEY 제약 등을 먼저 삭제해야 한다.


**DB 테이블 이름 변경**
```sql
RENAME 변경전 테이블 명 TO 변경 후 테이블 명;
```
