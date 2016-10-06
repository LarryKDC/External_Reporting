select
student_number,
gender,
dob,
lastfirst,
grade_level,
(SELECT LISTAGG(racecd,',') WITHIN GROUP (ORDER BY RACECD) FROM studentrace WHERE studentid = s.id) AS RACE,
fedethnicity,
case when ps_customfields.getcf('Students',s.id,'SPED_Funding') is not null then 'Y' else 'N' end as SPED,
coalesce((select 'Y' from spenrollments where programid = 3124 and exit_date ='01-JAN-1900' and studentid = s.id),'N') ELL,
entrydate,
entrycode,
exitdate,
exitcode
from students s
join schools sc on sc.school_number = s.schoolid
where '26-SEP-16' between s.entrydate and s.exitdate
