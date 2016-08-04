SELECT
 '129' AS LEA_ID
, '2015-2016' AS SCHOOL_YEAR 
, TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI') AS COLLECTION_DATE
, 'Contacts' AS COLLECTION_TYPE
, TO_CHAR(s.student_number) AS SIS_ID
, '' AS CONTACT_ID
, case when mother is not null then 111 else 121 end AS CONTACT_TYPE
, case when ps_customfields.getStudentsCF(s.id,'guardian')='Mother' then 'Y' else 'N' end  AS PRIMARY_GUARDIAN_INDICATOR 
, substr(mother,instr(mother,' ')+1) as CONTACT_FIRST_NAME
, '' AS CONTACT_MIDDLE_NAME
, substr(mother,0,instr(mother,' ')-2) AS CONTACT_LAST_NAME
, '' AS PHONE_NUMBER_TYPE
, s.home_phone AS PHONE_NUMBER
, '' AS EMAIL_ADDRESS
, case when ps_customfields.getStudentsCF(s.id,'mother_street') is not null then 'MAIL' else null end AS ADDRESS_TYPE
, s.street AS STREET_ADDRESS
, '' AS APARTMENT_NUMBER
, '' AS BUILDING_SITE_NUMBER
, s.city  AS CITY
, s.state as STATE
, s.zip AS ZIP_CODE
from students s
where s.entrydate > = '01-JUL-16'

