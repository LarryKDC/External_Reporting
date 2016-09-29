SELECT
 '129' AS LEA_ID
, '2016-2017' AS SCHOOL_YEAR
, TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI') AS COLLECTION_DATE
, 'Demographics' AS COLLECTION_TYPE
, TO_CHAR(s.student_number) AS SIS_ID
, ps_customfields.getStudentsCF(s.id,'State_USI') AS USI
, '' AS LEA_Student_ID
, s.first_name AS FIRST_NAME
, s.middle_name AS MIDDLE_NAME
, s.last_name AS LAST_NAME
, '' AS SUFFIX
, '' AS ALIAS_MAIDEN
, s.gender AS GENDER
, TO_CHAR(s.dob,'MM/DD/YYYY') AS DOB
, ps_customfields.getStudentsCF(s.id,'COUNTRY_OF_BIRTH') AS Country_of_Birth
, ps_customfields.getStudentsCF(s.id,'NEW_TO_US') AS NEW_TO_US
, '' AS NATIV_LANG
, first_ninth_grade_year AS FIRST_NINTH_GRADE_YEAR
, COALESCE((SELECT DISTINCT 'Y' FROM spenrollments WHERE studentid = s.id AND (exit_date = '01-JAN-1900' or exit_date>=sysdate) AND programid = (SELECT id FROM gen WHERE cat = 'specprog' AND name = 'ELL')),'N') AS LEP_INDICATOR
, '' AS LEP_STATUS
, s.fedethnicity AS ETHNICITY
, (SELECT LISTAGG(racecd,',') WITHIN GROUP (ORDER BY RACECD) FROM studentrace WHERE studentid = s.id) AS RACE
, s.lunchstatus AS FARMS
, ps_customfields.getStudentsCF(s.id,'Homeless_Code') AS HOMELESS_INDICATOR
, '' AS HOMELESS_NIGHT_RES
, '' AS HOMELESS_UNACCOMP_YOUTH
,  s.street AS ADD_STREET
, '' AS ADD_APT
, '' AS ADD_BLDG
, s.city ADD_CITY
, s.state ADD_STATE
, s.zip ADD_ZIP
, ps_customfields.getStudentsCF(s.id,'STATE_RESIDENT') AS RESIDENCY
, ps_customfields.getStudentsCF(s.id,'STATE_TUITION') AS TUITION_INDICATOR
, ps_customfields.getStudentsCF(s.id,'STATE_UHC') AS UNIVERSAL_HEALTH_CERTIFICATE
, s.home_room AS COUNT_LOCATION
FROM students s
LEFT OUTER JOIN u_students u_s on u_s.studentsdcid = s.dcid
where entrydate >= '01-JUL-16'
