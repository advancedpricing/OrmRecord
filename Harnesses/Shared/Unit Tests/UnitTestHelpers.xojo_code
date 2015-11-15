#tag Module
Protected Module UnitTestHelpers
	#tag Method, Flags = &h1
		Protected Function CreateSQLiteDatabase() As SQLiteDatabase
		  dim db as new SQLiteDatabase
		  if not db.Connect then
		    dim err as new RuntimeException
		    err.Message = "Can't connect to SQLiteDatabase"
		    raise err
		  end if
		  
		  db.SQLExecute kCreateSQL
		  RaiseExceptionOnDbError(db)
		  
		  return db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseExceptionOnDbError(db As Database)
		  if db.Error then
		    dim err as new RuntimeException
		    err.Message = db.ErrorMessage
		    raise err
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kCreateSQL, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS person ;\n\nCREATE TABLE \"person\" (\n  \"id\" INTEGER PRIMARY KEY AUTOINCREMENT\x2C \n  \"first_name\" TEXT\x2C \n  \"last_name\" TEXT\n  );\n\nINSERT INTO person\n  (first_name\x2C last_name) VALUES\n  (\'John\'\x2C \'Jones\')\x2C\n  (\'Jack\'\x2C \'Sparrow\')\x2C\n  (\'Kitty\'\x2C \'Hawke\')\x2C\n  (\'Janet\'\x2C \'Jolson\') ;\n\nDROP TABLE IF EXISTS setting ;\n\nCREATE TABLE setting (\n  name TEXT\n  ) ;\n\nINSERT INTO setting\n  (name) VALUES\n  (\'app\')\x2C\n  (\'migration\')\x2C\n  (\'hoorah\') ;", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPersonTable, Type = String, Dynamic = False, Default = \"person", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kSettingTable, Type = String, Dynamic = False, Default = \"setting", Scope = Protected
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
