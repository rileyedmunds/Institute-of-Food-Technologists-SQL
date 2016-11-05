USE UPLOADS
/*
Personify vs Hubspot:
	Personify: has MC_ID
	Hubspot: does NOT have MC_ID	
*/

--Personify:
select * from IftAH00155686_GRP_OP_v2 I
where Member_id != 'NULL'
and I.AGM_Group_ID in
       (select AGM_Group_ID from IftAH00155686_GRP_OP_v2
       group by AGM_Group_ID
       having count(AGM_Group_ID) > 1);

--Hubspot:
select * from IftAH00155686_GRP_OP_v2 I
where Member_id = 'NULL'
and I.AGM_Group_ID in
       (select AGM_Group_ID from IftAH00155686_GRP_OP_v2
       group by AGM_Group_ID
       having count(AGM_Group_ID) > 1);


--Number of rows that have a group number that is used by more than one row
select count(*) from IftAH00155686_GRP_OP_v2 I
where I.AGM_Group_ID in
       (select AGM_Group_ID from IftAH00155686_GRP_OP_v2
       group by AGM_Group_ID
       having count(AGM_Group_ID) > 1);

DROP TABLE counts_table;
CREATE TABLE counts_table
(
num_sets INT,
num_member_groups INT)


--number of rows that pertain to each group for groups with more than one member
DECLARE @cnt INT = 1
WHILE @cnt <= 
				/*
				Max number of ways a group number is shared: 109
				*/
				(select max(i.counts)
				from
					   (select count(AGM_Group_ID) as counts from IftAH00155686_GRP_OP_v2
					   group by AGM_Group_ID
					   having count(AGM_Group_ID) > 1) I)
BEGIN
   
   insert into counts_table
   select count(a.AGM_Group_ID)/@cnt, @cnt from
		--OUR 32K
		(select * from IftAH00155686_GRP_OP_v2 I
		where I.AGM_Group_ID in
			   (select AGM_Group_ID from IftAH00155686_GRP_OP_v2
			   group by AGM_Group_ID
			   having count(AGM_Group_ID) = @cnt)) a

		having count(a.AGM_Group_ID)/@cnt != 0

   SET @cnt = @cnt + 1;
END;



select * from counts_table;




