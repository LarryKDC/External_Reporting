SELECT
 '129' AS LEA_ID
, '2015-2016' AS SCHOOL_YEAR 
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') AS COLLECTION_DATE
, 'Contacts' AS COLLECTION_TYPE
, TO_CHAR(s.id) AS SIS_ID 
, '' AS CONTACT_ID 
, '' AS CONTACT_TYPE
, '' AS PRIMARY_GUARDIAN_INDICATOR 
, CASE
    WHEN REGEXP_COUNT(s.mother,'[ ,]') = 0 THEN s.mother
    ELSE
      CASE
        WHEN REGEXP_COUNT(s.mother,',') = 0 THEN SUBSTR(s.mother,REGEXP_INSTR(s.mother,' ',1,REGEXP_COUNT(s.mother,' ')) + 1)
        ELSE SUBSTR(s.mother,1,REGEXP_INSTR(s.mother,',',1,REGEXP_COUNT(s.mother,','))-1)
      END
  END CONTACT_LAST_NAME
, CASE
    WHEN REGEXP_COUNT(s.mother,'[ ,]') = 0 THEN NULL
    ELSE
      CASE
        WHEN REGEXP_COUNT(s.mother,',') = 0 THEN SUBSTR(s.mother,1,REGEXP_INSTR(s.mother,' ',1,REGEXP_COUNT(s.mother,' ')) - 1)
        ELSE SUBSTR(s.mother,REGEXP_INSTR(s.mother,',',1,REGEXP_COUNT(s.mother,',')) + 2)
      END
  END CONTACT_FIRST_NAME
, NULL CONTACT_MIDDLE_NAME
, '' AS CONTACT_PHONE_TYPE
, CASE WHEN (COALESCE(ps_customfields.getStudentsCF(s.id,'motherdayphone'),s.home_phone)) IS NOT NULL THEN 
  '('||SUBSTR(COALESCE(ps_customfields.getStudentsCF(s.id,'motherdayphone'),s.home_phone),0,3)||') '||SUBSTR(COALESCE(ps_customfields.getStudentsCF(s.id,'motherdayphone'),s.home_phone),5)
  END CONTACT_PHONE_NUMBER
, ps_customfields.getStudentsCF(s.id,'Mother_Email') CONTACT_EMAIL_ADDRESS 
,'' AS ADD_TYPE 
, s.street ADD_STREET
, NULL ADD_APT
, NULL ADD_BLDG
, s.city ADD_CITY
, s.state ADD_STATE
, s.zip ADD_ZIP
from students s
