-- Count the number of expensive facilities
-- Question
-- Produce a count of the number of facilities that have a cost to guests of 10 or more.

select count(*) from cd.facilities 
where guestcost>=10;


-- Count the number of recommendations each member makes.
-- Question
-- Produce a count of the number of recommendations each member has made. Order by member ID.

select recommendedby,count(*) from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby


-- List the total slots booked per facility
-- Question
-- Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.

select facid,sum(slots) as totalslots 
from cd.bookings
group by facid
order by facid


-- List the total slots booked per facility in a given month
-- Question
-- Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.

select facid,sum(slots) from cd.bookings
where extract(year from starttime)='2012' and extract(month from starttime)='09'
group by facid
order by sum(slots)

-- List the total slots booked per facility per month
-- Question
-- Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.


select facid,extract(month from starttime),sum(slots) from cd.bookings
where extract(year from starttime)='2012' 
group by facid,extract(month from starttime)
order by facid,extract(month from starttime)


-- Find the count of members who have made at least one booking
-- Question
-- Find the total number of members who have made at least one booking.

select count(*) from cd.members where memid in (select memid from cd.bookings)


-- List facilities with more than 1000 slots booked
-- Question
-- Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and hours, sorted by facility id

select facid,sum(slots) from cd.bookings
group by facid
having sum(slots) >1000
order by facid


-- Find the total revenue of each facility
-- Question
-- Produce a list of facilities along with their total revenue. The output table should consist of facility name and revenue, sorted by revenue. Remember that theres a different cost for guests and members!


select f.name, sum(case when b.memid=0 then b.slots*f.guestcost else b.slots*f.membercost end) as revenue
from cd.bookings b join cd.facilities f on b.facid=f.facid
group by f.name
order by revenue


-- Find facilities with a total revenue less than 1000
-- Question
-- Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. Remember that theres a different cost for guests and members!


select f.name, 
sum(case when b.memid=0 then b.slots*f.guestcost else b.slots*f.membercost end) as revenue
from cd.bookings b join cd.facilities f on b.facid=f.facid
group by f.name
having sum(case when b.memid=0 then b.slots*f.guestcost else b.slots*f.membercost end) < 1000
order by revenue


-- Output the facility id that has the highest number of slots booked
-- Question
-- Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause. This version will probably look messy!


select facid, sum(slots) from cd.bookings
group by facid
having sum(slots)= 
(select max(s) from (select sum(slots) as s from cd.bookings group by facid) A)

with t as (select facid, sum(slots) as s from cd.bookings group by facid)

select facid,s from t where s=(select max(s) from t)


-- List the total slots booked per facility per month, part 2
-- Question
-- Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. The output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.

with temp as (select facid,extract(month from starttime) as m,slots
from cd.bookings 
where extract(year from starttime)='2012'  
)

select facid,m,sum(slots) from temp group by facid,m
union 
select facid,null,sum(slots) from temp group by facid
union 
select null,null,sum(slots) from temp
order by facid,m


-- List the total hours booked per named facility
-- Question
-- Produce a list of the total number of hours booked per facility, remembering that a slot lasts half an hour. The output table should consist of the facility id, name, and hours booked, sorted by facility id. Try formatting the hours to two decimal places.

select b.facid,f.name, round(sum(b.slots)/2.0,2) as totalhours
from cd.bookings b join cd.facilities f
on b.facid=f.facid
group by 1,2
order by 1



-- List each members first booking after September 1st 2012
-- Question
-- Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.


select m.surname,m.firstname,m.memid,min(b.starttime) 
from cd.members m join cd.bookings b
on m.memid=b.memid
where b.starttime> '2012-09-01'
group by 1,2,3
order by 3


-- Produce a list of member names, with each row containing the total member count
-- Question
-- Produce a list of member names, with each row containing the total member count. Order by join date.

select count(*) over(),firstname,surname from cd.members
order by joindate