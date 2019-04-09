import mysql.connector

class PyMedia:
  
  def __init__(self):
    self.connect_db()

  def connect_db(self):
    self.dbconnection = mysql.connector.connect(
      host="localhost",
      user="root",
      password="wocao"
    )
    self.cursor = self.dbconnection.cursor(buffered=True)
    self.cursor.execute("USE ECE356_project;")
  
  def login_or_register(self):
    cmd1 = input("Please input command 'login' or 'register' (no space): ")
    if cmd1 == "login" or cmd1 == "lg":
      self.login()
    elif cmd1 == "register" or cmd1 == "rg":
      self.register()
    elif cmd1 == "createDB":
      self.executeScriptsFromFile("./create_database.sql")
      self.login_or_register()
    else:
      print("Wrong command.")
      self.login_or_register()

  def register(self):
    print("Please choose your username and password.")
    username = input("Username: ")
    # check if username exist
    self.cursor.execute("SELECT count(*) FROM Account where account_Name = '%s';" % username)
    valid_username = self.cursor.fetchall()
    if valid_username != [(0,)]:
      print("This username already exist. Please change a new username")
      self.register()
    # else
    password = input("Password: ")
    # register the acount
    self.cursor.execute("INSERT INTO Account ( account_Name, password ) VALUES ( '%s', '%s' );" % (username, password))
    self.dbconnection.commit()
    
    print("Your account has been registered! Thanks!")
    self.login_or_register()

  def login(self):
    username = input("Username: ")
    password = input("Password: ")
    # check if password is correct
    self.cursor.execute("SELECT count(*), account_ID FROM Account where account_Name = '%s' and password = '%s';" % (username, password))
    cursor_fetch_result = self.cursor.fetchall()
    if cursor_fetch_result[0][0] != 0: 
      print("Your are logged in!")
      # user logged in, get the autoincrement ID
      user_info = { "id": cursor_fetch_result[0][1], "name": username }
      # show posts
      self.show_posts(username)
      self.logged_in(user_info)
    else:
      print("Sorry, your username or password is wrong.")
      self.login()

  def logged_in(self, user_info):
    
    print("Please enter a command, type 'help' to see a list of commands.")
    command = input("Command: ")
    if command == "view posts" or command == "vp":
      self.view_posts() # view specific post
    elif command == "upvote post" or command == "up":
      self.upvote() # upvote post
    elif command == "downvote post" or command == "dp":
      self.downvote() # downvote post
    elif command == "show all groups" or command == "sag":
      self.cursor.execute("SELECT * from User_group") # show all groups
      show_groups = self.cursor.fetchall()
      print(show_groups)
    elif command == "join group" or command == "jg":
      self.joinGroup(user_info) # join group
    elif command == "create group" or command == "cg":
      self.createGroup() # create group
    elif command == "list of users" or command == "lou":
      self.cursor.execute("SELECT * from Account") # list of all users
      show_users = self.cursor.fetchall()
      print(show_users)
    elif command == "follow user" or command == "fu":
      self.follow_user(user_info) # follow other users
    elif command == "follow tags" or command == "ft":
      self.follow_tag(user_info) # follow tags
    elif command == "create post" or command == "cp":
      self.create_post(user_info) # join group
    elif command == "help":
      print('Avaliable commands: view posts(vp), create post(cp), upvote post(up), downvote post(dp), \
        show all groups(sag), join group(jg), create group(cg), list of users(lou), follow user(fu), \
        follow tags(ft), create post(cp)')
      self.logged_in(user_info)
    else:
      print("Wrong command. Please enter again.")
      self.logged_in(user_info)
    # else if

  def show_posts(self, username):
    self.cursor.execute("SELECT * FROM User_post inner join Account using (account_ID) where Account.account_Name ='%s' " % username)
    self.cursor.fetchall()

  def checkValid(self, table, column_id, check_id):
    check_id = int(check_id)
    self.cursor.execute("select count(*) from `%s` where `%s` = %d " % (table, column_id, check_id))
    validCheck = self.cursor.fetchall()
    return validCheck

  def view_posts(self, user_info):
    postID = input("Enter the post ID you would like to view: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid postID")
    else:
      self.cursor.execute("select post_ID, message, thumbs, is_read from User_post where '%s' = User_post.post_ID;" % postID)
      post_message = self.cursor.fetchall()
      print("Post_ID: ", post_message[0][0])
      print("Message: ", post_message[0][1])
      print("Thumbs: ", post_message[0][2])
      print("Is_read: ", post_message[0][3])
    self.logged_in(user_info)

  def upvote(self, user_info):
    postID = input("Enter the post ID you would like to upvote: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid postID")
    else:
      self.cursor.execute("UPDATE User_post SET thumbs = thumbs+1 WHERE '%s' = User_post.post_ID;" % postID)
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def downvote(self, user_info):
    postID = input("Enter the post ID you would like to downvote: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid post ID")
    else:
      self.cursor.execute("UPDATE User_post SET thumbs = thumbs-1 WHERE '%s' = User_post.post_ID;" % postID)
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def joinGroup(self, user_info):
    groupID = input("Enter the Group ID you would like to join: ")
    validGroup = self.checkValid("user_group", "group_ID", groupID)
    if validGroup == [(0,)]:
      print("That is an invalid Group ID")
    else:
      self.cursor.execute("INSERT INTO Group_members ( group_ID, account_ID ) VALUES ( '%s', '%s' );" % (groupID, user_info["id"]))
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def createGroup(self, user_info):
    groupName = input("Enter the name of the Group you would like to create: ")
    groupDesc = input("Enter a description of your Group: ")
    self.cursor.execute("INSERT INTO User_group ( group_Name, description ) VALUES ( '%s', '%s' );" % (groupName, groupDesc))
    self.dbconnection.commit()
    print("Success!")
    self.logged_in(user_info)

  def follow_user(self, user_info):
    followID = input("Enter the account id of the person you wish to follow: ")
    validUser = self.checkValid("account", "account_ID", followID)
    if validUser == [(0,)]:
      print("That is an invalid user ID")
    else:
      self.cursor.execute("INSERT INTO follower ( account_ID, follower_ID ) VALUES ( '%s', '%s' );" % (followID, user_info["id"]))
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def follow_tag(self, user_info):
    tagID = input("Enter the tag id of the tag you wish to follow: ")
    validtag = self.checkValid("tag", "tag_ID", tagID)
    if validtag == [(0,)]:
      print("That is an invalid tag ID")
    else:
      self.cursor.execute("INSERT INTO FollowTag ( tag_ID, account_ID ) VALUES ( '%s', '%s' );" % (tagID, user_info["id"]))
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def unfollow_user(self, user_info):
    followID = input("Enter the account id of the person you wish to unfollow: ")
    validUser = self.checkValid("account", "account_ID", followID)
    followID = int(followID)
    user_ID = int(user_info["id"])
    self.cursor.execute("select count(*) from follower where follower.account_ID = %d and follower.follower_ID = %d" % (followID, user_ID))
    validFollow = self.cursor.fetchall()
    if validUser == [(0,)]:
      print("That is an invalid user ID")
    elif validFollow == [(0,)]:
      print("You are not followed to them")
    else:
      self.cursor.execute("DELETE FROM follower where follower.account_ID = %d and follower.follower_ID = %d;" % (followID, user_ID))
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def unfollow_tag(self, user_info):
    tagID = input("Enter the tag id of the tag you wish to unfollow: ")
    validTag = self.checkValid("tag", "tag_ID", tagID)
    tagID = int(tagID)
    user_ID = int(user_info["id"])
    self.cursor.execute("select count(*) from followerTag where followerTag.tag_ID = %d and followerTag.account_ID = %d" % (tagID, user_ID))
    validFollow = self.cursor.fetchall()
    if validTag == [(0,)]:
      print("That is an invalid tag ID")
    elif validFollow == [(0,)]:
      print("You are not followed to this tag")
    else:
      self.cursor.execute("DELETE FROM followerTag where follower.tag_ID = %d and follower.account_ID = %d;" % (tagID, user_ID))
      self.dbconnection.commit()
      print("Success!")
    self.logged_in(user_info)

  def create_post(self, user_info):
    post_content = input("What content would you like to post? ")
    create_post_query = "insert into User_post(account_ID, message, thumbs, is_read) values (%s, '%s', %s, %s);"
    create_post_query = create_post_query % (user_info["id"], post_content, 0, 0)
    self.cursor.execute(create_post_query)
    post_id = self.cursor.lastrowid

    post_tags = input("What tags do you want to put? Seperate your tags with space. ")
    post_tags = post_tags.split()
    for post_tag in post_tags:
      create_tag_query = "insert into Tag(tag_name, post_ID) values ('%s', %s);"
      create_tag_query = create_tag_query % (post_tag, post_id)
      self.cursor.execute(create_tag_query)

    self.dbconnection.commit()
    print("You have successfully created a post!")
    self.logged_in(user_info)

  # util funtions
  def executeScriptsFromFile(self, filename):
      fd = open(filename, 'r')
      sqlFile = fd.read()
      fd.close()
      sqlCommands = sqlFile.split(';')
      for command in sqlCommands:
          self.try_sql_cmd(command)

  def try_sql_cmd(self, cmd):
    try:
        self.cursor.execute(cmd)
    except mysql.connector.Error as err:
        print("SQL error: ", err)
  
  def start_app(self):
    self.connect_db()
    print("Welcome!")
    self.login_or_register()
    

# main method
if __name__ == "__main__":
  app = PyMedia()
  app.start_app()


