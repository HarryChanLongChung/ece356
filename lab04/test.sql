mysql -u z7bai -p -h marmoset04.shoshin.uwaterloo.ca

mysql -u z7bai -p -h marmoset04.shoshin.uwaterloo.ca --password=wocao356 db356_z7bai -B < query.sql | tr '\t' ',' > batting.csv
mysql -u z7bai -p -h marmoset04.shoshin.uwaterloo.ca --password=wocao356 db356_z7bai -B < query.sql | tr '\t' ',' > pitching.csv

mysql root --password=wocao lahman2016 -B < query.sql | tr '\t' ',' > data.csv



 mysql -u root -p lahman2016 -B < ~/Downloads/query.sql | tr '\t' ',' > data.csv


select count(*) from Batting2;
select count(distinct playerID) from Batting2;
select count(distinct playerID, yearID, stint) from Batting2;

select count(distinct playerID, yearID, teamID) from Batting2;


select count(distinct playerID, yearID) from Pitching2;


select count(distinct playerID) from HallOfFame;
select count(distinct playerID, yearID) from smallHallOfFame;

select count(*) from Batting2 inner join Pitching2 using (playerID, yearID);
select count(distinct playerID, yearID) from Batting2 inner join Pitching2 using (playerID, yearID);


select count(*) from Pitching2 inner join Batting2 using (playerID, yearID, stint) where Pitching2.stint = Batting2.stint

select sum()



select * from 
(
  select playerID, yearID, sum(Classification) >= 1 as Classification from HallOfFame group by playerID, yearID 
) as realHOF
left join Life_Record using (playerID) order by playerID;
