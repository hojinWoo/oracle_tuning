/*
1. 테이블스페이스 생성
2. 유저 생성
3. 권한 부여
*/
-- sys 계정으로 해야함

-- 12c 이후 버전
-- ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;            -- 기존 방식으로 계정생성(12c 이상 버전에서 주석 풀고 실행)

-- ALTER SYSTEM SET SEC_CASE_SENSITIVE_LOGON = FALSE;  -- 대소문자 구분 안함(필요시 주석 풀고 실행)


-- 테이블 스페이스 생성
CREATE TABLESPACE MY_DATA DATAFILE 'C:\ORADATA\MY_DATA01.dbf' SIZE 30G AUTOEXTEND ON;
ALTER TABLESPACE MY_DATA ADD DATAFILE 'C:\ORADATA\MY_DATA02.dbf' SIZE 30G AUTOEXTEND ON; --  NEXT 50M MAXSIZE 2048M;
ALTER TABLESPACE MY_DATA ADD DATAFILE 'D:\ORADATA\MY_DATA03.dbf' SIZE 30G AUTOEXTEND ON; --  NEXT 50M MAXSIZE 2048M;

-- 유저 생성, 아이디 비번 설정, 디폴트 테이블 스페이스 설정
CREATE USER dev IDENTIFIED BY "tester"
DEFAULT TABLESPACE MY_DATA
PROFILE DEFAULT
QUOTA UNLIMITED ON MY_DATA;

-- 권한설정
GRANT connect, RESOURCE, DBA TO dev;    --> 모든 권한 주기


-- ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;    -- 비밀번호 만료기간을 무제한으로 변경(필요시 주석 풀고 실행)

