Select 
  '129' as LEA_ID
, schoolid AS LOCAL_SCHOOL_ID 
, '' AS LOCAL_SCHOOL_TYPE
, '2016-2017' AS SCHOOL_YEAR
, ps_customfields.getStudentsCF(s.id, 'SPED_esy') AS ENROLLMENT_PERIOD
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')AS COLLECTION_DATE
, 'Enrollment' COLLECTION_TYPE
, student_number AS SIS_ID
, to_char(grade_level) AS ENROLL_GRADE_LEVEL
, case when schoolid = 2001 then ps_customfields.getStudentsCF(s.id,'SPED_Placed_Campus_ID') else TO_CHAR(schoolid) end AS ATTENDING_SCHOOL_ID 
, case when schoolid = 2001 then ps_customfields.getStudentsCF(s.id, 'SPED_NPP_School') else sc.abbreviation end AS ATTENDING_SCHOOL_NAME
, NULL as DUAL_ENROLLMENT
, NULL AS ATTENDING_SCHOOL_TYPE
, '' AS SITE_ID
, '' AS SITE_NAME
, 'PE' as ENROLLMENT_TYPE
, '' AS ENROLLMENT_1_APPLICATION
, '' AS ENROLLMENT_2_NOTIFICATION
, '' AS ENROLLMENT_3_ACCEPTED
, TO_CHAR(entrydate,'DD-MM-YYYY') AS ENROLLMENT_4_REGISTRATION
, case 
    when entrydate <= '08-AUG-16' and grade_level between -1 and 8 then to_char('08-08-2016')   
    when entrydate <= '15-AUG-16' and (grade_level = -2 or grade_level = 9) then to_char('15-08-2016')   
    when entrydate <= '22-AUG-16' and grade_level between 10 and 12 then to_char('22-08-2016') 
    else to_char(entrydate,'DD-MM-YYYY') 
  end AS ENROLLMENT_5_SERVICES_RECEIVED
, entrycode AS ENROLLMENT_CODE
, '' AS EXIT_DATE
, exitcode AS EXIT_CODE
, '' AS ENROLLMENT_TRANS_ID
FROM students s
join schools sc on sc.school_number = s.schoolid
where to_char(entrydate, 'YYYY-MM-DD') >='2016-07-01'
