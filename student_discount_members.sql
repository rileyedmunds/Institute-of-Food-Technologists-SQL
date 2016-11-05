USE PPRO;

IF OBJECT_ID('TEMPDB..#T1','U') IS NOT NULL
   DROP TABLE #T1
IF OBJECT_ID('TEMPDB..#T2','U') IS NOT NULL
   DROP TABLE #T2

SELECT 
USR_MASTER_CUSTOMER_ID AS 'MASTER_CUSTOMER_ID',
		CAST(CONVERT(VARCHAR, USR_END_YEAR) + '-' + CONVERT(VARCHAR, USR_END_MONTH) + '-' + CONVERT(VARCHAR, 01)
		 AS DATETIME) as 'GRADUATION_DATE',
USR_END_MONTH AS 'MONTH', USR_END_YEAR AS 'YEAR', USR_INSTITUTION_NAME AS 'INSTITUTION_NAME'
INTO #T1
FROM USR_CUS_EDUCATION with (nolock)
WHERE USR_END_YEAR  = 2016      
AND USR_END_MONTH IN (5,6,7)  --was previously ('MAY','JUNE','JULY')
/*
Intention: Put MC_ID, GRAD_DATE info, SCHOOL_NAME from members who graduate in MAY-JULY 2016 into from the USR_CUS_EDUCATION table
Effect: NOTHING (because months are in numbers, not strings, so the last line voids the whole block!)
*/

INSERT INTO #T1
(MASTER_CUSTOMER_ID, GRADUATION_DATE, MONTH, YEAR, INSTITUTION_NAME)
SELECT MASTER_CUSTOMER_ID, END_DATE AS 'GRADUATION_DATE', DATENAME(MM,END_DATE) AS 'MONTH', DATENAME (YY,END_DATE) AS 'YEAR',INSTITUTION_NAME 
FROM
CUS_EDUCATION with (nolock)
WHERE END_DATE BETWEEN '05/01/2016' AND '07/31/2016'
AND MASTER_CUSTOMER_ID NOT IN (SELECT MASTER_CUSTOMER_ID FROM #T1)
/*
Intention: add all the educations that end in MAY-JULY 2016 to #t1, except those added from CUS_EDUCATION
Effect: adds all of them because there is nothing from CUS_EDUCATION
Now: We have added all the members who graduate in MAY-JULY 2016 from USR_CUS_EDUCATION and CUS_EDUCATION into #T1
*/

SELECT DISTINCT 
	T1.MASTER_CUSTOMER_ID AS 'MCID', 
	ODM.SHIP_LABEL_NAME AS 'LABEL_NAME', 
	ODM.SHIP_FIRST_NAME AS 'FIRST_NAME', 
	ODM.SHIP_LAST_NAME AS 'LAST_NAME', 
				CAST(max(t1.GRADUATION_DATE) as date) as 'GRADUATION_DATE',
	T1.INSTITUTION_NAME, 
	CAST(max(ODM.CYCLE_END_DATE) as date) as 'CYCLE_END_DATE',
	CASE WHEN ODM.SHIP_PRIMARY_EMAIL_ADDRESS IS NULL THEN CC.FORMATTED_PHONE_ADDRESS ELSE ODM.SHIP_PRIMARY_EMAIL_ADDRESS END AS 'EMAIL_ADDRESS'
/*
select necessary fields, taking max cycle_end_date and the most useful available contact email
all ODM information is the most recent for each member because we maxed cycle_end_date
*/

INTO #T2
FROM #T1 T1 with (nolock)
LEFT JOIN IFT_ODM_VW ODM ON ODM.SHIP_MASTER_CUSTOMER_ID = T1.MASTER_CUSTOMER_ID
LEFT JOIN CUS_COMMUNICATION CC ON CC.MASTER_CUSTOMER_ID = T1.MASTER_CUSTOMER_ID AND CC.COMM_TYPE_CODE = 'EMAIL'
WHERE 
	ODM.LINE_STATUS_CODE = 'A'
	--AND ODM.CYCLE_BEGIN_DATE <= T1.GRADUATION_DATE 
	--AND ODM.CYCLE_END_DATE >=  T1.GRADUATION_DATE
	--//above two lines are legacy code from when Lily Tao wanted to select only those whose cycles overlapped their graduation
	and ODM.CYCLE_END_DATE between '5/31/2015' and '7/31/2017'  
	and t1.MASTER_CUSTOMER_ID not in 
				(select distinct (MASTER_CUSTOMER_ID)
					from customer c with (nolock)
					where c.ALLOW_SOLICITATION_FLAG != 'Y')
AND ODM.MBR_PRODUCT_LEVEL1 = 'NATL'
AND ODM.MBR_PRODUCT_LEVEL2 IN ('STDNT','STDNTNEW')
GROUP BY T1.MASTER_CUSTOMER_ID, ODM.SHIP_LABEL_NAME, ODM.SHIP_FIRST_NAME, ODM.SHIP_LAST_NAME, 
		 t1.GRADUATION_DATE,  
		 T1.INSTITUTION_NAME, ODM.SHIP_PRIMARY_EMAIL_ADDRESS, CC.FORMATTED_PHONE_ADDRESS
/*
Intention: Add into #t2 records in t1 who allow communication and cycle_end_dates in May2015-July2017
		 along with their cycles that overlap with graduation and info about those cycles and how to best reach that person.
Effect: Adds them

Now: we have #T2 with all members, who graduate in MAY-JULY 2016 who allow communication and cycle_end_dates in May2015-July2017,
	 with their information about membership and contact info (most recent)
*/
 
SELECT T2.*
FROM #T2 T2 with (nolock)
where T2.MCID NOT IN
(
SELECT SHIP_MASTER_CUSTOMER_ID 
 FROM IFT_ODM_VW with (nolock)
 WHERE LINE_STATUS_CODE = 'A' AND SUBSYSTEM = 'MBR' AND MBR_PRODUCT_LEVEL1 = 'NATL' AND RATE_STRUCTURE = 'STOMDISC'
GROUP BY SHIP_MASTER_CUSTOMER_ID, MBR_PRODUCT_LEVEL2, RATE_STRUCTURE
)
ORDER BY T2.MCID

/*
Intention: Select all people from t2 who did not take advantage of the student discount
Effect: Selects them
*/
