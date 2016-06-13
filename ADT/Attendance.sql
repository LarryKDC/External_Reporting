select 
 '129' as LEA_ID
, '' AS SCHOOL_YEAR 
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')AS COLLECTION_DATE
, 'Attendance' COLLECTION_TYPE
, s.student_number AS SIS_ID
, cd.date_value as ATTENDANCE_DATE
, CASE To_Char(a.ccid) 
    WHEN '0' THEN 'D'
END AS ATTENDANCE_COLLECTION_TYPE
/*USE THIS INSTEAD OF “A.CCID” IF YOU USE ATT_MODE_CODE*/
/*,  a.att_mode_code AS ATTENDANCE_COLLECTION_TYPE */
, coalesce(case when ac.att_code = 'NA' then Null
    else ac.att_code end,'P') AS ATTENDANCE_STATUS_CODE
, '' AS ATTENDANCE_ABSENCE_REASON 
FROM schools sc
JOIN (
  SELECT id studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM students
  UNION ALL
  SELECT studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode FROM reenrollments
) e ON e.schoolid = sc.school_number and sc.school_number!=2001
join students s on s.id = e.studentid
JOIN calendar_day cd ON cd.schoolid = e.schoolid AND cd.date_value BETWEEN e.entrydate AND e.exitdate-1 AND cd.insession = 1
left outer join attendance a on a.studentid = e.studentid and a.att_date = cd.date_value and att_mode_code = 'ATT_ModeDaily'
left join attendance_code ac on ac.id = a.attendance_codeid
where cd.date_value between '01-JUL-15' and sysdate
