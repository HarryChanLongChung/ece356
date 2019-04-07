import mysql.connector

def executeScriptsFromFile(filename, cursor):
    # Open and read the file as a single buffer
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()

    # all SQL commands (split on ';')
    sqlCommands = sqlFile.split(';')

    # Execute every command from the input file
    for command in sqlCommands:
        # This will skip and report errors
        # For example, if the tables do not yet exist, this will skip over
        # the DROP TABLE commands
        try:
            cursor.execute(command)
        except mysql.connector.Error as err:
            print("Command skipped: ", err)

def startDB():
  mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="wocao"
  )

  mycursor = mydb.cursor()
  executeScriptsFromFile("./create_database.sql", mycursor)

def funcname(self, parameter_list):
  pass

if __name__ == "__main__":
  print("Welcome!")
  input("Please input command \"login\" or \"register\"")
  

