##  오라클 튜닝 에센셜

Oracle Tuning Essential by 박찬권



- Oracle 실행 by docker

```bash
## docker 로그인
docker login

## 1) docker 이미지 실행(이미치 실행 처음인 경우)
# docker run --name oracle11g -d -p 1521:1521 jaspeen/oracle-xe-11g
## 2) 기조에 있다면 container 확인
docker container ls -a
## 3) container 실행
docker start oracle11g
## 4) container 중지 : stop (name), container 삭제 : rm (name)
## cf) 이미지 실행 시 컨테이너 종료 시 자동 삭제
docker run -d --rm --name oracle11g -p 1521:1521 jaspeen/oracle-xe-11g

## SQL PLUS 실행 (by terminal)
docker exec -it oracle11g sqlplus
# Enter user-name
system
# Enter password
oracle

## locale not recognize 오류 발생시 해당 파일에 해당 내용 추가
vi Desktop/SQLDeveloper.app/Contents/Resources/sqldeveloper/sqldeveloper/bin/sqldeveloper.conf

AddVMOption -Duser.language=ko 
AddVMOption -Duser.country=KR
```




### CF) 참고 기본 SQL

```sql
-- Table 조회
SELECT TABLE_NAME
  FROM ALL_TABLES
 WHERE OWNER      = :owner
   AND TABLE_NAME = :tbl_nm;

-- PK 정보 조회
SELECT 
	  A.TABLE_NAME
	, A.COLUMN_NAME
	, A.DATA_TYPE
	, A.DATA_LENGTH
	, A.DATA_PRECISION
	, A.DATA_SCALE
	, A.NULLABLE
	, B.COLUMN_POSITION
  FROM ALL_TAB_COLS A, ALL_IND_COLUMNS B
 WHERE A.OWNER			= B.TABLE_OWNER(+)
   AND A.TABLE_NAME		= B.TABLE_NAME(+)
   AND A.COLUMN_NAME	= B.COLUMN_NAME(+)
   AND A.OWNER			= :owner
   AND B.INDEX_NAME		= :index_name		-- index_name은 뒤에는 '_PK'로 끝나야 한다
 ORDER BY A.COLUMN_ID
```

