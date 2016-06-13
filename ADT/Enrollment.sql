Select 
'129' as LEA_ID
, case when schoolid = 2001 then ps_customfields.getStudentsCF(id, 'SPED_Responsible_SchoolID') else TO_CHAR(schoolid) end AS LOCAL_SCHOOL_ID 
, '' AS LOCAL_SCHOOL_TYPE
, '2015-2016' AS SCHOOL_YEAR
, '' AS ENROLLMENT_PERIOD
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') AS COLLECTION_DATE
, 'Enrollment' COLLECTION_TYPE
, student_number AS SIS_ID
, to_char (grade_level) AS ENROLL_GRADE_LEVEL
, ps_customfields.getStudentsCF(id, 'SPED_Placed_Campus_ID') AS ATTENDING_SCHOOL_ID 
, '' AS ATTENDING_SCHOOL_NAME
, NULL as DUAL_ENROLLMENT
, NULL AS ATTENDING_SCHOOL_TYPE
, case when schoolid = 2001 then ps_customfields.getStudentsCF(id, 'SPED_Responsible_SchoolID') else TO_CHAR(schoolid) end AS CAMPUS_ID
, '' AS CAMPUS_NAME
, 'PE' as ENROLLMENT_TYPE
, TO_CHAR(TO_DATE(ps_customfields.getStudentsCF(id,'Application_Received'),'MM/DD/YYYY'),'MM/DD/YYYY') AS ENROLLMENT_1_APPLICATION
, (SELECT to_char(MAX(entry_date),'MM/DD/YYYY') FROM log WHERE studentid = id AND logtypeid = (SELECT id FROM gen WHERE name = 'Enrollment' AND cat='logtype') AND subtype = 'OFFER') AS ENROLLMENT_2_NOTIFICATION
, TO_CHAR(TO_DATE(ps_customfields.getStudentsCF(id,'Pre_AcceptedSpot'),'MM/DD/YYYY'),'MM/DD/YYYY') AS ENROLLMENT_3_ACCEPTED
, TO_CHAR(entrydate,'MM/DD/YYYY') AS ENROLLMENT_4_REGISTRATION
, (select
    to_char(min(cc.dateenrolled),'MM/DD/YYYY')
    from cc
    join courses c on c.course_number = cc.course_number
    where cc.dateenrolled >= entrydate--'01-JUL-15'
    and course_name in ('Advisory I', 'Homeroom')
    and cc.studentid = students.id) AS ENROLLMENT_5_SERVICES_RECEIVED
, entrycode AS ENROLLMENT_CODE
, TO_CHAR(exitdate,'MM/DD/YYYY') AS EXIT_DATE
, exitcode AS EXIT_CODE
, '' AS ENROLLMENT_TRANS_ID
FROM students  
where to_char(entrydate, 'YYYY-MM-DD') >='2015-07-01'
UNION ALL
Select 
'129' as LEA_ID
, TO_CHAR(e.schoolid) AS LOCAL_SCHOOL_ID 
, '' AS LOCAL_SCHOOL_TYPE
, '2015-2016' AS SCHOOL_YEAR
, '' AS ENROLLMENT_PERIOD
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') AS COLLECTION_DATE
, 'Enrollment' COLLECTION_TYPE
, s.student_number AS SIS_ID
, to_char (e.grade_level) AS ENROLL_GRADE_LEVEL
, ps_customfields.getStudentsCF(s.id, 'SPED_Placed_Campus_ID') AS ATTENDING_SCHOOL_ID
, '' AS ATTENDING_SCHOOL_NAME
, NULL as DUAL_ENROLLMENT
, NULL AS ATTENDING_SCHOOL_TYPE
, TO_CHAR (e.schoolid) AS CAMPUS_ID
, '' AS CAMPUS_NAME
, 'PE' as ENROLLMENT_TYPE
, '' AS ENROLLMENT_1_APPLICATION
, '' AS ENROLLMENT_2_NOTIFICATION
, '' AS ENROLLMENT_3_ACCEPTED
, TO_CHAR(e.entrydate,'MM/DD/YYYY') AS ENROLLMENT_4_REGISTRATION
, (select
    to_char(min(cc.dateenrolled),'MM/DD/YYYY')
    from cc
    join courses c on c.course_number = cc.course_number
    where cc.dateenrolled >= e.entrydate--'01-JUN-14'
    and course_name in ('Advisory I', 'Homeroom')
    and cc.studentid = e.studentid) AS ENROLLMENT_5_SERVICES_RECEIVED
, e.entrycode AS ENROLLMENT_CODE
, TO_CHAR(e.exitdate,'MM/DD/YYYY') AS EXIT_DATE
, e.exitcode AS EXIT_CODE
, '' AS ENROLLMENT_TRANS_ID
FROM reenrollments e 
inner join students s on e.studentid =s.id
where to_char(e.entrydate, 'YYYY-MM-DD') >='2014-07-01'
