--Retrieve the start times of members' bookings

select starttime 
from cd.bookings b 
join cd.members m on b.memid=m.memid
where m.firstname||' '||m.surname='David Farrell';

--Work out the start times of bookings for tennis courts

select b.starttime as start,f.name from cd.facilities f 
join cd.bookings b on f.facid=b.facid
where f.name like '%Tennis Court%' and cast (b.starttime as date)='2012-09-21'
order by b.starttime;

--Produce a list of all members who have recommended another member

select distinct m2.firstname,m2.surname from cd.members m1 
join cd.members m2 on m1.recommendedby=m2.memid
order by m2.surname,m2.firstname;

--Produce a list of all members, along with their recommender

select m1.firstname as memfname,m1.surname as memsname,m2.firstname as recfname,m2.surname as recsname
from cd.members m1 
left join cd.members m2 on m1.recommendedby=m2.memid
order by m1.surname,m1.firstname;

--Produce a list of all members who have used a tennis court

select distinct concat(m.firstname,' ',m.surname) as member,f.name as facility from cd.members m 
join cd.bookings b on b.memid=m.memid
join cd.facilities f on f.facid=b.facid
and f.name like 'Tennis Court%'
order by concat(m.firstname,' ',m.surname);

--Produce a list of costly bookings

select concat(m.firstname,' ',m.surname) as member, f.name as facility,
case when m.memid=0 then f.guestcost*b.slots else f.membercost*b.slots end as cost
from cd.members m join cd.bookings b 
on m.memid=b.memid
join cd.facilities f 
on b.facid=f.facid
where b.starttime >='2012-09-14' and b.starttime <'2012-09-15'
and ((m.memid=0 and f.guestcost*b.slots >30) or (m.memid<>0 and f.membercost*b.slots >30));

--Produce a list of all members, along with their recommender, using no joins.

select distinct concat(m.firstname,' ',m.surname) as member,
(select concat(r.firstname,' ',r.surname) as recommender 
from cd.members r where r.memid=m.recommendedby)
from cd.members m
order by member;
 
 --Produce a list of costly bookings, using a subquery
 
select * from 
(select concat(m.firstname,' ',m.surname) as member,
f.name as facility,
case when m.memid=0 then b.slots*f.guestcost when m.memid<>0 then b.slots*f.membercost end as cost
from cd.members m join cd.bookings b on m.memid=b.memid
join cd.facilities f on f.facid=b.facid
where b.starttime >= '2012-09-14' and b.starttime < '2012-09-15'
) as A
where A.cost >30
order by cost desc;