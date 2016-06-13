SELECT
i.studentschoolid 'Student_Number - Remove',
case	when	I.schoolid=82	then	'KEY'
	when	I.schoolid=81	then	'AIM'
	when	I.schoolid=85	then	'WILL'
	when	I.schoolid=73	then	'LEAP'
	when	I.schoolid=77	then	'Promise'
	when	I.schoolid=71	then	'Discover'
	when	I.schoolid=72	then	'Grow'
	when	I.schoolid=75	then	'Heights'
	when	I.schoolid=76	then	'Lead'
	when	I.schoolid=79	then	'Spring'
	when	I.schoolid=70	then	'Connect'
	when	I.schoolid=83	then	'NE'
	when	I.schoolid=74	then	'ATA'
	when	I.schoolid=84	then	'Valor'
	when	I.schoolid=78	then	'Quest'
	when	I.schoolid=86	then	'LC'
	when	I.schoolid=80	then	'KCP'
	else	null	end 	'School (Incident) - Remove',		
s.enrollmentstatus 'Enrollment Status - Remove',
link 'DeansList URL - Remove',
SC.ABBREVIATION 'School',
[STATESTUDENTID] 'USI ID',
LASTNAME 'STUDENT LAST NAME',
FIRSTNAME 'STUDENT FIRST NAME',
CASE 
	WHEN CS.[SPED_CLASSIFICATION] IS NOT NULL THEN 'Y'
	ELSE 'N' 
END 'STUDENT HAS AN IEP?',
CASE
	WHEN CS.[SPED_CLASSIFICATION] IN ('Autism','AUT') then 'AUT - Autism'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Deaf-Blindness','DB') then 'DB - Deaf-Blindness'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Developmental Delay','DD') then 'DD - Developmental Delay'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Emotional Disturbance','EMN') then 'EMN - Emotional Disturbance'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Hearing Impaired','HI') then 'HI - Hearing Impairment'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Mental Retardation','MR') then 'MR - Mental Retardation'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Multiple Disabilities','MD') then 'MD - Multiple Disabilities'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Othopedic Impairment','OI') then 'OI - Orthopedic Impairment'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Specific Learning Disability','SLD') then 'SLD - Specific Learning Disability'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Speech or Language Impairment','SLI') then 'SLI - Speech or Language Impairment'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Traumatic Brain Injury','TBI') then 'TBI - Traumatic Brain Injury'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Visual Impairment','VI') then 'VI - Visual Impairment'
	WHEN CS.[SPED_CLASSIFICATION] IN ('Other Health Impairment','OHI') then 'OHI - Other Health Impairment'
	ELSE NULL
END 'PRIMARY DISABILITY',
'NO' 'WAS STUDENT REMOVED...',
NULL 'TYPE OF INTERIM REMOVAL',
NULL 'DATE INTERIM REMOVAL BEGAIN',
NULL 'LENGTH OF INTERIM REMOVAL (DAYS)',
NULL 'INTERIM REMOVAL REASON',
'YES' 'WAS STUDENT SUSPENDED OR EXPELLED',
CASE 
	WHEN P.PENALTYNAME LIKE 'OSS%' THEN 'OUT OF SCHOOL SUSPENSION'
	--WHEN P.PENALTYNAME LIKE 'ISS%' THEN 'IN SCHOOL SUSPENSION'  --Don't need to report ISS
	WHEN P.PENALTYNAME = 'Expulsion' THEN 'EXPULSION'
	ELSE NULL
