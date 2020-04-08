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

--- 
## DB 관련
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
**DB 만들기 (예시)**

```sql
CREATE DATABASE student_mgmt DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
```

---
## 테이블 관련
**DB 테이블 확인**
```sql
SHOW TABLES;
```

**DB 테이블 추가 (예시)**

```sql
CREATE TABLE students (
  id TINYINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(10) NOT NULL,
  gender ENUM('man','woman') NOT NULL,
  birth DATE NOT NULL,
  english TINYINT NOT NULL,
  math TINYINT NOT NULL,
  korean TINYINT NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

**DB 테이블 요소 추가 (예시)**
```sql
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('dave', 'man', '1983-07-16', 90, 80, 71);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('minsun', 'woman', '1982-10-16', 30, 88, 60);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('david', 'man', '1982-12-10', 78, 77, 30);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('jade', 'man', '1979-11-1', 45, 66, 20);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('jane', 'man', '1990-11-12', 65, 32, 90);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('wage', 'woman', '1982-1-13', 76, 30, 80);
INSERT INTO students (name, gender, birth, english, math, korean) VALUES ('tina', 'woman', '1982-12-3', 87, 62, 71);
```

**DB 테이블 컬럼 타입 수정**
```sql
ALTER TABLE 테이블명 MODIFY 컬럼 변경타입;
# 변경타입  ex) VARCHAR(8)
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
RENAME TABLE 변경전 테이블 명 TO 변경 후 테이블 명;
```

---

**select with pymysql**

```python
sql = "SELECT id, total FROM kt group by id;"
df = pd.read_sql(sql, db)
```

*error*

```
Error this is incompatible with sql_mode=only_full_group_by
```

```sql
set session 
sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```

