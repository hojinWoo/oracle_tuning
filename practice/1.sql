/*
1. ���̺����̽� ����
2. ���� ����
3. ���� �ο�
*/
-- sys �������� �ؾ���

-- 12c ���� ����
-- ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;            -- ���� ������� ��������(12c �̻� �������� �ּ� Ǯ�� ����)

-- ALTER SYSTEM SET SEC_CASE_SENSITIVE_LOGON = FALSE;  -- ��ҹ��� ���� ����(�ʿ�� �ּ� Ǯ�� ����)


-- ���̺� �����̽� ����
CREATE TABLESPACE MY_DATA DATAFILE 'C:\ORADATA\MY_DATA01.dbf' SIZE 30G AUTOEXTEND ON;
ALTER TABLESPACE MY_DATA ADD DATAFILE 'C:\ORADATA\MY_DATA02.dbf' SIZE 30G AUTOEXTEND ON; --  NEXT 50M MAXSIZE 2048M;
ALTER TABLESPACE MY_DATA ADD DATAFILE 'D:\ORADATA\MY_DATA03.dbf' SIZE 30G AUTOEXTEND ON; --  NEXT 50M MAXSIZE 2048M;

-- ���� ����, ���̵� ��� ����, ����Ʈ ���̺� �����̽� ����
CREATE USER dev IDENTIFIED BY "tester"
DEFAULT TABLESPACE MY_DATA
PROFILE DEFAULT
QUOTA UNLIMITED ON MY_DATA;

-- ���Ѽ���
GRANT connect, RESOURCE, DBA TO dev;    --> ��� ���� �ֱ�


-- ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;    -- ��й�ȣ ����Ⱓ�� ���������� ����(�ʿ�� �ּ� Ǯ�� ����)

