/*
  PROCEDURE 생성
  PARAM : P_GEN_AMOUNT (건수), P_COMMIT_NUM (Commit 건수 단위)
*/
CREATE OR REPLACE PROCEDURE DEV.GENERATE_ORD_BASE (P_GEN_AMOUNT NUMBER, P_COMMIT_NUM NUMBER)
IS
    V_QUOTIENT      NUMBER;
    V_REMAINDER     NUMBER;
    V_COMMIT_CNT    NUMBER := 0;

    V_ERR_CD        NUMBER;
    V_ERR_MSG       VARCHAR(1024);
BEGIN

    SELECT  CEIL(P_GEN_AMOUNT/P_COMMIT_NUM), MOD(P_GEN_AMOUNT,P_COMMIT_NUM) INTO V_QUOTIENT, V_REMAINDER
    FROM    DUAL;


    FOR i IN 1..V_QUOTIENT LOOP

        INSERT  /*+ APPEND */  INTO DEV.ORD_TEMP (
                ORD_DT
              , ORD_HMS
              , SHOP_NO
              , UPPER2
              , UPPER_CASE
              , LOWER_CASE
              , ALPHABET
              , ALPHABET_NUMERIC
            )
        SELECT
                YYYY || MM ||
                CASE
                    WHEN MM = '02' THEN TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 29)), 'FM09')
                    WHEN MM IN ('04','06','09','11') THEN TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 31)), 'FM09')
                    ELSE TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 32)), 'FM09')
                END     ORD_DT
              , HH || MI || SS  ORD_HMS
              , SHOP_NO
              , UPPER2
              , UPPER_CASE
              , LOWER_CASE
              , ALPHABET
              , ALPHABET_NUMERIC
        FROM    (
                    SELECT
                            TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(2012, 2014))) YYYY
                          , TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 13)), 'FM09') MM
                          , TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(9, 23)), 'FM09') HH
                          , TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 60)), 'FM09') MI
                          , TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 60)), 'FM09') SS
                          , 'SH' || LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 201)),4,'0') SHOP_NO
                          , DBMS_RANDOM.STRING('U', 2) UPPER2
                          , DBMS_RANDOM.STRING('U', 10) UPPER_CASE
                          , DBMS_RANDOM.STRING('L', 10) LOWER_CASE
                          , DBMS_RANDOM.STRING('A', 100) ALPHABET
                          , DBMS_RANDOM.STRING('X', 100) ALPHABET_NUMERIC
                    FROM    DUAL
                    CONNECT BY LEVEL <= CASE
                                            WHEN i < V_QUOTIENT THEN P_COMMIT_NUM
                                            WHEN V_REMAINDER = 0 AND i = V_QUOTIENT THEN P_COMMIT_NUM
                                            ELSE V_REMAINDER
                                        END
                )
        WHERE   1 = 1;

        V_COMMIT_CNT := V_COMMIT_CNT + SQL%ROWCOUNT;

        COMMIT;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_COMMIT_CNT) || '건이 저장되었습니다.');

EXCEPTION

    WHEN OTHERS THEN
        V_ERR_CD  := SQLCODE;
        V_ERR_MSG := SUBSTR(SQLERRM,1,1024);

        DBMS_OUTPUT.PUT_LINE('error code : '||V_ERR_CD||' - error msg : '||V_ERR_MSG);

END;
/


CREATE OR REPLACE PROCEDURE DEV.INSERT_ORD_ITEM (P_GEN_AMOUNT NUMBER, P_COMMIT_NUM NUMBER)
IS
    V_QUOTIENT      NUMBER;
    V_REMAINDER     NUMBER;
    V_START_IDX     NUMBER := 1;
    V_END_IDX       NUMBER;
    i               INT;
    j               INT;
    V_COMMIT_CNT    NUMBER := 0;

    V_ERR_CD        NUMBER;
    V_ERR_MSG       VARCHAR(1024);
BEGIN

    SELECT  CEIL(P_GEN_AMOUNT/P_COMMIT_NUM), MOD(P_GEN_AMOUNT,P_COMMIT_NUM) INTO V_QUOTIENT, V_REMAINDER FROM DUAL;

    IF V_QUOTIENT = 1 AND V_REMAINDER > 0 THEN
        V_END_IDX := V_REMAINDER;
    ELSE
        V_END_IDX := P_COMMIT_NUM;
    END IF;

    FOR i IN 1..V_QUOTIENT LOOP

        FOR j IN V_START_IDX..V_END_IDX LOOP

            INSERT  INTO DEV.ORD_ITEM (
                    ORD_NO
                  , ITEM_ID
                  , ORD_ITEM_QTY
                  , ORD_DT
                  , ORD_HMS, UPPER2
                  , UPPER_CASE
                  , LOWER_CASE
                  , ALPHABET
                  , ALPHABET_NUMERIC
                )
            SELECT
                    ORD_NO
                  , ITEM_ID
                  , ITEM_QTY
                  , ORD_DT
                  , ORD_HMS
                  , UPPER2
                  , UPPER_CASE
                  , LOWER_CASE
                  , ALPHABET
                  , ALPHABET_NUMERIC
            FROM    (
                        SELECT
                                A.ORD_NO
                              , A.ITEM_ID
                              , A.ITEM_QTY
                              , O.ORD_DT
                              , O.ORD_HMS
                              , O.UPPER2
                              , O.UPPER_CASE
                              , O.LOWER_CASE
                              , O.ALPHABET
                              , O.ALPHABET_NUMERIC
                        FROM    (
                                    SELECT
                                            ORD_NO
                                          , ITEM_ID
                                          , SUM(ITEM_QTY) ITEM_QTY
                                    FROM    (
                                                SELECT
                                                        j ORD_NO
                                                      , TRUNC(DBMS_RANDOM.VALUE(1, 93)) ITEM_ID
                                                      , TRUNC(DBMS_RANDOM.VALUE(1, 10)) ITEM_QTY
                                                FROM    DUAL
                                                CONNECT BY LEVEL <= (SELECT TRUNC(DBMS_RANDOM.VALUE(1, 5)) FROM DUAL)
                                            ) A
                                    GROUP BY ORD_NO, ITEM_ID
                                ) A
                              , DEV.ORD O
                        WHERE   1 = 1
                        AND     A.ORD_NO = O.ORD_NO
                    )
            WHERE   1 = 1;

            V_COMMIT_CNT := V_COMMIT_CNT + SQL%ROWCOUNT;

        END LOOP;

        COMMIT;

        IF i < V_QUOTIENT THEN
            V_START_IDX := V_END_IDX + 1;
            V_END_IDX := V_END_IDX + P_COMMIT_NUM;
        ELSIF V_REMAINDER = 0 AND i = V_QUOTIENT THEN
            V_START_IDX := V_END_IDX + 1;
            V_END_IDX := V_END_IDX + P_COMMIT_NUM;
        ELSE
            V_START_IDX := V_END_IDX + 1;
            V_END_IDX := V_END_IDX + V_REMAINDER;
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(V_END_IDX - P_COMMIT_NUM) || '건의 주문에 대한 주문상품 ' || TO_CHAR(V_COMMIT_CNT) || '건이 저장되었습니다.');

EXCEPTION

    WHEN OTHERS THEN
        V_ERR_CD  := SQLCODE;
        V_ERR_MSG := SUBSTR(SQLERRM,1,1024);

        DBMS_OUTPUT.PUT_LINE('error code : '||V_ERR_CD||' - error msg : '||V_ERR_MSG);

END;
/
