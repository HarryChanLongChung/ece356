-- Questions 1)
-- a)
select count(PlayerID) as players_having_unknow_birthdate from Master 
where birthYear = 0 or birthMonth = 0 or birthDay = 0;

-- b)
select 
(   
    (select count(distinct h.playerID) from HallOfFame as h 
    inner join Master as m  on h.playerID = m.playerID where m.deathYear <> 0)
    - 
    (select count(distinct h.playerID) from HallOfFame as h 
    inner join Master as m  on h.playerID = m.playerID where m.deathYear = 0)
) as pplStillAlive;

-- c)
create view r as select playerID, sum(salary) as totalSalary from Salaries 
group by playerID;
create view maxSalary as select max(totalSalary) as s from r;

select CONCAT(a.nameGiven, a.nameLast) as most_paid_player from Master as a
inner join r as b on a.playerID = b.playerID
inner join maxSalary as ms on b.totalSalary = ms.s;

-- d)
create view sum_of_player as 
select count(distinct playerID) as sum_of_player from Master;

select (sum(a.hr)/b.sum_of_player) as avg_number_of_homeruns from Batting as a
inner join sum_of_player as b;

-- e)
create view player_with_at_leaset_1_homerun as 
select count(distinct playerID) as playerCount from Batting 
where hr >= 1;

select (sum(a.hr)/b.playerCount) as avg_number_of_homeruns_only_with_at_least_1_homerun from Batting as a
inner join player_with_at_leaset_1_homerun as b;

-- f)
create view average_homerun as 
select sum(a.hr)/b.sum_of_player as avg_hr from Batting as a
inner join sum_of_player as b;

create view average_sho as 
select sum(a.sho)/b.sum_of_player as avg_sho from Pitching as a
inner join sum_of_player as b;

create view above_avg_hr as 
select playerID from Batting as a 
inner join average_homerun as b
where a.hr > b.avg_hr;

create view above_avg_sho as 
select playerID from Pitching as a 
inner join average_sho as b
where a.sho > b.avg_sho;

select count(a.playerID) as number_of_players_who_are_both_good_batters_and_good_pitchers from above_avg_hr as a 
inner join above_avg_sho as b on a.playerID = b.playerID;

-- remove all views
-- drop view above_avg_hr;                    
-- drop view above_avg_sho;                   
-- drop view average_homerun;                 
-- drop view average_sho;                     
-- drop view maxSalary;                       
-- drop view player_with_at_leaset_1_homerun;
-- drop view r;                  
-- drop view sum_of_player;

-- Questions 2)
-- please change the file path when testing
LOAD DATA LOCAL INFILE  '/Users/brickbai/Downloads/Fielding.csv'
INTO TABLE Fielding
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(playerID, @yearID, @stint, teamID, lgID, POS, @G, GS, InnOuts, @PO, @A, @E, @DP, PB, WP, SB, CS, ZR)
SET yearID = nullif(@yearID,''), -- to get rid of warnings
    G = nullif(@G,''),
    PO = nullif(@PO,''),
    A = nullif(@A,''),
    E = nullif(@E,''),
    DP = nullif(@DP,'');