END 'TYPE OF SUSPENSION/EXPULSION',
CONVERT(char(10),P.STARTDATE,101) 'DATE OF SUSPENSION/EXPLUSION', --change date format from yyyy-mm-dd to mm/dd/yyyy
CONVERT(char(10),P.ENDDATE,101) 'END DATE OF SUSPENSION/EXPLUSION -- REMOVE', --change date format from yyyy-mm-dd to mm/dd/yyyy
P.NUMDAYS 'REMOVAL LENGTH IN DAYS',
CASE
	WHEN	I.INFRACTION 	=	'Alcohol Related (A)'	then 	'A - Alcohol Related'
	WHEN	I.INFRACTION 	=	'Illicit Drug Related (D)'	then 	'D - Illicit Drug Related'
	WHEN	I.INFRACTION 	=	'Violent Incident (WITH physical injury) (VIOWINJ)'	then 	'VIOWINJ - Violent Incident (with physical injury)'
	WHEN	I.INFRACTION 	=	'Violent Incident (WITHOUT physical injury) (VIOWOINJ)'	then 	'VIOWOINJ - Violent Incident (without physical injury)'
	WHEN	I.INFRACTION 	=	'Weapons Possession - Non-firearm (W)'	then 	'W - Weapons Possession'
	WHEN	I.INFRACTION 	=	'Weapons Possession - Handguns (W-HANDGUNS)'	then 	'W - Weapons Possession (HANDGUNS - Handguns)'
	WHEN	I.INFRACTION 	=	'Weapons Possession - Use of more than one of the above (W-MULTIPLE)'	then 	'W - Weapons Possession (MULTIPLE - Use of more than one of the above (handguns, rifles/shotgun, or other)'
	WHEN	I.INFRACTION 	=	'Weapons Possesssion - Any firearm that is not handgun, rifle, or shotgun (W-OTHER)'	then 	'W - Weapons Possession (OTHER - Any firearm that is not a handgun or a rifle or a shotgun)'
	WHEN	I.INFRACTION 	=	'Weapons Possession - Rifles / Shotgun (W-RIFLESHOTGUN)'	then 	'W - Weapons Possession (RIFLESHOTGUN - Rifles / Shotguns)'
	WHEN	I.INFRACTION IS NULL THEN NULL
	ELSE	'OTHER CHARTER- Non-violent violation of school''s discipline or compulsory attendance policy'
END 'REASON WHY STUDENT WAS DISCIPLINED',
CASE 
	WHEN I.INFRACTION IN (	'Academic Dishonesty',
							'Arson',
							'Attendance/Skipping/Tardy',
							'Bullying',
							'Disruptive Behavior',
							'Fighting',
							'Flammables',
							'Gambling',
							'Improper Use of Technology',
							'Insubordination',
							'Sexual Misconduct or Harassment',
							'Theft',
							'Threatening Physical Harm',
							'Vandalism'
							) THEN I.INFRACTION
	ELSE NULL
END 'OTHER CHARTER REASON',
NULL 'EDUCATION SERVICES RECIEVED DURING SUSPENSION/EXPULSION'
FROM [DW].[DW_DIMSTUDENT] S
JOIN CUSTOM.CUSTOM_STUDENTS CS ON CS.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [CUSTOM].[CUSTOM_STUDENTBRIDGE] SB ON SB.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [custom].[custom_dlincidents_raw] i on i.studentschoolid = sb.student_number
JOIN [CUSTOM].[CUSTOM_DLPENALTIES_RAW] P ON p.incidentid = i.incidentid
JOIN POWERSCHOOL.POWERSCHOOL_STUDENTS PS ON PS.STUDENT_NUMBER = SB.STUDENT_NUMBER
JOIN POWERSCHOOL.POWERSCHOOL_SCHOOLS SC ON SC.SCHOOL_NUMBER = PS.SCHOOLID
WHERE 1=1
--AND i.issueTS between '2015-10-01' and '2015-10-30'
AND coalesce(p.startdate,i.issueTS) BETWEEN '2016-05-01' and '2016-05-31'--CONVERT(DATE,DATEADD(MM, DATEDIFF(MM, 0, GETDATE())-2, 0)) AND CONVERT(DATE,DATEADD(MS, -3, DATEADD(MM, DATEDIFF(MM, 0, GETDATE()) , 0)))
AND P.PENALTYNAME IN ('OSS','Expulsion')--,'ISS Short Term','ISS Long Term')
order by p.startdate
