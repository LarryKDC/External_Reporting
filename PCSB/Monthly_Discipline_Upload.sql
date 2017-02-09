SELECT
I.INCIDENTID AS INCIDENTID_REMOVE,
S.FULLNAME AS NAME_REMOVE,
'Disciplinary' AS 'Collection Type',
'2016-2017' AS 'School Year',
'129' AS 'LEA ID',
'KIPP DC' AS 'LEA',
ALTERNATE_SCHOOL_NUMBER AS 'Campus ID' , --check that these are the actual OSSE school codes
SC.NAME AS 'Campus', --Optional
S.STATESTUDENTID AS 'USI',
S.SYSTEMSTUDENTID AS 'LEA Student ID',
CONVERT(VARCHAR,I.ISSUETS,101) AS 'Incident Date',
NULL AS 'Incident Time', --Optional
NULL AS 'Incident Location', --Optional
NULL AS 'Incident Time Description', --Optional
CASE 
	WHEN INFRACTION = 'Alcohol Related' THEN 'Alcohol possession or use'
	WHEN INFRACTION = 'Sexual Misconduct or Harrassment' THEN 'Harrassment, Sexual'
    WHEN INFRACTION = 'Theft' THEN (CASE WHEN (INJURYTYPE IS NULL or INJURYTYPE = 'No Injury') THEN 'Theft without violence' ELSE 'Robbery' END) --no injury theft without violence, if injury then robbery
	WHEN INFRACTION = 'Threatening Physical Harm' THEN 'Threat/intimidation'
	WHEN INFRACTION LIKE 'Weapons%' THEN 'Weapons Possession'
	WHEN INFRACTION = 'Physical Altercation' THEN (CASE WHEN INJURYTYPE = 'Serious Injury' THEN 'Physical Attack or Harm' WHEN INJURYTYPE IS NULL THEN '***PHYSICAL ALTERCATION TYPE UNKNOWN***' ELSE 'Physical Altercaltion, Minor' END)
	WHEN INFRACTION IS NULL THEN '**MISSING INFRACTION**'
	ELSE INFRACTION
END AS 'Reason Student Was Disciplined', --transform to match 
NULL AS 'Secondary Incident Behavior', --Optional
CASE 
	WHEN INFRACTION IN ('Bullying','Fighting',
						'Sexual Misconduct or Harrassment',
						'Theft','Threatening Physical Harm',
						'Physical Altercation',
						'Violent Incident (WITH physical injury) (VIOWINJ)') THEN (CASE WHEN INJURYTYPE IS NULL THEN '**MISSING INJURY TYPE**' ELSE INJURYTYPE END)--'**Choose Minor Injury, Serious Bodily Injury or No Injury**'
END AS 'Injury Type',
CASE
	WHEN INFRACTION LIKE 'Weapon%' THEN '**Choose weapon type**'
	ELSE NULL 
END AS 'Weapon Type',
CASE 
	WHEN P.PENALTYNAME = 'OSS' THEN 'Out-of-school Suspension'
	--WHEN P.PENALTYNAME = 'ISS' THEN 'In-school Suspension'
	ELSE P.PENALTYNAME
END AS 'Disciplinary Action Taken',
NULL AS 'Referral to Law Enforcement', --Optional
NULL AS 'School Related Arrest', --Optional
P.NUMDAYS AS 'Duration of Disciplinary Action',
CONVERT(VARCHAR, P.STARTDATE, 101) AS 'Start Date of Disciplinary Action',
CONVERT(VARCHAR, P.ENDDATE, 101) AS 'End Date of Disciplinary Action',
NULL AS 'Disciplinary Action Partial Days', --Optional
'Yes' AS 'Education Services Received?',
CASE 
	WHEN CS.SPED_FUNDING IS NOT NULL THEN 'N'
	ELSE NULL
END AS 'Interim Removal',
NULL AS 'Interim Removal Reason (IDEA)',
NULL AS 'Type of Interim Removal (IDEA)',	
NULL AS 'Length of Interim Removal (Days)',
NULL AS 'Date Interim Removal Began',
NULL AS 'Date Interim Removal Ended'	
FROM [DW].[DW_DIMSTUDENT] S
JOIN CUSTOM.CUSTOM_STUDENTS CS ON CS.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [CUSTOM].[CUSTOM_STUDENTBRIDGE] SB ON SB.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [CUSTOM].[CUSTOM_DLINCIDENTS_RAW] I ON I.STUDENTSCHOOLID = SB.STUDENT_NUMBER
JOIN [CUSTOM].[CUSTOM_DLPENALTIES_RAW] P ON P.INCIDENTID = I.INCIDENTID
JOIN POWERSCHOOL.POWERSCHOOL_STUDENTS PS ON PS.STUDENT_NUMBER = SB.STUDENT_NUMBER
JOIN POWERSCHOOL.POWERSCHOOL_SCHOOLS SC ON SC.SCHOOL_NUMBER = PS.SCHOOLID
WHERE 1=1
AND coalesce(p.startdate,i.issueTS) BETWEEN '2017-01-01' and '2017-01-31'--CONVERT(DATE,DATEADD(MM, DATEDIFF(MM, 0, GETDATE())-2, 0)) AND CONVERT(DATE,DATEADD(MS, -3, DATEADD(MM, DATEDIFF(MM, 0, GETDATE()) , 0)))
AND P.PENALTYNAME IN ('OSS','Expulsion')--,'ISS')
order by p.startdate
