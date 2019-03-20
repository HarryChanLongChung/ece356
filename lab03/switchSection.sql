drop procedure if exists switchSection;

set autocommit = 0;

DELIMITER @@
create procedure switchSection(IN courseID varchar(255), IN section1 int, IN section2 int, IN termCode int, IN quantity int, OUT errorCode int)
Begin

DECLARE enroll int;
DECLARE enroll2 int;
DECLARE capacityNum int;

START TRANSACTION;

update Offering set enrollment := enrollment - quantity where Offering.courseID=courseID and Offering.section=section1 and Offering.termCode=termCode;
update Offering set enrollment := enrollment + quantity where Offering.courseID=courseID and Offering.section=section2 and Offering.termCode=termCode;

SET errorCode := 0;

IF not exists (select courseID, section, termCode from Offering where Offering.courseID = courseID and Offering.section = section1 and Offering.termCode = termCode) OR not exists (select courseID, section, termCode from Offering where Offering.courseID = courseID and Offering.section = section2 and Offering.termCode = termCode) THEN
SET errorCode := -1;

ELSEIF (quantity <= 0) THEN
SET errorCode := -1;

ELSEIF section1 = section2 THEN
SET errorCode := -1;

END IF;

SET enroll := (select enrollment from Offering where Offering.courseID = courseID and Offering.section = section1 and Offering.termCode = termCode);

SET enroll2 := (select enrollment from Offering where Offering.courseID = courseID and Offering.section = section2 and Offering.termCode = termCode);

SET capacityNum := (select capacity from Classroom inner join Offering using (roomID) where Offering.courseID = courseID and Offering.section = section2 and Offering.termCode = termCode);

IF enroll < 0 THEN
SET errorCode := -2;
ELSEIF enroll2 > capacityNum THEN 
SET errorCode := -3;
END IF;

IF errorCode != 0 THEN ROLLBACK;
ELSE COMMIT;
END IF;


select errorCode;

END@@
DELIMITER ;

-- test cases
-- courseID doesn't exist
call switchSection('bob', 1, 2, 1191, 1, @errorCode); 
-- returns errorCode -1

-- section 1 doesn't exist
call switchSection('ECE356', 10, 2, 1191, 1, @errorCode);
-- returns errorCode -1

-- section 2 doesn't exist
call switchSection('ECE356', 1, 22, 1191, 1, @errorCode);
-- returns errorCode -1

-- termCode doesn't exist
call switchSection('ECE356', 1, 2, 9991, 1, @errorCode);
-- returns errorCode -1

-- quantity = 0
call switchSection('ECE356', 1, 2, 1191, 0, @errorCode);
-- returns errorCode -1

-- quantity < 0
call switchSection('ECE356', 1, 2, 1191, -200, @errorCode);
-- returns errorCode -1

-- section 1 = section 2
call switchSection('ECE356', 1, 1, 1191, 1, @errorCode);
-- returns errorCode -1

-- section 1 negative enrollment
call switchSection('ECE356', 1, 2, 1191, 800, @errorCode);
-- returns errorCode -2

-- section 2 exceed capacity
call switchSection('ECE356', 1, 2, 1191, 40, @errorCode);
-- returns errorCode -2

-- success
call switchSection('ECE356', 1, 2, 1191, 1, @errorCode);
-- returns errorCode 0