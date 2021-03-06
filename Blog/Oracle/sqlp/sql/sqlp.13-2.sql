CREATE TABLE 수험결과
(
    수험일자 VARCHAR2(8),
    수험번호 NUMBER,
    국어 NUMBER,
    수학 NUMBER,
    영어 NUMBER
);

CREATE TABLE 고득점결과
(
    수험일자 VARCHAR2(8),
    수험번호 NUMBER,
    과목코드 VARCHAR2(2),
    점수 NUMBER
);

CREATE TABLE 성적집계
(
    수험일자 VARCHAR2(8),
    국어평균 NUMBER,
    수학평균 NUMBER,
    영어평균 NUMBER,
    총점평균 NUMBER,
    최고총점 NUMBER,
    최고총점학생수 NUMBER
);

INSERT INTO 수험결과 VALUES ('20140617', 1, 85, 92, 87);
INSERT INTO 수험결과 VALUES ('20140617', 2, 92, 90, 82);
INSERT INTO 수험결과 VALUES ('20140617', 3, 97, 71, 68);

SELECT 수험결과.*, 국어+수학+영어 FROM 수험결과;

-- 13-2 1)

INSERT INTO 고득점결과
SELECT 수험일자, 수험번호,
       DECODE(N, 1,'01', 2,'02', 3,'03'),
       DECODE(N, 1,국어, 2,수학, 3,영어)
  FROM (
SELECT 수험결과.*, N
  FROM 수험결과, (SELECT ROWNUM N FROM DUAL CONNECT BY LEVEL <= 3)
       )
 WHERE (N = 1 AND 국어 >= 90)
    OR (N = 2 AND 수학 >= 90)
    OR (N = 3 AND 영어 >= 90);

SELECT * FROM 고득점결과;

-- 13-2 2)
INSERT INTO 성적집계
SELECT 수험일자, AVG(국어), AVG(수학), AVG(영어), AVG(총점), MAX(총점),
       SUM(DECODE(R,1,1))
  FROM (
SELECT 수험일자, 국어, 영어, 수학, 국어+영어+수학 총점,
       RANK() OVER (ORDER BY (국어+영어+수학) DESC) R
  FROM 수험결과
 WHERE 수험일자 = '20140617'
       )
  GROUP BY 수험일자;

SELECT * FROM 성적집계;

