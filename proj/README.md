## Option 2 A Simple Social Network
First, make sure you have a local mysql database running.
In the def connect_db(self) please enter your mysql hostname in the host variable, 
your mysql username in user,
and your mysql password in password.
Now you can run the app.py
After connecting to database:
First register account by typing 'rg' and inputting your username and password
1.  To inital post, use command 'create post' or 'cp'
2.  To create group, use command 'create group' or 'cg'
    To follow group, use command 'follow group' or 'fg'
    To join group, use command 'join group' or 'jg'
3.  To follow topic/tag, use command 'follow tag' or 'ft'
4.  When users login, they can view new posts by their followed users or tags
5.  To thumb up post, use command 'upvote post' or 'up'
    To thumb down post, use command 'downvote post' or 'dp'
    To create a response post, use command 'create response' or 'cr'
Type the 'help' command to see all commands and what they do

## Command list to create a user, follow another tag and see the posts of that tag
After connecting to database:
1. rg
2. username
3. password
4. rg
5. username2
6. password2
7. lg
8. username
9. password
10. n
11. cp
12. post1
13. tag1
14. ft
15. tag1
16. exit
17. "Run app.py again"
18. lg
19. username2
20. password2
21. n
22. cp
23. post2
24. tag1
25. post3
26. tag1
27. post4
28. tag1
29. exit
30. "Run app.py again"
31. lg
32. username
33. password
34. y
Now you should be able to see all the posts from the tag you followed



## Command list to create a user, create some posts and some responses to that post
After connecting to database:
1. rg
2. username
3. password
4. lg
5. username
6. password
7. n
8. cp
9. post1
10. tag1
11. cr
12. 1
13. reply
Now you have replied to the post


## Command list to create a group and join it
After connecting to database:
1. rg
2. username
3. password
4. lg
5. username
6. password
7. n
8. cg
9. group1
10. description
11. jg
12. 1
Now you have joined your group

## Command list to create post, thumb up it and follow its tag
After connecting to database:
1. rg
2. username
3. password
4. lg
5. username
6. password
7. n
8. cp
9. canada
10. canada
11. ft
12. canada
Now you have created a canada post and followed its tag