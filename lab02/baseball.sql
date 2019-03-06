-- lab2
-- part 2

-- a)
-- select count(PlayerID) as players_having_unknow_birthdate from Master 
-- where birthYear = 0 or birthMonth = 0 or birthDay = 0;

-- birthYear, birthMonth, birthDay are used in 'where'
CREATE INDEX IX_master_birthYear ON Master(birthYear);
CREATE INDEX IX_master_birthMonth ON Master(birthMonth);
CREATE INDEX IX_master_birthDay ON Master(birthDay);

-- b)
-- select 
-- (   
--     (select count(distinct h.playerID) from HallOfFame as h 
--     inner join Master as m  on h.playerID = m.playerID where m.deathYear <> 0)
--     - 
--     (select count(distinct h.playerID) from HallOfFame as h 
--     inner join Master as m  on h.playerID = m.playerID where m.deathYear = 0)
-- ) as pplStillAlive;

-- HallOfFame.playerID is used in inner join
-- Master.deathYear is used in where
CREATE INDEX IX_master_deathYear ON Master(deathYear);
CREATE INDEX IX_HallOfFame_playerID ON HallOfFame(playerID);

-- c)
-- create view r as select playerID, sum(salary) as totalSalary from Salaries 
-- group by playerID;
-- create view maxSalary as select max(totalSalary) as s from r;

-- select CONCAT(a.nameGiven, a.nameLast) as most_paid_player from Master as a
-- inner join r as b on a.playerID = b.playerID
-- inner join maxSalary as ms on b.totalSalary = ms.s;
CREATE INDEX IX_Salaries_playerID ON Salaries(playerID);


-- d)
-- create view sum_of_player as 
-- select count(distinct playerID) as sum_of_player from Master;

-- select (sum(a.hr)/b.sum_of_player) as avg_number_of_homeruns from Batting as a
-- inner join sum_of_player as b;

-- fields in count() don't need index

-- e)
-- create view player_with_at_leaset_1_homerun as 
-- select count(distinct playerID) as playerCount from Batting 
-- where hr >= 1;

-- select (sum(a.hr)/b.playerCount) as avg_number_of_homeruns_only_with_at_least_1_homerun from Batting as a
-- inner join player_with_at_leaset_1_homerun as b;

-- fields in count() don't need index

-- f)
-- create view average_homerun as 
-- select sum(a.hr)/b.sum_of_player as avg_hr from Batting as a
-- inner join sum_of_player as b;

-- create view average_sho as 
-- select sum(a.sho)/b.sum_of_player as avg_sho from Pitching as a
-- inner join sum_of_player as b;

-- create view above_avg_hr as 
-- select playerID from Batting as a 
-- inner join average_homerun as b
-- where a.hr > b.avg_hr;

-- create view above_avg_sho as 
-- select playerID from Pitching as a 
-- inner join average_sho as b
-- where a.sho > b.avg_sho;

-- select count(a.playerID) as number_of_players_who_are_both_good_batters_and_good_pitchers from above_avg_hr as a 
-- inner join above_avg_sho as b on a.playerID = b.playerID;

CREATE INDEX IX_Batting_playerID ON Batting(playerID);
CREATE INDEX IX_Pitching_playerID ON Pitching(playerID);
