DROP DATABASE IF EXISTS ECE356_project;
CREATE DATABASE ECE356_project;
USE ECE356_project;
drop table if exists Account;
drop table if exists User_group;
drop table if exists Follower;
drop table if exists Post_Tag;
drop table if exists User_post;
drop table if exists Follow_Tag;
drop table if exists Group_members;
create table Account(
    account_ID int(11) AUTO_INCREMENT primary key, 
    account_Name varchar(100), 
    password varchar(100),
    firstName varchar(100),
    lastName varchar(100), 
    sex varchar(100), 
    birthdate date,
    lastLoginTime timestamp  DEFAULT "0000-00-00 00:00:00"
);
create table User_group(
    group_ID int(11) AUTO_INCREMENT primary key, 
    group_Name varchar(100), 
    description varchar(100)
);
create table Follower(
    account_ID int(11),
    follower_ID int(11)
);
create table Post_Tag(
    tag_Name varchar(100), 
    post_ID int(11)
);
create table User_post(
    post_ID int(11) AUTO_INCREMENT primary key, 
    post_timestamp timestamp DEFAULT CURRENT_TIMESTAMP,
    account_ID int(11),
    message varchar(100), 
    thumbs int(11) DEFAULT 0, 
    is_read int(11) DEFAULT 0,
    parent_ID int(11) DEFAULT 0
);
create table Follow_Tag(
    tag_Name varchar(100),
    account_ID int(11)
);
create table Group_members(
    group_ID int(11),
    account_ID int(11)
);