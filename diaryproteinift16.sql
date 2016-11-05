select top 10 * from ['Dairy Division Roster 7#6#16$'];
select top 10 * from List$;


--GO
--DELETE TOP (3) 
--FROM List$
--GO
drop table temp;

select d.* into temp from List$ d
inner join ProteinDivision p
on UPPER(d.F4) like UPPER(p.Kara) and UPPER(d.F5) like UPPER(p.Adams);

insert into temp
select d.* from List$ d
inner join ['Dairy Division Roster 7#6#16$'] p
on UPPER(d.F4) like UPPER(p.[First Name]) and UPPER(d.F5) like UPPER(p.[Last Name]);


select distinct * from temp;

--join IFT and protein
select distinct d.* from List$ d
inner join ProteinDivision p
on UPPER(d.F4) like UPPER(p.Kara) and UPPER(d.F5) like UPPER(p.Adams);


--join IFT and dairy
select distinct d.* from List$ d
inner join ['Dairy Division Roster 7#6#16$'] p
on UPPER(d.F4) like UPPER(p.[First Name]) and UPPER(d.F5) like UPPER(p.[Last Name]);