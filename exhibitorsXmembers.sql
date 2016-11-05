/* QUERY:
	Cross-Reference between exhibitors who attended IFT16 and current/past members. Validated in levels of confidence (there was no foreign key), and including all info from Exhibitors table and cycle_end_dates
 */


use uploads
select
	e.*,
	max(recents.CYCLE_END_DATE) MOST_RECENT_CYCLE_END_DATE,
	--was or is a member
	(CASE
		when 
			LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME) 
			and (LOWER(e.EMAIL) like (c.PRIMARY_EMAIL_ADDRESS) or LOWER(e.CITY) like LOWER(c.CITY))
			and recents.CYCLE_END_DATE >= GETDATE() --IMPLIES THAT recents.CYCLE_END_DATE is not NULL
		then 'CURRENT'
		when 
			LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME) 
			and (LOWER(e.EMAIL) like (c.PRIMARY_EMAIL_ADDRESS) or LOWER(e.CITY) like LOWER(c.CITY))
			and recents.CYCLE_END_DATE < GETDATE() --IMPLIES THAT recents.CYCLE_END_DATE is not NULL
		then 'PAST'
		ELSE NULL
	END) as MEMBERSHIP,
	--
	(CASE   
			when --CASE #1 ALL 
				LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
				and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME)
				and LOWER(e.EMAIL) like (c.PRIMARY_EMAIL_ADDRESS)
				and LOWER(e.CITY) like LOWER(c.CITY) 
				and recents.CYCLE_END_DATE is not NULL
			then 1
			when --CASE #2 FIRST LAST EMAIL
				LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
				and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME)
				and LOWER(e.EMAIL) like (c.PRIMARY_EMAIL_ADDRESS) 
				and recents.CYCLE_END_DATE is not NULL
			then 2
			when --CASE #3 FIRST LAST CITY
				LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
				and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME)
				and LOWER(e.CITY) like (c.CITY)
				and recents.CYCLE_END_DATE is not NULL
			 then 3
			ELSE 0
		END) as CONFIDENCE
from ['exhibitors'] e with (nolock)
LEFT JOIN  

(select a.city, c.* from 
	SQLCLUSTER1.PPRO.dbo.Customer c inner join (select distinct a.MASTER_CUSTOMER_ID, max(a.CITY) city from SQLCLUSTER1.PPRO.dbo.CUS_ADDRESS a group by a.MASTER_CUSTOMER_ID) a on c.MASTER_CUSTOMER_ID = a.MASTER_CUSTOMER_ID)
 c
on 

		(LOWER(e.FIRSTNAME) like LOWER(c.FIRST_NAME)
		and LOWER(e.LASTNAME) like LOWER(c.LAST_NAME)
		and (LOWER(e.CITY) like LOWER(c.CITY) or LOWER(e.EMAIL) like (c.PRIMARY_EMAIL_ADDRESS)))

LEFT JOIN
(
select 
x.CITY, recents.CYCLE_END_DATE, y.* from SQLCLUSTER1.PPRO.dbo.CUS_ADDRESS x with (nolock) right join SQLCLUSTER1.PPRO.dbo.Customer y on x.MASTER_CUSTOMER_ID = y.MASTER_CUSTOMER_ID
		left join (
			select distinct x.SHIP_MASTER_CUSTOMER_ID, max(x.CYCLE_END_DATE) as CYCLE_END_DATE from SQLCLUSTER1.PPRO.dbo.IFT_ODM_VW x with (nolock)
			where	x.LINE_STATUS_CODE = 'A' and x.MBR_PRODUCT_LEVEL1 = 'NATL'
			group by x.SHIP_MASTER_CUSTOMER_ID) recents on x.MASTER_CUSTOMER_ID = recents.SHIP_MASTER_CUSTOMER_ID 
		) recents on 
			c.MASTER_CUSTOMER_ID = recents.MASTER_CUSTOMER_ID 


group by e.ADDRESS, e.ADDRESS2, e.ADDRESS2, e.CITY, e.COMPANY, e.COUNTRYNAME, e.EMAIL, e.FAX, e.FIRSTNAME, e.ID, e.LASTNAME, e.PHONE, e.REGTYPECODE, e.SHOWITEMLISTWTICK, e.STATECODE, e.TITLE, e.ZIPCODE,
		c.LAST_NAME, c.FIRST_NAME, c.CITY, C.PRIMARY_EMAIL_ADDRESS,
		recents.CYCLE_END_DATE