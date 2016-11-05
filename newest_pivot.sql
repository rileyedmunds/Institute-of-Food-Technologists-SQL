USE PPRO;

select
			    odm.SHIP_MASTER_CUSTOMER_ID MCID,
				max(odm.SHIP_LABEL_NAME) LABELNAME,
				max(odm.SHIP_FIRST_NAME) FIRSTNAME,
				max(odm.SHIP_LAST_NAME) LASTNAME,
				max(odm.SHIP_PRIMARY_EMAIL_ADDRESS) EMAIL,
				max(odm.SHIP_COMPANY_NAME) COMPANYNAME,
				max(odm.SHIP_PRIMARY_JOB_TITLE) JOBTITLE,
				max(odm.SHIP_ADDRESS_1) ADDRESS1,
				max(odm.SHIP_ADDRESS_2) ADDRESS2,
				max(odm.SHIP_ADDRESS_3) ADDRESS3,
				max(odm.SHIP_CITY) CITY,
				max(odm.SHIP_STATE) 'STATE',
				max(odm.SHIP_POSTAL_CODE) POSTALCODE,
				max(odm.SHIP_COUNTRY_CODE) COUNTRY,
				max(odm.INITIAL_BEGIN_DATE) INITIALBEGINDATE,
				--2011
				pivotTable2.CYCLE_BEGIN_DATE_2011,
				pivotTable2.RATE_CODE_2011,
				pivotTable2.PRICE_2011,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2011,
				--2012
				pivotTable2.CYCLE_BEGIN_DATE_2012,
				pivotTable2.RATE_CODE_2012,
				pivotTable2.PRICE_2012,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2012,
				--2013
				pivotTable2.CYCLE_BEGIN_DATE_2013,
				pivotTable2.RATE_CODE_2013,
				pivotTable2.PRICE_2013,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2013,
				--2014
				pivotTable2.CYCLE_BEGIN_DATE_2014,
				pivotTable2.RATE_CODE_2014,
				pivotTable2.PRICE_2014,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2014,
				--2015
				pivotTable2.CYCLE_BEGIN_DATE_2015,
				pivotTable2.RATE_CODE_2015,
				pivotTable2.PRICE_2015,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2015,
				--2016
				pivotTable2.CYCLE_BEGIN_DATE_2016,
				pivotTable2.RATE_CODE_2016,
				pivotTable2.PRICE_2016,
				pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2016

				from ift_odm_vw odm
				
inner join

(select 
		condensedPivot.MCID MC_ID,

		--2011
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2011, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2011, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2011, 0) - 4)  as CYCLE_BEGIN_DATE_2011,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2011, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2011, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2011, 0) - 4) as RATE_CODE_2011,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2011, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2011, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2011, 0) - 4) as PRICE_2011,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2011, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2011, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2011, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2011,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2011, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2011, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2011) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2011, 0) - 3) as ORDER_NO_2011,


		--2012
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2012, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2012, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2012, 0) - 4)  as CYCLE_BEGIN_DATE_2012,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2012, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2012, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2012, 0) - 4) as RATE_CODE_2012,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2012, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2012, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2012, 0) - 4) as PRICE_2012,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2012, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2012, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2012, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2012,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2012, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2012, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2012) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2012, 0) - 3) as ORDER_NO_2012,

		--2013
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2013, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2013, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2013, 0) - 4)  as CYCLE_BEGIN_DATE_2013,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2013, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2013, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2013, 0) - 4) as RATE_CODE_2013,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2013, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2013, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2013, 0) - 4) as PRICE_2013,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2013, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2013, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2013, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2013,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2013, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2013, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2013) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2013, 0) - 3) as ORDER_NO_2013,

		--2014
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2014, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2014, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2014, 0) - 4)  as CYCLE_BEGIN_DATE_2014,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2014, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2014, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2014, 0) - 4) as RATE_CODE_2014,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2014, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2014, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2014, 0) - 4) as PRICE_2014,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2014, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2014, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2014, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2014,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2014, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2014, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2014) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2014, 0) - 3) as ORDER_NO_2014,

		--2015
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2015, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2015, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2015, 0) - 4)  as CYCLE_BEGIN_DATE_2015,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2015, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2015, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2015, 0) - 4) as RATE_CODE_2015,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2015, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2015, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2015, 0) - 4) as PRICE_2015,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2015, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2015, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2015, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2015,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2015, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2015, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2015) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2015, 0) - 3) as ORDER_NO_2015,

		--2016
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2016, 0) + 4, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2016, 0)) - CHARINDEX('*1*', condensedPivot.CYCLE_END_DATE_2016, 0) - 4)  as CYCLE_BEGIN_DATE_2016,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2016, 0) + 4, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2016, 0)) - CHARINDEX('*2*', condensedPivot.CYCLE_END_DATE_2016, 0) - 4) as RATE_CODE_2016,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2016, 0) + 4, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2016, 0)) - CHARINDEX('*3*', condensedPivot.CYCLE_END_DATE_2016, 0) - 4) as PRICE_2016,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2016, 0) + 4, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2016, 0)) - CHARINDEX('*4*', condensedPivot.CYCLE_END_DATE_2016, 0) - 4) as MEMBERSHIP_TYPE_FOR_THIS_ORDER_2016,
		SUBSTRING(condensedPivot.CYCLE_END_DATE_2016, CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2016, 0) + 4, LEN(condensedPivot.CYCLE_END_DATE_2016) - CHARINDEX('*5*', condensedPivot.CYCLE_END_DATE_2016, 0) - 3) as ORDER_NO_2016


