#TODO

1. initial post (a) DONE
2. initial post with tag (a) DONE
3. add user to a group (b) DONE
4. allow user to search for a group to join (b) DONE
5. allow user to search for a tag to follow (c) -- we can follow but require a showTag()
6. allow user to search for a user to follow (d) DONE
7. user last log-in timestamp (d) 
8. search for new post from followed user when log-in (d)
9. search for new post from followed tag when log-in (d)
10. user response to a post by thump up/down (e) DONE 
11. user response to a post by response post (e) -- create table, 

## George
1. add field in post table, parent_post_ID  DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
2. add showAllTag command DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
3. add addResponsePost command DONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEeeeeeeeeeeeeee

## BB
1. add last_login_timestamp to user table   DONE
2. add unread post right after login        
3. prompt if user want to see new post      



## Option 2 A Simple Social Network
After connecting to database:
First register account by typing 'rg' and inputting your username and password
3.  a)  To inital post, use command 'create post' or 'cp'
    b)  To create group, use command 'create group' or 'cg'
        To follow group, use command 'follow group' or 'fg'
        To join group, use command 'join group' or 'jg'
    c)  To follow topic/tag, use command 'follow tag' or 'ft'
    d)  When users login, they can view new posts by their followed users or tags
    e)  To thumb up post, use command 'upvote post' or 'up'
        To thumb down post, use command 'downvote post' or 'dp'
        To create a response post, use command 'create response' or 'cr'