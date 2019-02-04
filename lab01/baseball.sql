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

-- Questions 3)
-- First add the primary keys to the tables
ALTER TABLE Master
ADD CONSTRAINT `pk_Master` PRIMARY KEY (playerID);

ALTER TABLE AllstarFull
ADD CONSTRAINT `pk_AllstarFull` PRIMARY KEY (playerID, gameID);

ALTER TABLE HallOfFame
ADD CONSTRAINT `pk_HallOfFame` PRIMARY KEY (playerID, yearid, votes);

ALTER TABLE Managers
ADD CONSTRAINT `pk_Managers` PRIMARY KEY (playerID, G, rank, yearID);

ALTER TABLE Teams
ADD CONSTRAINT `pk_Teams` PRIMARY KEY (teamID, yearID, lgID);

ALTER TABLE BattingPost
ADD CONSTRAINT `pk_BattingPost` PRIMARY KEY (playerID, yearID, round);

ALTER TABLE PitchingPost
ADD CONSTRAINT `pk_PitchingPost` PRIMARY KEY (playerID, yearID, round);

ALTER TABLE TeamsFranchises
ADD CONSTRAINT `pk_TeamsFranchises` PRIMARY KEY (franchID);

ALTER TABLE Fielding
ADD CONSTRAINT `pk_Fielding` PRIMARY KEY (playerID, yearID, Pos, InnOuts, stint);

ALTER TABLE FieldingOF
ADD CONSTRAINT `pk_FieldingOF` PRIMARY KEY (playerID, yearID, stint);

ALTER TABLE FieldingPost
ADD CONSTRAINT `pk_FieldingPost` PRIMARY KEY (playerID, yearID, round, Pos);

ALTER TABLE FieldingOFsplit
ADD CONSTRAINT `pk_FieldingOFsplit` PRIMARY KEY (playerID, yearID, Pos, InnOuts);

ALTER TABLE ManagersHalf
ADD CONSTRAINT `pk_ManagersHalf` PRIMARY KEY (playerID, rank, G);

ALTER TABLE TeamsHalf
ADD CONSTRAINT `pk_TeamsHalf` PRIMARY KEY (teamID, yearID, lgID);

ALTER TABLE Salaries
ADD CONSTRAINT `pk_Salaries` PRIMARY KEY (yearID, playerID, lgID);

ALTER TABLE SeriesPost
ADD CONSTRAINT `pk_SeriesPost` PRIMARY KEY (yearID, teamID);

ALTER TABLE AwardsManagers
ADD CONSTRAINT `pk_AwardsManagers` PRIMARY KEY (yearID, awardID, playerID);

ALTER TABLE AwardsPlayers
ADD CONSTRAINT `pk_AwardsPlayers` PRIMARY KEY (yearID, awardID, playerID, lgID);

ALTER TABLE AwardsShareManagers
ADD CONSTRAINT `pk_AwardsShareManagers` PRIMARY KEY (yearID, playerID);

ALTER TABLE AwardsSharePlayers
ADD CONSTRAINT `pk_AwardsSharePlayers` PRIMARY KEY (awardID, yearID, playerID);

ALTER TABLE Appearances
ADD CONSTRAINT `pk_Appearances` PRIMARY KEY (awardID, yearID, playerID);

ALTER TABLE Schools
ADD CONSTRAINT `pk_Schools` PRIMARY KEY (schoolID);

ALTER TABLE CollegePlaying
ADD CONSTRAINT `pk_CollegePlaying` PRIMARY KEY (playerID, schoolID, yearID);

ALTER TABLE Parks
ADD CONSTRAINT `pk_Parks` PRIMARY KEY (`park.key`);

ALTER TABLE HomeGames
ADD CONSTRAINT `pk_HomeGames` PRIMARY KEY (`span.first`, `team.key`);

ALTER TABLE Batting
ADD CONSTRAINT `pk_Batting` PRIMARY KEY (yearID, playerID, stint);

ALTER TABLE Pitching
ADD CONSTRAINT `pk_Pitching` PRIMARY KEY (yearID, playerID, stint);

