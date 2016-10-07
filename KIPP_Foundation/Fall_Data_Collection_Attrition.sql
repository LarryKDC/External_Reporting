select
student_number,
first_name,
last_name,
e.grade_level,
(SELECT LISTAGG(racecd,',') WITHIN GROUP (ORDER BY RACECD) FROM studentrace WHERE studentid = s.id) AS RACE,
gender,
dob,
case when ps_customfields.getcf('Students',s.id,'SPED_Funding') is not null then 'Y' else 'N' end as Special_Needs,
e.entrydate,
case  
    when e.grade_level = 4 and s.grade_level = 5 then e.exitdate
    when e.grade_level = 8 and s.grade_level = 9 then e.exitdate
    when e.grade_level = 12 and s.grade_level = 99 then e.exitdate
    when s.exitdate <= '01-OCT-16' then e.exitdate
  else NULL
end "EXITDATE",
case 
  when e.grade_level = 4 and s.grade_level = 5 then 1
  when e.grade_level = 8 and s.grade_level = 9 then 1
  when e.grade_level = 12 and s.grade_level = 99 then 1
  else 0 
end GRADUATION,
e.exitcode,
e.exitcomment
from students s
join (select studentid, schoolid, grade_level, entrydate, entrycode, exitdate, exitcode, exitcomment from reenrollments
      union all
      select id,        schoolid, grade_level, entrydate, entrycode, exitdate, exitcode, exitcomment from students) e on e.studentid = s.id
where '01-OCT-15' between e.entrydate and e.exitdate
