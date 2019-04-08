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

def startDB():
  mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="wocao"
  )

  mycursor = mydb.cursor()
  executeScriptsFromFile("./create_database.sql", mycursor)

def login_or_register(cursor):
  cmd1 = input("Please input command \"login\" or \"register\"")
  if cmd1 == "login":
    login(cursor)
  elif cmd1 == "register":
    register(cursor)
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
    logged_in(cursor)
  else:
    print("Sorry, your username or password is wrong.")
    login(cursor)

def register(cursor):
  print("Please choose your username and password.")
  username = input("Username: ")
  # check if username exist
  valid_username = cursor.execute("SELECT count(*) FROM Account where account_Name = %s;", username)
  print(valid_username) # debug
  print(type(valid_username)) # debug
  if valid_username == 0:
    print("This username already exist. Please change a new username")
    register(cursor)
  # else
  password = input("Password: ")
  # register the acount
  cursor.execute("INSERT INTO Account ( account_Name,  ) VALUES ( value1, value2,...valueN );")
  print("Your account has been registered! Thanks!")
  login_or_register(cursor)

def logged_in(cursor):
  print("Your are logged in. Do something.")

def show_posts(cursor, username):
  posts = cursor.execute("SELECT * FROM User_post inner join Account using (account_ID) where Account.account_Name = %s", username);

def funcname(self, parameter_list):
  pass

if __name__ == "__main__":

  mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="wocao"
  )

  cursor = mydb.cursor()

  print("Welcome!")
  login_or_register(cursor)


