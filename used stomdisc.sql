USE PPRO

IF OBJECT_ID('TEMPDB..#T1','U') IS NOT NULL
   DROP TABLE #T1

--Anyone who has taken advantage of STOMDISC
select
	orig.SHIP_MASTER_CUSTOMER_ID MCID,
	orig.SHIP_FIRST_NAME,
	orig.SHIP_LAST_NAME,
	orig.SHIP_LABEL_NAME,
	orig.SHIP_COMPANY_NAME,
	orig.SHIP_PRIMARY_EMAIL_ADDRESS,
	orig.MBR_PRODUCT_LEVEL1,
	orig.MBR_PRODUCT_LEVEL2,
	section.DESCR,
	recents.CYCLE_END_DATE MOST_RECENT_CYCLE_END_DATE,
	orig.INITIAL_BEGIN_DATE,
	stom.CYCLE_END_DATE as STOM_DATE,
	c.USR_YEARSINFOOD USR_YEARSINFOOD,
	(CASE WHEN recents.SHIP_MASTER_CUSTOMER_ID in (select distinct SHIP_MASTER_CUSTOMER_ID from ORDER_DETAIL o with (nolock)  where o.SUBSYSTEM = 'MTG' and o.PRODUCT_CODE = 'IFT2016' and LINE_STATUS_CODE = 'A') THEN 'Y' ELSE 'N' END) RegisteredIFT16,
	'MTG' as SUBSYSTEM,
	'IFT2016' as PRODUCT_CODE
from IFT_ODM_VW orig with (nolock) 
	--to get most updated info
	inner join 
	(select SHIP_MASTER_CUSTOMER_ID, MAX(CYCLE_END_DATE) CYCLE_END_DATE from IFT_ODM_VW where MBR_PRODUCT_LEVEL1 = 'NATL' and LINE_STATUS_CODE = 'A'
	group by SHIP_MASTER_CUSTOMER_ID) recents on recents.SHIP_MASTER_CUSTOMER_ID = orig.SHIP_MASTER_CUSTOMER_ID and recents.CYCLE_END_DATE = orig.CYCLE_END_DATE

	--get home section ids correpsonding to current address!
	left join CUSTOMER c on c.MASTER_CUSTOMER_ID = orig.SHIP_MASTER_CUSTOMER_ID 
	--Add in the home section descriptions:
	left join IFT_CUS_ADDRESS_WITH_HOME_SECTION_VW addr on addr.MASTER_CUSTOMER_ID = orig.SHIP_MASTER_CUSTOMER_ID and addr.CUS_ADDRESS_ID = orig.SHIP_ADDRESS_ID
	left join MBR_PRODUCT section on section.PRODUCT_ID = addr.Home_Section_Product_Id
	right outer join 
			--gets first beginning of STOMDISC for anyone who used STOMDISC
			(select distinct SHIP_MASTER_CUSTOMER_ID, min(CYCLE_END_DATE) CYCLE_END_DATE
			 from IFT_ODM_VW 
			 where LINE_STATUS_CODE = 'A' 
			 AND SUBSYSTEM = 'MBR' 
			 AND MBR_PRODUCT_LEVEL1 = 'NATL' 
			 AND RATE_STRUCTURE = 'STOMDISC'
			 group by SHIP_MASTER_CUSTOMER_ID, CYCLE_END_DATE) stom
			 on stom.SHIP_MASTER_CUSTOMER_ID = recents.SHIP_MASTER_CUSTOMER_ID
where 
	 orig.MBR_PRODUCT_LEVEL1 = 'NATL'
	 and orig.LINE_STATUS_CODE = 'A'
group by orig.SHIP_MASTER_CUSTOMER_ID,
	recents.SHIP_MASTER_CUSTOMER_ID,
	orig.SHIP_FIRST_NAME,
	orig.SHIP_LAST_NAME,
	orig.SHIP_LABEL_NAME,
	orig.SHIP_COMPANY_NAME,
	orig.SHIP_PRIMARY_EMAIL_ADDRESS,
	orig.MBR_PRODUCT_LEVEL1,
	orig.MBR_PRODUCT_LEVEL2,
	section.DESCR,
	recents.CYCLE_END_DATE,
	orig.INITIAL_BEGIN_DATE,
	stom.CYCLE_END_DATE, 
	c.USR_YEARSINFOOD,
	orig.SUBSYSTEM,
	orig.PRODUCT_CODE,
	orig.ORDER_NO