DROP DATABASE IF EXISTS ECE356_project;
CREATE DATABASE ECE356_project;
USE ECE356_project;

drop table if exists Account;
drop table if exists User_group;
drop table if exists Follower;
drop table if exists Tag;
drop table if exists User_post;
drop table if exists FollowTag;

create table Account(
    account_ID int(11) AUTO_INCREMENT primary key,
    password varchar(100), 
    account_Name varchar(100), 
    firstName varchar(100),
    lastName varchar(100), 
    sex varchar(100), 
    birthdate date
);

create table User_group(
    group_ID int(11) AUTO_INCREMENT primary key , 
    group_Name varchar(100), 
    description varchar(100),
    account_ID int(11)
);

create table Follower(
    account_ID int(11),
    follower_ID int(11)
);

create table Tag(
    tag_ID int(11) AUTO_INCREMENT primary key, 
    tag_Name varchar(100), 
    post_ID int(11)
);

create table User_post(
    post_ID int(11) AUTO_INCREMENT primary key, 
    times timestamp,
    account_ID int(11),
    message varchar(100), 
    thumbs int(11), 
    is_read int(11)
);

create table FollowTag(
    tag_ID int(11),
    follower_ID int(11)
);

-- procedures below

-- addAccount procedure
-- drop procedure if exists addAccount;

-- DELIMITER @@
-- create procedure addAccount(
--     IN account_Name varchar(100),
--     IN password varchar(100),
--     IN firstName varchar(100),
--     IN lastName varchar(100), 
--     IN sex varchar(100), 
--     IN birthdate date
-- )
-- Begin
-- insert into Account(account_Name, password, firstName, lastName, sex, birthdate) values (account_Name, password, firstName, lastName, sex, birthdate);
-- END@@
-- DELIMITER ;

-- call addAccount("bob", "123", "jackie", "sun", "?", 11/11/1111);

-- -- addGroup procedure
-- drop procedure if exists addGroup;

-- DELIMITER @@
-- create procedure addGroup(
--     IN group_Name varchar(100), 
--     IN description varchar(100),
--     IN account_ID int(11)
-- )
-- Begin
-- insert into Groups(group_Name, description, account_ID) values (group_Name, description, account_ID);
-- END@@
-- DELIMITER ;

-- -- addFollower procedure
-- drop procedure if exists addFollower;

-- DELIMITER @@
-- create procedure addFollower(
--     IN account_ID int(11),
--     IN follower_ID int(11)
-- )
-- Begin
-- insert into Follower(account_ID, follower_ID) values (account_ID, follower_ID);
-- END@@
-- DELIMITER ;

-- -- addTag procedure
-- drop procedure if exists addTag;

-- DELIMITER @@
-- create procedure addTag(
--     IN tagName varchar(255),
--     IN post_ID int
-- )
-- Begin
-- insert into Tag(tag_name, post_ID) values (tagName,post_ID);
-- END@@
-- DELIMITER ;

-- -- addPost procedure
-- drop procedure if exists addPost;

-- DELIMITER @@
-- create procedure addPost(
--     IN times timestamp,
--     IN account_ID int(11),
--     IN message varchar(100), 
--     IN thumbs int(11), 
--     IN is_read int(11)
-- )
-- Begin
-- insert into Post(times, account_ID, message, thumbs, is_read) values (times, account_ID, message, thumbs, is_read);
-- END@@
-- DELIMITER ;

-- -- addFollowTag procedure
-- drop procedure if exists addFollowTag;

-- DELIMITER @@
-- create procedure addFollowTag(
--     IN tag_ID int(11),
--     IN follower_ID int(11)
-- )
-- Begin
-- insert into FollowTag(tag_ID, follower_ID) values (tag_ID, follower_ID);
-- END@@
-- DELIMITER ;

-- --login procedure
-- drop procedure if exists loginProcedure;

-- DELIMITER @@
-- create procedure loginProcedure(
--     IN account_Name varchar(100),
--     IN password varchar(100),
--     OUT checkUser int(11)
-- )
-- Begin
-- SET checkUser := 0;
-- SET checkUser := (select count(*) from Account where account_Name = Account.account_Name and password = Account.password);
-- select checkUser;
-- END@@
-- DELIMITER ;

-- call loginProcedure("bob", "123", @checkUser);

-- new stuff under here
-- call loginProcedure("bob", "123", @checkUser);

-- chehck for dupliate account names
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

-- call checkDuplicateAccount("bob", @checkUser);


-- users view posts
drop procedure if exists viewPost;

DELIMITER @@
create procedure viewPost(
    IN post_ID int(11),
    OUT checkPost int(11)
)
Begin
SET checkPost := 0;
SET checkPost := (select count(*) from User_post where post_ID = User_post.post_ID);
IF checkPost = 1 THEN
select post_ID, message, thumbs, is_read from User_post where post_ID = User_post.post_ID;
END IF;
select checkPost;
END@@
DELIMITER ;

-- call viewPost(1, @checkPost);

-- upvote procedure
drop procedure if exists upvote;

DELIMITER @@
create procedure upvote(
    IN post_ID int(11),
    OUT checkPost int(11)
)
Begin
SET checkPost := 0;
SET checkPost := (select count(*) from User_post where post_ID = User_post.post_ID);
IF checkPost = 1 THEN
UPDATE User_post SET thumbs = thumbs+1 WHERE post_ID = User_post.post_ID;
END IF;
select checkPost;
END@@
DELIMITER ;

-- call upvote(1, @checkPost);