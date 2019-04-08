import mysql.connector

class PyMedia:
  
  def __init__(self):
    self.connect_db()

  def connect_db(self):
    self.dbconnection = mysql.connector.connect(
      host="localhost",
      user="root",
      password="root"
    )
    self.cursor = self.dbconnection.cursor(buffered=True)
    # self.cursor = self.dbconnection.cursor()
    self.cursor.execute("USE ECE356_project;")
  
  def login_or_register(self):
    cmd1 = input("Please input command \"login\" or \"register\": ")
    if cmd1 == "login":
      self.login()
    elif cmd1 == "register":
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
    self.cursor.execute("SELECT count(*) FROM Account where account_Name = \"%s\";" % username)
    valid_username = self.cursor.fetchall()
    if valid_username != [(0,)]:
      print("This username already exist. Please change a new username")
      self.register()
    # else
    password = input("Password: ")
    # register the acount
    self.cursor.execute("INSERT INTO Account ( account_Name, password ) VALUES ( \"%s\", \"%s\" );" % (username, password))
    self.dbconnection.commit()
    
    print("Your account has been registered! Thanks!")
    self.login_or_register()

  def login(self):
    username = input("Username: ")
    password = input("Password: ")
    # check if password is correct
    self.cursor.execute("SELECT count(*) FROM Account where account_Name = \"%s\" and password = \"%s\";" % (username, password))
    validUser = self.cursor.fetchall()
    if validUser != [(0,)]: 
      # user logged in, show posts
      self.show_posts(username)
      self.logged_in(username)
    else:
      print("Sorry, your username or password is wrong.")
      self.login()

  def logged_in(self, username):
    print("Your are logged in. Do something.")
    print("Please enter a command, type \"help\" to see a list of commands.")
    command = input("Command: ")
    if command == "1":
      self.view_posts() # view specific post
    elif command == "2":
      self.upvote() # upvote post
    elif command == "3":
      self.downvote() # downvote post
    elif command == "4":
      self.cursor.execute("SELECT * from User_group") # show all groups
    elif command == "5":
      self.joinGroup(username) # join group
    elif command == "help":
      print('list of commands')
    else:
      self.logged_in(username)
    # else if

  def show_posts(self, username):
    self.cursor.execute("SELECT * FROM User_post inner join Account using (account_ID) where Account.account_Name =\"%s\" " % username)

  def checkValid(self, table, column_id, check_id):
    check_id = int(check_id)
    self.cursor.execute("select count(*) from `%s` where `%s` = %d " % (table, column_id, check_id))
    validCheck = self.cursor.fetchall()
    return validCheck

  def view_posts(self):
    postID = input("Enter the post ID you would like to view: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid postID")
    else:
      self.cursor.execute("select post_ID, message, thumbs, is_read from User_post where \"%s\" = User_post.post_ID;" % postID)
      post_message = self.cursor.fetchall()
      print("Post_ID: ", post_message[0][0])
      print("Message: ", post_message[0][1])
      print("Thumbs: ", post_message[0][2])
      print("Is_read: ", post_message[0][3])

  def upvote(self):
    postID = input("Enter the post ID you would like to upvote: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid postID")
    else:
      self.cursor.execute("UPDATE User_post SET thumbs = thumbs+1 WHERE \"%s\" = User_post.post_ID;" % postID)
      self.dbconnection.commit()

  def downvote(self):
    postID = input("Enter the post ID you would like to downvote: ")
    validPost = self.checkValid("user_post", "post_ID", postID)
    if validPost == [(0,)]:
      print("That is an invalid post ID")
    else:
      self.cursor.execute("UPDATE User_post SET thumbs = thumbs-1 WHERE \"%s\" = User_post.post_ID;" % postID)
      self.dbconnection.commit()

  def joinGroup(self, username):
    groupID = input("Enter the Group ID you would like to join: ")
    validGroup = self.checkValid("user_group", "group_ID", groupID)
    if validGroup == 0:
      print("That is an invalid Group ID")
    else:
      self.cursor.execute("call joinGroup(%s, %s)" % (groupID, username))

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


