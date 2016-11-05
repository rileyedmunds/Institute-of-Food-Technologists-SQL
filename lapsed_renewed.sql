--Task: find information about all members who, lapsed on 3/1/2015, renewed and registered for IFT2015 conference between 3/1/2015 and 7/31/2015.

--people who registered for ift 2015  (1)
USE PPRO
select 
	   x.CYCLE_END_DATE,
	   lapsedRenewed.Initial INITIAL_BEGIN_DATE,
	   lapsedRenewed.RENEWAL_BEGIN_DATE,
	   lapsedRenewed.MBR_PRODUCT_LEVEL2,
	   x.SHIP_MASTER_CUSTOMER_ID,
	   lapsedRenewed.PRODUCT_CODE,
	   lapsedRenewed.SHIP_LABEL_NAME,
	   lapsedRenewed.SHIP_FIRST_NAME,
	   lapsedRenewed.SHIP_LAST_NAME,
	   lapsedRenewed.SHIP_PRIMARY_EMAIL_ADDRESS,
	   o.invoice_date as Registration_Date,
	   o.PRODUCT_CODE,
	   section.DESCR
from ORDER_DETAIL as o with (nolock)

		--retrieving most recent begin date:
		inner join
		(select x.SHIP_MASTER_CUSTOMER_ID, max(x.CYCLE_END_DATE) as CYCLE_END_DATE from ORDER_DETAIL x with (nolock)
		where	x.LINE_STATUS_CODE = 'A'
				and x.CYCLE_END_DATE < '3/1/2015'
		group by x.SHIP_MASTER_CUSTOMER_ID) as x
		on x.SHIP_MASTER_CUSTOMER_ID = o.SHIP_MASTER_CUSTOMER_ID


inner join                                          --WHO ALSO

       --people who were lapsed in 2015 and renewed between 3/1/2015 and 7/31/2015 
              --people who renewed between 3/1/2015 and 7/31/2015  (2)
              (select distinct  --'distinct' because we don't need a member twice if they fit the criteria twice.
			  vw.INVOICE_DATE as RENEWAL_BEGIN_DATE,
			  vw.INITIAL_BEGIN_DATE as Initial,
              vw.SHIP_MASTER_CUSTOMER_ID as MC_ID,
              lapsed.Initial_Begin_Date,
			  vw.MBR_PRODUCT_LEVEL2,
			  vw.PRODUCT_CODE,
			  vw.SHIP_LABEL_NAME,
			  vw.SHIP_FIRST_NAME,
			  vw.SHIP_LAST_NAME,
			  vw.SHIP_PRIMARY_EMAIL_ADDRESS
              from IFT_ODM_VW as vw with (nolock)
       
              inner join

                     --people who were lapsed on 3/1/2015 (3 & 4)

                                  --people who had been members at some point before 3/1/2015   (3)
                                  (select 
                                         vw.SHIP_MASTER_CUSTOMER_ID as MC_ID,
                                         min(vw.CYCLE_BEGIN_DATE) as Initial_Begin_Date
                                         from IFT_ODM_VW as vw with (nolock)

                                  inner join                                                        --WHO ALSO

                                                --PEOPLE WHO DID NOT HAVE MEMBERSHIP ON 3/1/2015  (4)
                                                (select distinct vw.SHIP_MASTER_CUSTOMER_ID
                                                from IFT_ODM_VW as vw with (nolock)

                                                where vw.SHIP_MASTER_CUSTOMER_ID not in                  --EXCEPT
                                                              --PEOPLE WHO WERE MEMBERS ON 3/1/2015
                                                              (select 
                                                                     vw.SHIP_MASTER_CUSTOMER_ID as MC_ID
                                                                     from IFT_ODM_VW as vw with (nolock)

                                                                     where vw.LINE_STATUS_CODE = 'A' and vw.MBR_PRODUCT_LEVEL1 = 'NATL'
                                                                     and '3/1/2015' between vw.CYCLE_BEGIN_DATE and vw.CYCLE_END_DATE
                                                                     
                                                                     )
                                                              ) as nonmems

                                  on nonmems.SHIP_MASTER_CUSTOMER_ID = vw.SHIP_MASTER_CUSTOMER_ID
                                  where vw.CYCLE_END_DATE < '3/1/2015'
                                  group by vw.SHIP_MASTER_CUSTOMER_ID) as lapsed

              on vw.SHIP_MASTER_CUSTOMER_ID = lapsed.MC_ID
              where vw.LINE_STATUS_CODE = 'A' and vw.MBR_PRODUCT_LEVEL1 = 'NATL'
              and vw.INVOICE_DATE between  '3/1/2015' and '7/31/2015') as lapsedRenewed

on lapsedRenewed.MC_ID = o.SHIP_MASTER_CUSTOMER_ID

--Add in the home section descriptions:
left join IFT_CUS_ADDRESS_WITH_HOME_SECTION_VW addr on addr.MASTER_CUSTOMER_ID = o.SHIP_MASTER_CUSTOMER_ID and addr.CUS_ADDRESS_ID = o.SHIP_ADDRESS_ID
left join MBR_PRODUCT section on section.PRODUCT_ID = addr.Home_Section_Product_Id

where 
o.product_code = 'IFT2015'
and o.LINE_STATUS_CODE = 'A'
and o.invoice_date between '3/1/2015' and '7/31/2015'

order by o.Cycle_Begin_Date, o.SHIP_MASTER_CUSTOMER_ID;