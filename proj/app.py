import mysql.connector

# util funtions
def executeScriptsFromFile(filename, cursor):
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()
    sqlCommands = sqlFile.split(';')
    for command in sqlCommands:
        try_sql_cmd(cursor, command)

def try_sql_cmd(cursor, cmd):
  try:
      cursor.execute(cmd)
  except mysql.connector.Error as err:
      print("SQL error: ", err)

# def startDB():
#   mydb = mysql.connector.connect(
#     host="localhost",
#     user="root",
#     password="wocao"
#   )

#   mycursor = mydb.cursor()
#   executeScriptsFromFile("./create_database.sql", mycursor)

def login_or_register(cursor):
  cmd1 = input("Please input command \"login\" or \"register\": ")
  if cmd1 == "login":
    login(cursor)
  elif cmd1 == "register":
    register(cursor)
  elif cmd1 == "createDB":
    executeScriptsFromFile("./create_database.sql", cursor)
    login_or_register(cursor)
  else:
    print("Wrong command.")
    login_or_register(cursor)

def login(cursor):
  username = input("Username: ")
  password = input("Password: ")
  # check if password is correct
  validUser = cursor.execute("call loginProcedure(%s, %s, @checkUser)", username, password)
  if validUser: 
    # user logged in, show posts
    show_posts(cursor, username)
    logged_in(cursor, username)
  else:
    print("Sorry, your username or password is wrong.")
    login(cursor)

def register(cursor):
  print("Please choose your username and password.")
  username = input("Username: ")
  # check if username exist
  valid_username = cursor.execute("SELECT count(*) FROM Account where account_Name = \"%s\";" % username)
  if valid_username != None:
    print("This username already exist. Please change a new username")
    register(cursor)
  # else
  password = input("Password: ")
  # register the acount
  # cursor.execute("INSERT INTO Account ( account_Name, password ) VALUES ( \"%s\", \"%s\" );" % (username, password))
  cursor.execute("INSERT INTO Account ( account_Name, password ) VALUES ( \"b\", \"b\" );")
  print("Your account has been registered! Thanks!")
  login_or_register(cursor)

def logged_in(cursor, username):
  print("Your are logged in. Do something.")
  print("Please enter a command, type \"help\" to see a list of commands.")
  command = input("Command: ")
  if command == 1:
    view_post(cursor) # view specific post 
  elif command == 2:
    upvote(cursor) # upvote post
  elif command == 3:
    downvote(cursor) # downvote post
  elif command == 4:
    cursor.execute("SELECT * from User_group") # show all groups
  elif command == 5:
    joinGroup(cursor, username) # join group
  elif command == "help":
    print('list of commands')
  # else if

def show_posts(cursor, username):
  cursor.execute("SELECT * FROM User_post inner join Account using (account_ID) where Account.account_Name = %s" % username)

def view_posts(cursor):
  postID = input("Enter the post ID you would like to view: ")
  validPost = cursor.execute("call checkValidPost(%s, @checkPost)" % postID)
  if validPost == 0:
    print("That is an invalid postID")
  else:
    cursor.execute("call viewPost(%s)", postID)

def upvote(cursor):
  postID = input("Enter the post ID you would like to upvote: ")
  validPost = cursor.execute("call checkValidPost(%s, @checkPost)" % postID)
  if validPost == 0:
    print("That is an invalid postID")
  else:
    cursor.execute("call upvote(%s)", postID)

def downvote(cursor):
  postID = input("Enter the post ID you would like to downvote: ")
  validPost = cursor.execute("call checkValidPost(%s, @checkPost)" % postID)
  if validPost == 0:
    print("That is an invalid post ID")
  else:
    cursor.execute("call downvote(%s)" % postID)

def joinGroup(cursor, username):
  groupID = input("Enter the Group ID you would like to join: ")
  validGroup = cursor.execute("call checkValidGroup(%s, @checkGroup)" % groupID)
  if validGroup == 0:
    print("That is an invalid Group ID")
  else:
    cursor.execute("call joinGroup(%s, %s)" % (groupID, username))

def funcname(self, parameter_list):
  pass

if __name__ == "__main__":

  mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="wocao"
  )
  cursor = mydb.cursor()
  cursor.execute("USE ECE356_project;")

  print("Welcome!")
  login_or_register(cursor)


