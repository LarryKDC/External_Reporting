Select 
  '129' as LEA_ID
, e.schoolid AS LOCAL_SCHOOL_ID 
, '' AS LOCAL_SCHOOL_TYPE
, '2016-2017' AS SCHOOL_YEAR
, ps_customfields.getStudentsCF(s.id, 'SPED_esy') AS ENROLLMENT_PERIOD
, TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI')AS COLLECTION_DATE
, 'Enrollment' COLLECTION_TYPE
, s.student_number AS SIS_ID
, to_char(e.grade_level) AS ENROLL_Grade_Level
, case when e.schoolid = 2001 then ps_customfields.getStudentsCF(s.id,'SPED_Placed_Campus_ID') else TO_CHAR(alternate_school_number) end AS ATTENDING_SCHOOL_ID
, case when e.schoolid = 2001 then ps_customfields.getStudentsCF(s.id, 'SPED_NPP_School') else sc.abbreviation end AS ATTENDING_SCHOOL_NAME
, NULL as DUAL_ENROLLMENT
, NULL AS ATTENDING_SCHOOL_TYPE
, '' AS SITE_ID
, '' AS SITE_NAME
, 'PE' as ENROLLMENT_TYPE
, '' AS ENROLLMENT_1_APPLICATION
, '' AS ENROLLMENT_2_NOTIFICATION
, '' AS ENROLLMENT_3_ACCEPTED
,
CASE -- IF ENTRYDATE IS ON OR AFTER THE FIRST DAY OF INSTRUCTION STAGE 4 DATE IS NULL
  WHEN ((e.entrydate < '08-AUG-16' AND e.grade_level BETWEEN -1 AND 8) 
     OR (e.entrydate < '15-AUG-16' AND (e.grade_level = -2 OR e.grade_level = 9)) 
     OR (e.entrydate < '22-AUG-16' AND e.grade_level BETWEEN 10 AND 12)) THEN TO_CHAR(e.entrydate,'MM/DD/YYYY')
  ELSE NULL
END AS ENROLLMENT_4_REGISTRATION  
--, TO_CHAR(e.entrydate,'MM/DD/YYYY') AS ENROLLMENT_4_REGISTRATION -- ****make null if the student was previously enrolled and stage 5 enrollment date can't be the same date as an exitdate
, case --otherwide return grade level dependent stage 5 date, but only when entry date is before the stage 5 date otherwise e.entrydate (stage 4) and stage 5 date are the same
    when ((e.exitdate <= '08-AUG-16' and e.grade_level between -1 and 8) or
          (e.exitdate <= '15-AUG-16' and (e.grade_level = -2 or e.grade_level = 9)) or
          (e.exitdate <= '22-AUG-16' and e.grade_level between 10 and 12)) then NULL 
    when e.entrydate <= '08-AUG-16' and e.grade_level between -1 and 8 then to_char('08/08/2016')   
    when e.entrydate <= '15-AUG-16' and (e.grade_level = -2 or e.grade_level = 9) then to_char('08/15/2016')   
    when e.entrydate <= '22-AUG-16' and e.grade_level between 10 and 12 then to_char('08/22/2016') 
    else to_char(e.entrydate,'MM/DD/YYYY') 
  end AS ENROLLMENT_5_SERVICES_RECEIVED 
  
, case 
    when --make code null if stage 5 date is after current date; NULL is mapped to 1800 (pre-enrollment) in ADT
      (case 
        when e.entrydate <= '08-AUG-16' and e.grade_level between -1 and 8 then to_date('08/08/2016','MM/DD/YYYY')   
        when e.entrydate <= '15-AUG-16' and (e.grade_level = -2 or e.grade_level = 9) then to_date('08/15/2016','MM/DD/YYYY')   
        when e.entrydate <= '22-AUG-16' and e.grade_level between 10 and 12 then to_date('08/22/2016','MM/DD/YYYY') 
        else e.entrydate 
      end) > sysdate then NULL 
    else entrycode --if current date is after stage 5 date then just use the regular entrycode
  end AS ENROLLMENT_CODE

, case 
    when e.exitdate <= sysdate then to_char(e.exitdate,'MM/DD/YYYY') 
    else null 
  end  AS EXIT_DATE
, case 
    when e.exitdate <= sysdate then exitcode 
    else null 
  end AS EXIT_CODE
, '' AS ENROLLMENT_TRANS_ID
FROM students s
JOIN (
  SELECT s.id studentid, s.schoolid, s.grade_level, s.entrydate, s.exitdate FROM students s
  UNION
  SELECT r.studentid, r.schoolid, r.grade_level, r.entrydate, r.exitdate FROM reenrollments r
) e ON e.studentid = s.id
join schools sc on sc.school_number = e.schoolid
where e.entrydate >= '01-JUL-16'
and e.schoolid != 999999
