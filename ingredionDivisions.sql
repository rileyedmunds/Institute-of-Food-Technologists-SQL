select o.* from ingredionIFTmem i
inner join [output_group_member] o
on i.SHIP_FIRST_NAME like ["First Name"] and i.SHIP_LAST_NAME like o.["Last Name"];


select count(distinct SHIP_FIRST_NAME) from ingredionIFTmem i
inner join [output_group_member] o
on i.SHIP_FIRST_NAME like ["First Name"] and i.SHIP_LAST_NAME like o.["Last Name"];


select * from ingredionIFTmem i;
select * from [output_group_member];