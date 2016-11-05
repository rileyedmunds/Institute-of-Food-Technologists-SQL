/* QUERY:
	Cross-Reference between exhibitors who attended IFT16 and those on the joining-2015 list. Validated in levels of confidence (there was no matching foreign key), and including all info from Exhibitors table, and some from the joining-2015 list.
 */

use uploads;
select
	e.*,
	(CASE
		when 
			LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME) 
			or LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)
		then 'Y'
		ELSE 'N'
	END) as MATCH,
	--
	(CASE   
			when --CASE #1 ALL 
				LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
				and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME)
				and LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)
			then 'NAME&EMAIL'
			when --CASE #2 FIRST LAST
				LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
				and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME)
			then 'NAMEONLY'
			ELSE NULL
		END) as MATCHCONFIDENCE,

	/*for members, including whether is current member, recent cycle_end_date and mbr_level_2*/
		--whether is current member
		(CASE
		when 
			j.MBR_PRODUCT_LEVEL2 is not NULL
			and LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME) 
			or LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)
		then 'Y'
		ELSE 'N'
	END) as ISCURRENTMEMBER, 
		--mbr_product_level_2
		(CASE
		when 
			LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME) 
			or LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)
		then j.MBR_PRODUCT_LEVEL2
		ELSE NULL
	END) as MBR_PRODUCT_LEVEL2,
	--recent cycle_end_date
	(CASE
		when 
			LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME) 
			or LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)
		then j.MOST_RECENT_CYCLE_END_DATE
		ELSE NULL
	END) as MOST_RECENT_CYCLE_END_DATE
from ['exhibitors'] e with (nolock)
LEFT JOIN  

(
select * from joiningmembers

) j on LOWER(e.FIRSTNAME) like LOWER(j.SHIP_FIRST_NAME)
			and LOWER(e.LASTNAME) like LOWER(j.SHIP_LAST_NAME) 
			or LOWER(e.EMAIL) like (j.SHIP_PRIMARY_EMAIL_ADDRESS)