from
-- Pivot table with one row and five columns
(SELECT SHIP_MASTER_CUSTOMER_ID as MCID,
[2011] CYCLE_END_DATE_2011, [2012] CYCLE_END_DATE_2012, [2013] CYCLE_END_DATE_2013, [2014] CYCLE_END_DATE_2014,
 [2015] CYCLE_END_DATE_2015, [2016] CYCLE_END_DATE_2016
FROM


		(select odm.SHIP_MASTER_CUSTOMER_ID,
	          CAST(ODM.CYCLE_END_DATE AS nvarchar) + ' *1* ' + CAST(ODM.CYCLE_BEGIN_DATE AS nvarchar) + ' *2* ' + CAST(odm.RATE_CODE as nvarchar)+ ' *3* ' +
				CAST(odm.ACTUAL_TOTAL_AMOUNT as nvarchar) + ' *4* ' + 
				CAST(odm.MBR_PRODUCT_LEVEL1 as nvarchar) + ' ' + CAST(odm.MBR_PRODUCT_LEVEL2 as nvarchar)
				 +' *5* ' + CAST(odm.ORDER_NO as nvarchar) 
				 as bundle,
			  (CASE
				when odm.CYCLE_BEGIN_DATE between '1/1/2011' and '12/31/2011' then 2011
				when odm.CYCLE_BEGIN_DATE between '1/1/2012' and '12/31/2012' then 2012
				when odm.CYCLE_BEGIN_DATE between '1/1/2013' and '12/31/2013' then 2013
				when odm.CYCLE_BEGIN_DATE between '1/1/2014' and '12/31/2014' then 2014
				when odm.CYCLE_BEGIN_DATE between '1/1/2015' and '12/31/2015' then 2015
				when odm.CYCLE_BEGIN_DATE between '1/1/2016' and '12/31/2016' then 2016
			    END) dateyr
		from ift_odm_vw odm
		where odm.MBR_PRODUCT_LEVEL1 = 'NATL'
		and odm.LINE_STATUS_CODE = 'A'
		and odm.SHIP_MASTER_CUSTOMER_ID in
				--list of member ids who had pilot at some point
				(select distinct o.SHIP_MASTER_CUSTOMER_ID from IFT_ODM_VW o
				where o.RATE_CODE = 'Pilot'
				and MBR_PRODUCT_LEVEL1 = 'NATL'
				and LINE_STATUS_CODE = 'A')
		group by odm.SHIP_MASTER_CUSTOMER_ID,
		odm.ORDER_NO,
		odm.CYCLE_BEGIN_DATE,
        ODM.CYCLE_END_DATE,
		odm.ACTUAL_TOTAL_AMOUNT,
		odm.RATE_CODE,
		odm.MBR_PRODUCT_LEVEL1,
		odm.MBR_PRODUCT_LEVEL2) AS SourceTable


PIVOT
(
max(bundle)
FOR dateyr IN ([2011], [2012], [2013], [2014], [2015], [2016])
		) AS PivotTable ) --for the pivot
		 as condensedPivot) --for the uncondensing
		  as pivotTable2 --for the join

