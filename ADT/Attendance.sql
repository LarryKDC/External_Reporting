select 
 '129' as LEA_ID
, '2016-2017' AS SCHOOL_YEAR 
, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')AS COLLECTION_DATE
, 'Attendance' COLLECTION_TYPE
, s.student_number AS SIS_ID
, TO_CHAR (cd.date_value, 'DD/MM/YYYY') as ATTENDANCE_DATE
, CASE To_Char(a.ATT_MODE_CODE) 
    WHEN 'ATT_ModeDaily' THEN 'D'
  END AS ATTENDANCE_COLLECTION_TYPE
, case 
    when ac.att_code = 'O' then 'AOS'
    when ac.att_code in ('AE','M','MP','AP','EX','IC') then 'AFE'
    when ac.att_code in ('A','MU') then 'AFU'
    when ac.att_code = 'ISS' then 'PIS'
    when ac.att_code in ('NA','TC') or ac.att_code is null then 'PF'
    when ac.att_code in ('R','TE') then 'PPE'
    when ac.att_code = 'T' then 'PPU'
    else NULL
  end as ATTENDANCE_STATUS_CODE
, '' AS ATTENDANCE_ABSENCE_REASON 
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
where cd.date_value between '8-AUG-16' and sysdate
and cd.insession = 1
