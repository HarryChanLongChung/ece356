-- a) Which user has written the greatest number of reviews?
select CONCAT(user_id, ": ", name) as user_with_greatest_number_of_reviews from user 
    where review_count = (select max(review_count) from user);

-- (b) Which business has received the greatest number of reviews?
select CONCAT(business_id, ": ", name) as business_receiving_greatest_number_of_reviews from business 
    where review_count = (select max(review_count) from business);

-- (c) What is the average number of reviews written by users?
select (sum(review_count)/count(distinct user_id)) as avg_number_of_reviews from user;

-- (d) The average rating written by a user can be determined in two ways:
--      a. By direct reading from the Users table “average stars” column
--      b. By computing an average of the ratings issued by a user for businesses reviewed
-- For how many users is the difference between these two amounts larger than 0.5?
select count(a.user_id) as users_with_rating_difference from 
    (select distinct user_id, average_stars as direct_avg_stars from user) as a
    inner join 
    (select user_id, avg(stars) as calculated_avg_stars from review group by user_id) as b
    on 
    a.user_id = b.user_id
    where ABS(a.direct_avg_stars - b.calculated_avg_stars) > 0.5;

-- (e) What fraction of users have written more than 10 reviews?
select 
    ((select count(distinct user_id) from user where review_count > 10) / 
    count(distinct user_id)) * 100 as fraction_of_users_have_written_more_than_10_reviews
    from user;

-- (f) What is the average length of their reviews?
select (sum(LENGTH(a.text)) / count(a.review_id)) as average_length_of_user_who_has_more_than_10_review from review as a
inner join (select distinct user_id from user where review_count > 10) as b
on a.user_id = b.user_id;