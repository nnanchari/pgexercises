--Insert some data into a table
--Question
--The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:

--facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

insert into cd.facilities
values
(9,'Spa',20,30,100000,800)


--Insert multiple rows of data into a table
--Question
--In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:

--facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
--facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.

insert into cd.facilities
values
(9,'Spa',20,30,100000,800),
(10,'Squash Court 2',3.5,17.5,5000,80)


--Insert calculated data into a table
--Question
--Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:

--Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

insert into cd.facilities
values
((select max(facid)+1 from cd.facilities),'Spa',20,30,100000,800)


--Update some existing data
--Question
--We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

update cd.facilities
set initialoutlay=10000
where facid=1;

--Update multiple rows and columns at the same time
--Question
--We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for members, and 30 for guests.

update cd.facilities
set membercost=6,guestcost=30
where facid in (0,1)


--Update a row based on the contents of another row
--Question
--We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

update cd.facilities
set membercost=membercost+0.1* (select membercost from cd.facilities where facid=0)
,guestcost=guestcost+0.1* (select guestcost from cd.facilities where facid=0)
where facid=1

--Delete a member from the cd.members table
--Question
--We want to remove member 37, who has never made a booking, from our database. How can we achieve that?

delete from cd.members where memid=37	


--Delete based on a subquery
--Question
--In our previous exercises, we deleted a specific member who had never made a booking. How can we make that more general, to delete all members who have never made a booking?

delete from cd.members where memid not in
(select memid from cd.bookings)