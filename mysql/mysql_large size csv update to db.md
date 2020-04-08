# 큰 사이즈 csv를 DB에 업로드하기

csv를 디비에 올리기에 대한 정석을 아직 찾은 것은 아닌 듯 하나 성공해낸 방법을 정리하고자 한다.

# 0. pymysql install
csv를 바로 DB로 올리는 방법을 안만 찾아봐도 테이블을 만들어야 했다.
그렇다면 테이블을 자동으로 만들어주는 쿼리문은 없을까 하고 또 암만 찾아봐도 없었다.
결국 python+mysql로 하기로 맘먹고! pymysql을 설치했다.

pymysl의 기본적인 구조는 다음과 같다.


```python
import pymysql
import csv
import ast
import pandas as pd
host_name = "localhost"
username = "sugyeong"
password = "12341234"
database_name = "kt_db"

db = pymysql.connect(
    host=host_name,  # DATABASE_HOST
    port=3306,
    user=username,  # DATABASE_USERNAME
    passwd=password,  # DATABASE_PASSWORD
    db=database_name,  # DATABASE_NAME
    charset='utf8'
)
cursor = db.cursor()
```
- ast 패키지는 타입을 정해주는 패키지라고 한다.
- db 정보를 입력, mysql과 연결한다. ```db.cursor```를 ```cursor```로 명령어를 저장하였다.



# 1. 테이블 만들기
내 아이디어는 테이블을 만들어주는 쿼리를 짜는 파이썬 코드를 만드는것이었다.
역시 누군가 해 놓은게 있었다.
>https://www.sisense.com/blog/python-create-table/

```python
f = open('/var/lib/mysql-files/kt/ULSAN_NG_201811.csv', 'r', encoding = 'utf-8-sig')
from itertools import islice
#f =pd.read_csv('./data/test_kt.csv', 'r')
reader = csv.reader(f)
longest, headers, type_list = [], [], []
```
- 'utf-8-sig'는 한국어 인코딩을 위함이다.

다음은 csv의 값들을 읽고, varchart로 할지, int로 할 지 정해주는 함수이다. 
```python
def dataType(val, current_type):
    try:
        # Evaluates numbers to an appropriate type, and strings an error
        t = ast.literal_eval(val)
    except ValueError:
        return 'varchar'
    except SyntaxError:
        return 'varchar'
    if type(t) in [int, float]:
        if (type(t) in [int]) and current_type not in ['float', 'varchar']:
            # Use smallest possible int type
            if (-32768 < t < 32767) and current_type not in ['int', 'bigint']:
                return 'smallint'
            elif (-2147483648 < t < 2147483647) and current_type not in ['bigint']:
                return 'int'
            else:
                return 'bigint'
        if type(t) is float and current_type not in ['varchar']:
            return 'decimal'
    else:
        return 'varchar'
```
다음은 파일을 읽고 -> 컬럼 이름을 뽑고 -> 컬럼 타입을 저장하는 코드인데, 원래코드는 한 줄 한 줄 다 읽어서 가장 길이가 긴 문자를 varchr에 할당시켜주기 위한 코드인듯 했다. 하지만 내 csv파일은 엄청 큰 파일이고, 모든 내용이 정형화되어있어서 5줄만 읽도록 수정하였다.
```python

for row in islice(reader, 0, 5) :
    if len(headers) == 0:
        headers = row
        for col in row:
            longest.append(0)
            type_list.append('')
    else:
        for i in range(len(row)):
            # NA is the csv null value
            if type_list[i] == 'varchar' or row[i] == 'NA':
                pass
            else:
                var_type = dataType(row[i], type_list[i])
                type_list[i] = var_type
        if len(row[i]) > longest[i]:
            longest[i] = len(row[i])
f.close()        
```
- csv.read에서 특정 행만 읽고 싶을 때 ```islice```가 가장 효과적인 듯 하다.
    - ```islice (csv.read(), [시작 행] ,[마지막 행])```
    >https://suwoni-codelab.com/python%20%EA%B8%B0%EB%B3%B8/2018/03/07/Python-Basic-itertools/


