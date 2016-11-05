--general syntax for executing a cross-server connection:
exec sp_addlinkedserver    @server='SQLCLUSTER1'
exec sp_linkedservers

--test the cross-server connecion with a query to the foreign server
select top 100 * from SQLCLUSTER1.PPRO.dbo.IFT_ODM_VW;

--execute some cross-server query
select distinct odm.SHIP_MASTER_CUSTOMER_ID, o.* from comMembers o
inner join SQLCLUSTER1.PPRO.dbo.IFT_ODM_VW odm
on odm.SHIP_FIRST_NAME = o.FIRST_NAME and odm.SHIP_LAST_NAME = o.LAST_NAME;