on 

SHIP_MASTER_CUSTOMER_ID = pivotTable2.MC_ID
and ORDER_NO = (CASE when pivotTable2.ORDER_NO_2016 IS NOT NULL then pivotTable2.ORDER_NO_2016
					 when pivotTable2.ORDER_NO_2015 IS NOT NULL then pivotTable2.ORDER_NO_2015
					 when pivotTable2.ORDER_NO_2014 IS NOT NULL then pivotTable2.ORDER_NO_2014
					 when pivotTable2.ORDER_NO_2013 IS NOT NULL then pivotTable2.ORDER_NO_2013
					 when pivotTable2.ORDER_NO_2012 IS NOT NULL then pivotTable2.ORDER_NO_2012
					 when pivotTable2.ORDER_NO_2011 IS NOT NULL then pivotTable2.ORDER_NO_2011
				END)
				  
where odm.MBR_PRODUCT_LEVEL1 = 'NATL'
	and odm.LINE_STATUS_CODE = 'A'
	and odm.SHIP_MASTER_CUSTOMER_ID in
	--list of member ids who had pilot at some point
		(select distinct o.SHIP_MASTER_CUSTOMER_ID from IFT_ODM_VW o
		where o.RATE_CODE = 'Pilot'
		and MBR_PRODUCT_LEVEL1 = 'NATL'
		and LINE_STATUS_CODE = 'A')

	group by odm.SHIP_MASTER_CUSTOMER_ID,
	ODM.CYCLE_END_DATE,
	ODM.ORDER_NO,
	odm.SHIP_LABEL_NAME,
	odm.SHIP_FIRST_NAME,
	odm.SHIP_LAST_NAME,
	odm.SHIP_PRIMARY_EMAIL_ADDRESS,
	odm.SHIP_COMPANY_NAME,
	odm.SHIP_PRIMARY_JOB_TITLE,
	odm.SHIP_ADDRESS_1,
	odm.SHIP_ADDRESS_2,
	odm.SHIP_ADDRESS_3,
	odm.SHIP_CITY,
	odm.SHIP_STATE,
	odm.SHIP_POSTAL_CODE,
	odm.SHIP_COUNTRY_CODE,
	odm.SHIP_ADDRESS_2,
	odm.INITIAL_BEGIN_DATE,
	odm.MBR_PRODUCT_LEVEL1,
	odm.MBR_PRODUCT_LEVEL2,
	pivotTable2.CYCLE_BEGIN_DATE_2012,
	pivotTable2.CYCLE_BEGIN_DATE_2013,
	pivotTable2.CYCLE_BEGIN_DATE_2014,
	pivotTable2.CYCLE_BEGIN_DATE_2015,
	pivotTable2.CYCLE_BEGIN_DATE_2016,
	pivotTable2.MC_ID,
	pivotTable2.RATE_CODE_2012,
	pivotTable2.PRICE_2012,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2012,
	--2011
	pivotTable2.CYCLE_BEGIN_DATE_2011,
	pivotTable2.RATE_CODE_2011,
	pivotTable2.PRICE_2011,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2011,

	--2013
	pivotTable2.CYCLE_BEGIN_DATE_2013,
	pivotTable2.RATE_CODE_2013,
	pivotTable2.PRICE_2013,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2013,
	--2014
	pivotTable2.CYCLE_BEGIN_DATE_2014,
	pivotTable2.RATE_CODE_2014,
	pivotTable2.PRICE_2014,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2014,
	--2015
	pivotTable2.CYCLE_BEGIN_DATE_2015,
	pivotTable2.RATE_CODE_2015,
	pivotTable2.PRICE_2015,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2015,
	--2016
	pivotTable2.CYCLE_BEGIN_DATE_2016,
	pivotTable2.RATE_CODE_2016,
	pivotTable2.PRICE_2016,
	pivotTable2.MEMBERSHIP_TYPE_FOR_THIS_ORDER_2016

	order by MC_ID;