select
ps_customfields.getStudentsCF(s.id, 'state_usi') AS USI
, s.student_number
, '2015-2016' AS SCHOOL_YEAR
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')AS COLLECTION_DATE
,'129' as LEA_ID
,e.schoolid SCHOOL_ID
--,a.att_date
,date_value
,CASE 
  WHEN AC.ATT_CODE IN ('C','E','F','H','M','MP','O') THEN 'AFE'
  WHEN AC.ATT_CODE IN ('A','MU','X') THEN 'AFU'
  WHEN AC.ATT_CODE IN ('RAE','TAE') THEN 'APE'
  WHEN AC.ATT_CODE IN ('RA','TA') THEN 'APU'
  WHEN AC.ATT_CODE IN ('AP','DO','HP','ISS','P','NA') OR AC.ATT_CODE IS NULL THEN 'PF'
  WHEN AC.ATT_CODE IN ('R','RE','T','TE','TRE') THEN 'PP'
  --WHEN AC.ATT_CODE = 'NA' THEN NULL
  ELSE AC.ATT_CODE
 END AS ATTENDANCE_STATUS_CODE
--,AC.ATT_CODE
--,e.entrydate
--,e.exitdate
FROM students s
JOIN (
  SELECT id studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM students
  UNION ALL
  SELECT studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM reenrollments
) e ON e.studentid = s.id --and sc.school_number!=2001
join schools sc on sc.school_number = e.schoolid and sc.school_number!=2001
--join students s on s.id = e.studentid
left outer join calendar_day cd on cd.date_value between e.entrydate and e.exitdate and e.schoolid = cd.schoolid
left outer join attendance a on a.att_date = cd.date_value and a.studentid = e.studentid and att_mode_code = 'ATT_ModeDaily'
left outer join attendance_code ac on ac.id = a.attendance_codeid
where cd.date_value between '10-AUG-15' and '16-JUN-16'
and cd.insession = 1
