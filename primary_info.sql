--Task : Find most recent: membership types, cycle and date, and primary email address for each member.

select
	cus.MASTER_CUSTOMER_ID as MC_ID, 
	filtered.SHIP_FIRST_NAME,
	filtered.SHIP_LAST_NAME,
	filtered.MBR_PRODUCT_LEVEL1,
	filtered.MBR_PRODUCT_LEVEL2,
	(CASE
		WHEN cus.PRIORITY_SEQ = 0 THEN cus.ADDRESS_1
		WHEN cus.PRIORITY_SEQ = 1  THEN cus.ADDRESS_2
		WHEN cus.PRIORITY_SEQ = 2  THEN cus.ADDRESS_3
		WHEN cus.PRIORITY_SEQ = 3  THEN cus.ADDRESS_4
	END) as top_address,
	cus.PRIORITY_SEQ as priority_seq,
	cus.ADDRESS_TYPE_CODE, 
	cus.CITY, 
	cus.STATE, 
	cus.POSTAL_CODE, 
	cus.COUNTRY_CODE,
	filtered.recent_cycle 
		from IFT_CUS_ADDRESS_VW as cus

		inner join
		(
			select 
				vw.master_customer_id as MC_ID, 
				min(vw.PRIORITY_SEQ) as BEST_PRIORITY,
				mem.SHIP_FIRST_NAME,
				mem.SHIP_LAST_NAME,
				mem.MBR_PRODUCT_LEVEL1,
				mem.MBR_PRODUCT_LEVEL2,
				mem.recent_cycle
			from IFT_CUS_ADDRESS_VW as vw

			inner join

					(select 
						d.SHIP_MASTER_CUSTOMER_ID as id,
						d.SHIP_FIRST_NAME,
						 d.SHIP_LAST_NAME,
						d.MBR_PRODUCT_LEVEL1,
						d.MBR_PRODUCT_LEVEL2,
						max(d.CYCLE_END_DATE) as recent_cycle 
							from dbo.IFT_ODM_VW as d 
					inner join 

						(select 
							odm.SHIP_MASTER_CUSTOMER_ID, 
							odm.SHIP_FIRST_NAME, 
							odm.SHIP_LAST_NAME, 
							max(odm.CYCLE_END_DATE) as recent_cycle_end_date
								from dbo.IFT_ODM_VW as odm
									group by odm.SHIP_MASTER_CUSTOMER_ID, odm.SHIP_FIRST_NAME, odm.SHIP_LAST_NAME
						) as b
						on (d.SHIP_MASTER_CUSTOMER_ID = b.SHIP_MASTER_CUSTOMER_ID and d.CYCLE_END_DATE = b.recent_cycle_end_date)
							where 
								d.LINE_STATUS_CODE = 'A' and d.MBR_PRODUCT_LEVEL1 = 'NATL'
							group by d.SHIP_MASTER_CUSTOMER_ID, d.SHIP_FIRST_NAME, d.SHIP_LAST_NAME, d.MBR_PRODUCT_LEVEL1, d.MBR_PRODUCT_LEVEL2

					) as mem

			on mem.id = vw.MASTER_CUSTOMER_ID
			where vw.priority_seq <= 4
			group by
				vw.MASTER_CUSTOMER_ID,
				mem.SHIP_FIRST_NAME,
				mem.SHIP_LAST_NAME,
				mem.MBR_PRODUCT_LEVEL1,
				mem.MBR_PRODUCT_LEVEL2,
				mem.recent_cycle
				 
			) as filtered

		on (cus.MASTER_CUSTOMER_ID = filtered.MC_ID and cus.PRIORITY_SEQ = filtered.BEST_PRIORITY)
		order by MC_ID;