-- Now add the foreign keys for each table
ALTER TABLE AllstarFull
ADD CONSTRAINT `fk_AllstarFull_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE AllstarFull
ADD CONSTRAINT `fk_AllstarFull_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE HallOfFame
ADD CONSTRAINT `fk_HallOfFame_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE Managers
ADD CONSTRAINT `fk_Managers_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE Managers
ADD CONSTRAINT `fk_Managers_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE Teams
ADD CONSTRAINT `fk_Teams_TeamsFranchises` FOREIGN KEY (franchID) REFERENCES TeamsFranchises (franchID);

ALTER TABLE BattingPost
ADD CONSTRAINT `fk_BattingPost_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE BattingPost
ADD CONSTRAINT `fk_BattingPost_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE PitchingPost
ADD CONSTRAINT `fk_PitchingPost_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE PitchingPost
ADD CONSTRAINT `fk_PitchingPost_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE Fielding
ADD CONSTRAINT `fk_FieldingOF_Batting` FOREIGN KEY (yearID, playerID, stint) REFERENCES Batting (yearID, playerID, stint);

ALTER TABLE Fielding
ADD CONSTRAINT `fk_FieldingOF_Pitching` FOREIGN KEY (yearID, playerID, stint) REFERENCES Pitching (yearID, playerID, stint);

ALTER TABLE Fielding
ADD CONSTRAINT `fk_FieldingOF_FieldingOF` FOREIGN KEY (yearID, playerID, stint) REFERENCES FieldingOF (yearID, playerID, stint);

ALTER TABLE Fielding
ADD CONSTRAINT `fk_FieldingOF_FieldingOFsplit` FOREIGN KEY (playerID, yearID, Pos, InnOuts) REFERENCES FieldingOFsplit (playerID, yearID, Pos, InnOuts);

ALTER TABLE FieldingOF
ADD CONSTRAINT `fk_FieldingOF_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE FieldingOF
ADD CONSTRAINT `fk_FieldingOF_Batting` FOREIGN KEY (yearID, playerID, stint) REFERENCES Batting (yearID, playerID, stint);

ALTER TABLE FieldingPost
ADD CONSTRAINT `fk_FieldingPost_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE FieldingPost
ADD CONSTRAINT `fk_FieldingPost_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE FieldingPost
ADD CONSTRAINT `fk_FieldingPost_BattingPost` FOREIGN KEY (playerID, yearID, round) REFERENCES BattingPost (playerID, yearID, round);

ALTER TABLE FieldingOFsplit
ADD CONSTRAINT `fk_FieldingOFsplit_Batting` FOREIGN KEY (yearID, playerID, stint) REFERENCES Batting (yearID, playerID, stint);

ALTER TABLE FieldingOFsplit
ADD CONSTRAINT `fk_FieldingOFsplit_pitching` FOREIGN KEY (yearID, playerID, stint) REFERENCES Pitching (yearID, playerID, stint);

ALTER TABLE FieldingOFsplit
ADD CONSTRAINT `fk_FieldingOFsplit_FieldingOF` FOREIGN KEY (yearID, playerID, stint) REFERENCES FieldingOF (yearID, playerID, stint);

ALTER TABLE ManagersHalf
ADD CONSTRAINT `fk_ManagersHalf_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE ManagersHalf
ADD CONSTRAINT `fk_ManagersHalf_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE TeamsHalf
ADD CONSTRAINT `fk_TeamsHalf_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE Salaries
ADD CONSTRAINT `fk_Salaries_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE Salaries
ADD CONSTRAINT `fk_Salaries_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE AwardsManagers
ADD CONSTRAINT `fk_AwardsManagers_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE AwardsPlayers
ADD CONSTRAINT `fk_AwardsPlayers_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE AwardsShareManagers
ADD CONSTRAINT `fk_AwardsShareManagers_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE AwardsSharePlayers
ADD CONSTRAINT `fk_AwardsSharePlayers_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE Appearances
ADD CONSTRAINT `fk_Appearances_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE Appearances
ADD CONSTRAINT `fk_Appearances_Teams` FOREIGN KEY (teamID, yearID, lgID) REFERENCES Teams (teamID, yearID, lgID);

ALTER TABLE CollegePlaying
ADD CONSTRAINT `fk_CollegePlaying_Master` FOREIGN KEY (playerID) REFERENCES Master (playerID);

ALTER TABLE CollegePlaying
ADD CONSTRAINT `fk_CollegePlaying_Schools` FOREIGN KEY (schoolID) REFERENCES Schools (schoolID);