다음은 테이블 생성 쿼리를 만들어주는 코드이다.
```python
statement = 'create table kt_11 (' #kt_11 <- 테이블 이름

for i in range(len(headers)):
    if type_list[i] == 'varchar':
        statement = (statement + '\n{} varchar({}),').format(headers[i].lower(), str(longest[i]))
    else:
        statement = (statement + '\n' + '{} {}' + ',').format(headers[i].lower(), type_list[i])

statement = statement[:-1] + ');'
print(statement)
```
- 쿼리문을 먼저 확인하고 수정 해야 할 것은 테이블 만든 후에 하자!

다음은 쿼리문을 mysql에 보내주는 코드이다. 다음 코드가 가장 기본적인 pymysql의 기능인 듯 하다.
```python
cursor.execute(statement) #쿼리 날려주기
db.commit() #쿼리 실행
```

여기까지 코드를 작성했으면 일단 테이블은 만들었다. 



---

# 2. 테이블 수정
바로 입력하기 전 테이블 정보를 수정해 주어야 했다. 

1) 테이블 타입 수정 

*error* :
```bash
'_csv.reader' object is not subscriptable

DataError: (1406, "Data too long for column 'timezn_cd' at row 1")
```
=> 어떤 컬럼은 value와 타입이 안 맞았다. 'timezn_cd' 컬럼은 숫자 칼럼인데 varchar(0)으로 설정되어 있었고, 다음과 같이 바꿔주었다.


```python
#kt_11<- table 이름. timezn_cd <-컬럼 이름, int <- 수정 내용
sql = """
ALTER TABLE kt_11 MODIFY timezn_cd int; 
"""
cursor.execute(sql)
db.commit()
```


# 2. 데이터 삽입
대용량 csv 파일을 업로드하기에 가장 적합한 명령어는 LOAD DATA 명령어 인 듯 했다. 

```sql
LOAD DATA LOCAL INFILE '{file_name}'
INTO TABLE {table_name}
CHARACTER SET utf8
FIELDS
    TERMINATED BY '{field_terminator}'  # 각 필드 구분 문자 (예: CSV라면 컴마)
    OPTIONALLY ENCLOSED BY '"'  # 필요할 경우, 따옴표(")로 구분
LINE TERMINATED BY '\n'
IGNORE 1 LINES  # 제목이 포함된 첫 번째 줄은 생략
```
>https://ohgyun.com/777

다음은 내 실제 코드이다.

```python
sql = """
LOAD DATA INFILE '/var/lib/mysql-files/kt/ULSAN_NG_201806.csv'
INTO TABLE kt_db.kt_11
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;
"""
cursor.execute(sql)
db.commit()
```
이 부분에서 몇몇 에러가 났었고, 다음과 같이 해결하였다.

*error*
```
InternalError: (1366, 'Incorrect integer value: \'"100198947"\' for column \'id\' at row 1')
```
=> " "으로 나눠져 있는 경우에 나오는 에러이다. ```OPTIONALLY ENCLOSED BY '"'```으로 해결하였다.

=> 혹은 너무 strict한 삽입조건이 걸려있어서 일 수 있다. 나는 다음과 같이 조건을 풀어주었다.
```sql
select @@global.sql_mode; # sql삽입 모드 확인

set @@global.sql_mode = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'; #'STRICT_TRANS_TABLE'조건만 제거

set @@global.sql_mode = 'NO_ENGINE_SUBSTITUTION'; #나는 그냥 다 제거
```
>재시작 하면 초기화 된다고 한다.

>https://zibsin.net/2476

*error*
```
# If the last query was unbuffered, make sure it finishes before
```
=> 뭔가 돌아가고 있어서 그런거란다. 기다리니 됐다.

---
# 3. 결과 확인!

총 몇 줄이 만들어졌는지 확인해보았다.
```python
sql = """
select count(*) from kt_11;
"""
cursor.execute(sql)
db.commit()
cursor.fetchall()
```

끝!


