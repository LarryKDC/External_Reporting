SELECT
 '129' AS LEA_ID
, '2015-2016' AS SCHOOL_YEAR
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') AS COLLECTION_DATE
, 'Demographics' AS COLLECTION_TYPE
, TO_CHAR(s.student_number) AS SIS_ID
, TO_NUMBER(REGEXP_REPLACE(ps_customfields.getStudentsCF(s.id,'State_USI'),'[^0-9]','')) AS USI
, '' AS LEA_Student_ID
, s.first_name AS FIRST_NAME
, s.middle_name AS MIDDLE_NAME
, s.last_name AS LAST_NAME
, '' AS SUFFIX
, '' AS ALIAS_MAIDEN
, s.gender AS GENDER
, TO_CHAR(s.dob,'MM/DD/YYYY') AS DOB
, '' AS Country_of_Birth
, '' AS NEW_TO_US
, '' AS NATIV_LANG
, COALESCE((SELECT DISTINCT 'Y' FROM spenrollments WHERE studentid = s.id AND (exit_date = '01-JAN-1900' or exit_date>=sysdate) AND programid = (SELECT id FROM gen WHERE cat = 'specprog' AND name = 'ELL')),'') AS LEP_INDICATOR
, (SELECT DISTINCT 'ELL' FROM spenrollments WHERE studentid = s.id AND (exit_date = '01-JAN-1900' or exit_date>=sysdate) AND programid = (SELECT id FROM gen WHERE cat = 'specprog' AND name = 'ELL')) AS LEP_STATUS
, CASE s.fedethnicity WHEN 1 THEN 'H' ELSE 'N' END AS ETHNICITY
, (SELECT LISTAGG(
    CASE racecd
      WHEN 'A' THEN 'AS'
      WHEN 'B' THEN 'BL'
      WHEN 'I' THEN 'AM'
      WHEN 'P' THEN 'PI'
      WHEN 'W' THEN 'WH'
    END,';') WITHIN GROUP (ORDER BY CASE racecd
      WHEN 'A' THEN 'AS'
      WHEN 'B' THEN 'BL'
      WHEN 'I' THEN 'AM'
      WHEN 'P' THEN 'PI'
      WHEN 'W' THEN 'WH'
    END)
  FROM studentrace
  WHERE studentid = s.id
  GROUP BY studentid
  ) AS RACE
, s.lunchstatus AS FARMS
, COALESCE((SELECT DISTINCT 'Y' FROM spenrollments WHERE studentid = s.id AND (exit_date = '01-JAN-1900' or exit_date>=sysdate) AND programid = (SELECT id FROM gen WHERE cat = 'specprog' AND name = 'HYCP')),'N') HOMELESS_INDICATOR
, ps_customfields.getStudentsCF(s.id,'Homeless_Code') AS HOMELESS_NIGHT_RES
, '' AS HOMELESS_UNACCOMP_YOUTH
,  s.street AS ADD_STREET
, '' AS ADD_APT
, '' AS ADD_BLDG
, s.city ADD_CITY
, s.state ADD_STATE
, s.zip ADD_ZIP
, 'Y' AS RESIDENCY
, '' AS TUITION_INDICATOR
, '' AS CUSTOM_1
, '' AS CUSTOM_2
, '' AS CUSTOM_3
FROM students s
where to_char(entrydate, 'YYYY-MM-DD') >'2014-07-01'


