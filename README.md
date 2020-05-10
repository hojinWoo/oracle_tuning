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