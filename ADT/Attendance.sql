select --this is a test
 '129' as LEA_ID
, '2016-2017' AS SCHOOL_YEAR 
, TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI')AS COLLECTION_DATE
, 'Attendance' COLLECTION_TYPE
, s.student_number AS SIS_ID
, TO_CHAR (cd.date_value, 'MM/DD/YYYY') as ATTENDANCE_DATE
, a.ATT_MODE_CODE AS ATTENDANCE_COLLECTION_TYPE
, ac.att_code as ATTENDANCE_STATUS_CODE
, '' AS ATTENDANCE_ABSENCE_REASON
, e.entrydate
, e.exitdate
FROM students s
JOIN (
  SELECT id studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM students
  UNION ALL
  SELECT studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM reenrollments
) e ON e.studentid = s.id
join schools sc on sc.school_number = e.schoolid and sc.school_number!=2001
left outer join calendar_day cd on cd.date_value between e.entrydate and e.exitdate and e.schoolid = cd.schoolid
left outer join attendance a on a.att_date = cd.date_value and a.studentid = e.studentid and att_mode_code = 'ATT_ModeDaily'
left outer join attendance_code ac on ac.id = a.attendance_codeid
where cd.date_value between '08-AUG-16' and sysdate
and cd.insession = 1
and (ac.att_code != 'X' OR ac.att_code is null) -- Do not send the X code because they correspond to non-school days; using only ac.att_code != 'X' excludes null values, so they must be explicitly inclduded
