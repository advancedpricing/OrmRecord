#tag Module
Protected Module UnitTestHelpers
	#tag Method, Flags = &h1
		Protected Function CreateMSSQLDbAdapter() As OrmDbAdapter
		  dim db as new MSSQLServerDatabase
		  db.DatabaseName = kUnitTestsDbName
		  db.UserName = kUnitTestsUserName
		  db.Password = kUnitTestsPassword
		  'db.Host = "127.0.0.1\SQLEXPRESS"
		  db.Host = "KEMTEKINAY4D41\SQLEXPRESS"
		  
		  if not db.Connect then
		    RaiseException "Can't connect to MSSQL (are the user, password, and database set up?)"
		  end if
		  
		  for each dbName as string in array(kPersonTable, kSettingTable)
		    db.SQLExecute "DROP TABLE " + dbName
		  next
		  
		  db.SQLExecute kCreateMSSQL
		  RaiseExceptionOnDbError db
		  
		  return new OrmMSSQLDbAdapter(db)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateMySQLDbAdapter() As OrmDbAdapter
		  dim db as new MySQLCommunityServer
		  db.DatabaseName = kUnitTestsDbName
		  db.UserName = kUnitTestsUserName
		  db.Password = kUnitTestsPassword
		  db.Host = "localhost"
		  
		  if not db.Connect then
		    RaiseException "Can't connect to MySQL (are the user, password, and database set up?)"
		  end if
		  
		  db.SQLExecute kCreateMySQL
		  RaiseExceptionOnDbError db
		  
		  return new OrmMySQLDbAdapter(db)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreatePostgreSQLDbAdapter() As OrmDbAdapter
		  dim db as new PostgreSQLDatabase
		  db.DatabaseName = kUnitTestsDbName
		  db.UserName = kUnitTestsUserName
		  db.Password = kUnitTestsPassword
		  db.Host = "localhost"
		  
		  if not db.Connect then
		    RaiseException "Can't connect to PostgreSQL (are the user, password, and database set up?)"
		  end if
		  
		  db.SQLExecute kCreatePostgreSQL
		  RaiseExceptionOnDbError db
		  
		  return new OrmPostgreSQLDbAdapter(db)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CreateSQLiteDbAdapter() As OrmDbAdapter
		  dim db as new SQLiteDatabase
		  if not db.Connect then
		    RaiseException "Can't connect to SQLiteDatabase"
		  end if
		  
		  db.SQLExecute kCreateSQLite
		  RaiseExceptionOnDbError(db)
		  
		  return new OrmSQLiteDbAdapter(db)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseException(msg As String)
		  dim err as new RuntimeException
		  err.Message = msg
		  raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseExceptionOnDbError(db As Database)
		  if db.Error then
		    RaiseException db.ErrorMessage
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCreateMSSQL, Type = String, Dynamic = False, Default = \"CREATE TABLE person (\n  id INTEGER IDENTITY(1\x2C 1) PRIMARY KEY\x2C \n  first_name VARCHAR(100)\x2C \n  last_name VARCHAR(100)\x2C\n  some_date DATE\x2C\n  some_time TIME\x2C\n  some_ts TIMESTAMP\x2C\n  age BIGINT\n  );\n\nCREATE INDEX idx_person_first_name\n  ON person (first_name) ;\n\nCREATE INDEX idx_person_last_name\n  ON person (last_name) ;\n\nINSERT INTO person\n  (first_name\x2C last_name) VALUES\n  (\'John\'\x2C \'Jones\')\x2C\n  (\'Jack\'\x2C \'Sparrow\')\x2C\n  (\'Kitty\'\x2C \'Hawke\')\x2C\n  (\'Janet\'\x2C \'Jolson\') ;\n\nCREATE TABLE setting (\n  name TEXT\n  ) ;\n\nINSERT INTO setting\n  (name) VALUES\n  (\'app\')\x2C\n  (\'migration\')\x2C\n  (\'hoorah\') ;\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateMySQL, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS person ;\n\nCREATE TABLE person (\n  id INTEGER PRIMARY KEY AUTO_INCREMENT\x2C \n  first_name VARCHAR(100)\x2C \n  last_name VARCHAR(100)\x2C\n  some_date DATE\x2C\n  some_time TIME\x2C\n  some_ts TIMESTAMP\x2C\n  age BIGINT\n  );\n\nCREATE INDEX idx_person_first_name\n  ON person (first_name) ;\n\nCREATE INDEX idx_person_last_name\n  ON person (last_name) ;\n\nINSERT INTO person\n  (first_name\x2C last_name) VALUES\n  (\'John\'\x2C \'Jones\')\x2C\n  (\'Jack\'\x2C \'Sparrow\')\x2C\n  (\'Kitty\'\x2C \'Hawke\')\x2C\n  (\'Janet\'\x2C \'Jolson\') ;\n\nDROP TABLE IF EXISTS setting ;\n\nCREATE TABLE setting (\n  name TEXT\n  ) ;\n\nINSERT INTO setting\n  (name) VALUES\n  (\'app\')\x2C\n  (\'migration\')\x2C\n  (\'hoorah\') ;\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreatePostgreSQL, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS person ;\n\nCREATE TABLE person (\n  id SERIAL PRIMARY KEY\x2C \n  first_name VARCHAR(100)\x2C \n  last_name VARCHAR(100)\x2C\n  some_date DATE\x2C\n  some_time TIME\x2C\n  some_ts TIMESTAMP\x2C\n  age BIGINT\n  );\n\nCREATE INDEX idx_person_first_name\n  ON person (first_name) ;\n\nCREATE INDEX idx_person_last_name\n  ON person (last_name) ;\n\nINSERT INTO person\n  (first_name\x2C last_name) VALUES\n  (\'John\'\x2C \'Jones\')\x2C\n  (\'Jack\'\x2C \'Sparrow\')\x2C\n  (\'Kitty\'\x2C \'Hawke\')\x2C\n  (\'Janet\'\x2C \'Jolson\') ;\n\nDROP TABLE IF EXISTS setting ;\n\nCREATE TABLE setting (\n  name TEXT\n  ) ;\n\nINSERT INTO setting\n  (name) VALUES\n  (\'app\')\x2C\n  (\'migration\')\x2C\n  (\'hoorah\') ;\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCreateSQLite, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS person ;\n\nCREATE TABLE person (\n  id INTEGER PRIMARY KEY AUTOINCREMENT\x2C \n  first_name TEXT\x2C \n  last_name TEXT\x2C\n  some_date DATE\x2C\n  some_time TIME\x2C\n  some_ts TIMESTAMP\x2C\n  age INTEGER\n  );\n\nDROP INDEX IF EXISTS idx_person_first_name ;\nDROP INDEX IF EXISTS idx_person_last_name ;\n\nCREATE INDEX idx_person_first_name\n  ON person (first_name) ;\n\nCREATE INDEX idx_person_last_name\n  ON person (last_name) ;\n\nINSERT INTO person\n  (first_name\x2C last_name) VALUES\n  (\'John\'\x2C \'Jones\')\x2C\n  (\'Jack\'\x2C \'Sparrow\')\x2C\n  (\'Kitty\'\x2C \'Hawke\')\x2C\n  (\'Janet\'\x2C \'Jolson\') ;\n\nDROP TABLE IF EXISTS setting ;\n\nCREATE TABLE setting (\n  name TEXT\n  ) ;\n\nINSERT INTO setting\n  (name) VALUES\n  (\'app\')\x2C\n  (\'migration\')\x2C\n  (\'hoorah\') ;\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPersonTable, Type = String, Dynamic = False, Default = \"person", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSettingTable, Type = String, Dynamic = False, Default = \"setting", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kUnitTestsDbName, Type = String, Dynamic = False, Default = \"unittests", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kUnitTestsPassword, Type = String, Dynamic = False, Default = \"unittests", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kUnitTestsUserName, Type = String, Dynamic = False, Default = \"unittests", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
