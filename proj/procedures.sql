-- procedures below

-- addAccount procedure
drop procedure if exists addAccount;

DELIMITER @@
create procedure addAccount(
    IN account_Name varchar(100),
    IN password varchar(100),
    IN firstName varchar(100),
    IN lastName varchar(100), 
    IN sex varchar(100), 
    IN birthdate date
)
Begin
insert into Account(account_Name, password, firstName, lastName, sex, birthdate) values (account_Name, password, firstName, lastName, sex, birthdate);
END@@
DELIMITER ;

-- addGroup procedure
drop procedure if exists addGroup;

DELIMITER @@
create procedure addGroup(
    IN group_ID int(11),
    IN group_Name varchar(100), 
    IN description varchar(100),
    IN account_ID int(11)
)
Begin
insert into Groups(group_ID, group_Name, description, account_ID) values (group_ID, group_Name, description, account_ID);
END@@
DELIMITER ;

-- addFollower procedure
drop procedure if exists addFollower;

DELIMITER @@
create procedure addFollower(
    IN account_ID int(11),
    IN follower_ID int(11)
)
Begin
insert into Follower(account_ID, follower_ID) values (account_ID, follower_ID);
END@@
DELIMITER ;

-- addTag procedure
drop procedure if exists addTag;

DELIMITER @@
create procedure addTag(
    IN tagName varchar(255),
    IN post_ID int
)
Begin
insert into Tag(tag_name, post_ID) values (tagName,post_ID);
END@@
DELIMITER ;

-- addPost procedure
drop procedure if exists addPost;

DELIMITER @@
create procedure addPost(
    IN times timestamp,
    IN account_ID int(11),
    IN message varchar(100), 
    IN thumbs int(11), 
    IN is_read int(11)
)
Begin
insert into user_post(times, account_ID, message, thumbs, is_read) values (times, account_ID, message, thumbs, is_read);
END@@
DELIMITER ;

-- addFollowTag procedure
drop procedure if exists addFollowTag;

DELIMITER @@
create procedure addFollowTag(
    IN tag_ID int(11),
    IN follower_ID int(11)
)
Begin
insert into FollowTag(tag_ID, follower_ID) values (tag_ID, follower_ID);
END@@
DELIMITER ;

-- login procedure
drop procedure if exists loginProcedure;

DELIMITER @@
create procedure loginProcedure(
    IN account_Name varchar(100),
    IN password varchar(100),
    OUT checkUser int(11)
)
Begin
SET checkUser := 0;
SET checkUser := (select count(*) from Account where account_Name = Account.account_Name and password = Account.password);
select checkUser;
END@@
DELIMITER ;


-- check valid Post
drop procedure if exists checkValidPost;

DELIMITER @@
create procedure checkValidPost(
    IN post_ID int(11),
    OUT checkPost int(11)
)
Begin
SET checkPost := 0;
SET checkPost := (select count(*) from User_post where post_ID = User_post.post_ID);
select checkPost;
END@@
DELIMITER ;

-- check valid Group ID
drop procedure if exists checkValidGroup;

DELIMITER @@
create procedure checkValidGroup(
    IN group_ID int(11),
    OUT checkGroup int(11)
)
Begin
SET checkGroup := 0;
SET checkGroup := (select count(*) from User_group where group_ID = User_group.group_ID);
select checkGroup;
END@@
DELIMITER ;

-- check for dupliate account names
drop procedure if exists checkDuplicateAccount;

DELIMITER @@
create procedure checkDuplicateAccount(
    IN account_Name varchar(100),
    OUT checkUser int(11)
)
Begin
SET checkUser := 0;
SET checkUser := (select count(*) from Account where account_Name = Account.account_Name);
select checkUser;
END@@
DELIMITER ;

-- users view posts
drop procedure if exists viewPost;

DELIMITER @@
create procedure viewPost(
    IN post_ID int(11)
)
Begin
select post_ID, message, thumbs, is_read from User_post where post_ID = User_post.post_ID;
END@@
DELIMITER ;

-- upvote procedure
drop procedure if exists upvote;

DELIMITER @@
create procedure upvote(
    IN post_ID int(11)
)
Begin
UPDATE User_post SET thumbs = thumbs+1 WHERE post_ID = User_post.post_ID;
END@@
DELIMITER ;

-- downvote procedure
drop procedure if exists downvote;

DELIMITER @@
create procedure downvote(
    IN post_ID int(11)
)
Begin
UPDATE User_post SET thumbs = thumbs-1 WHERE post_ID = User_post.post_ID;
END@@
DELIMITER ;

-- join group procedure
drop procedure if exists joinGroup;

DELIMITER @@
create procedure joinGroup(
    IN group_ID int(11),
    IN account_Name varchar(100)
)
Begin
DECLARE account_ID varchar(100);
DECLARE group_Name varchar(100);
DECLARE description varchar(100);
SET account_ID := (select account_ID from Account where account_Name = Account.account_Name);
SET group_Name := (select group_Name from User_group where group_ID = User_group.group_ID);
SET description := (select description from User_group where group_ID = User_group.group_ID);
insert into Groups(group_ID, group_Name, description, account_ID) values (group_ID, group_Name, description, account_ID);
END@@
DELIMITER ;
