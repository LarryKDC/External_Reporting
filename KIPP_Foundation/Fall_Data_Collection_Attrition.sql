select
e.schoolid,
student_number,
first_name,
last_name,
e.grade_level,
(SELECT LISTAGG(racecd,',') WITHIN GROUP (ORDER BY RACECD) FROM studentrace WHERE studentid = s.id) AS RACE,
gender,
dob,
case when ps_customfields.getcf('Students',s.id,'SPED_Funding') is not null then 'Y' else 'N' end as Special_Needs,
e.entrydate,
e.exitdate,
case when e.exitcode = 'G' then e.exitdate else null end AS "GRADUATION",
e.exitcode,
e.exitcomment
from students s
join (select studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode, exitcomment from reenrollments
      union all
      select id,        schoolid, grade_level, entrydate, entrycode, exitdate, exitcode, exitcomment from students) e on e.studentid = s.id
where e.entrydate <= '05-OCT-15'
--and s.exitdate between '01-OCT-15' and '01-OCT-16'
and e.exitdate between '01-OCT-15' and '01-OCT-16' 
and s.enroll_status != 0
order by e.exitcode
