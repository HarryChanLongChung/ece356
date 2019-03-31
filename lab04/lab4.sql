-- make smallHallOfFame table that has only (playerID, yearID, Classification)
DROP TABLE IF EXISTS smallHallOfFame;
CREATE TABLE smallHallOfFame
AS
SELECT * FROM HallOfFame;

-- calculate Classification value
drop procedure if exists createClassification;

DELIMITER @@
create procedure createClassification()

Begin

Update smallHallOfFame
SET Classification := 0;

Update smallHallOfFame
SET Classification := 1
WHERE smallHallOfFame.inducted = 'Y';

Update smallHallOfFame
SET Classification := 1
WHERE smallHallOfFame.inducted = 'N'
AND smallHallOfFame.votedBy = 'Run Off'
AND smallHallOfFame.needed_note = '1st';
END@@
DELIMITER ;

call createClassification();

-- drop irrelevant columns
ALTER TABLE smallHallOfFame
DROP COLUMN votedBy,
DROP COLUMN ballots,
DROP COLUMN needed,
DROP COLUMN votes,
DROP COLUMN inducted,
DROP COLUMN category,
DROP COLUMN needed_note;

-- calculate sum of stats for all years for each player

DROP TABLE IF EXISTS Batting2;
CREATE TABLE Batting2 AS
select playerID, sum(G) AS B_G, sum(AB) AS B_AB, sum(R) AS B_R, sum(H) AS B_H, sum(2B) AS B_2B, sum(3B) AS B_3B, sum(HR) AS B_HR, sum(RBI) AS B_RBI, 
    sum(SB) AS B_SB, sum(CS) AS B_CS, sum(BB) AS B_BB, sum(SO) AS B_SO, sum(IBB) AS B_IBB, sum(HBP) AS B_HBP, sum(SH) AS B_SH, sum(SF) AS B_SF, 
    sum(GIDP) AS B_GIDP from Batting group by playerID;

ALTER TABLE Batting2
ADD CONSTRAINT `pk_Batting2` PRIMARY KEY (playerID);

DROP TABLE IF EXISTS Pitching2;
CREATE TABLE Pitching2 AS
select playerID as P_playerID, sum(W) AS P_W, sum(L) AS P_L, sum(G) AS P_G, sum(GS) AS P_GS, sum(CG) AS P_CG, sum(SHO) AS P_SHO, sum(SV) AS P_SV, sum(IPOuts) AS P_IPOuts,
    sum(H) AS P_H, sum(ER) AS P_ER, sum(HR) AS P_HR, sum(BB) AS P_BB, sum(SO) AS P_SO, avg(BAOpp) AS P_BAOpp, avg(ERA) AS P_ERA, sum(IBB) AS P_IBB, sum(WP) AS P_WP,
    sum(HBP) AS P_HBP, sum(BK) AS P_BK, sum(BFP) AS P_BFP, sum(GF) AS P_GF, sum(R) AS P_R, sum(SH) AS P_SH, sum(SF) AS P_SF, sum(GIDP) AS P_GIDP from Pitching 
    group by P_playerID;

ALTER TABLE Pitching2
ADD CONSTRAINT `pk_Pitching2` PRIMARY KEY (P_playerID);

-- combine the two tables using full outer join

DROP TABLE IF EXISTS Life_Record;
CREATE TABLE Life_Record AS
select * from
Batting2 left join Pitching2 
on Batting2.playerID = Pitching2.P_playerID
union 
select * from
Batting2 right join Pitching2 
on Batting2.playerID = Pitching2.P_playerID;

-- make the final dataset

select playerID,yearID,B_G,B_AB,B_R,B_H,B_2B,B_3B,B_HR,B_RBI,B_SB,B_CS,B_BB,B_SO,B_IBB,B_HBP,B_SH,B_SF,B_GIDP,P_W,P_L,P_G,P_GS,P_CG,P_SHO,P_SV,P_IPOuts,P_H,P_ER,P_HR,P_BB,P_SO,P_BAOpp,P_ERA,P_IBB,P_WP,P_HBP,P_BK,P_BFP,P_GF,P_R,P_SH,P_SF,P_GIDP,Classification
from 
(
  select playerID, yearID, sum(Classification) >= 1 as Classification from smallHallOfFame group by playerID, yearID 
) as realHOF
left join Life_Record using (playerID);
