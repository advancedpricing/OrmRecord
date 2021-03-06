#tag Class
Protected Class OrmDbAdapterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ConvertTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  dim db as SQLiteDatabase = SQLiteDatabase(adapter.Db)
		  
		  dim newDb as Database = adapter.Db
		  Assert.AreSame db, newDb
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DbErrorTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  
		  try
		    #pragma BreakOnExceptions false
		    adapter.SQLExecute "something", 1, 2
		    #pragma BreakOnExceptions default
		    Assert.Fail "Bad SQL should have resulted in exception"
		  catch err as OrmDbException
		    Assert.Pass
		  end try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndexesTest()
		  const kPersonTable = OrmUnitTestHelpers.kPersonTable
		  
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  
		  dim indexes() as string = adapter.Indexes(kPersonTable)
		  Assert.IsTrue indexes.Ubound = 1
		  Assert.IsTrue indexes.IndexOf("idx_person_last_name") <> -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NILedAdapterTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  dim ps as OrmPreparedStatement = adapter.Prepare("SELECT * FROM " + kPersonTable + " WHERE first_name = ?")
		  dim value as string = "Kitty"
		  
		  ps.Bind 0, value
		  
		  dim rs as RecordSet = ps.SQLSelect()
		  Assert.IsNotNil rs
		  Assert.AreEqual value, rs.Field("first_name").StringValue
		  
		  'adapter.Db.Close
		  'rs = ps.SQLSelect()
		  
		  adapter = nil
		  #pragma BreakOnExceptions false
		  try
		    rs = ps.SQLSelect()
		    Assert.Fail "Nil adapter should have failed"
		  catch err as NilObjectException
		    Assert.Pass "Nil adapter failed as expected"
		  end
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrimaryKeyTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  
		  Assert.AreEqual "id", adapter.PrimaryKeyField(OrmUnitTestHelpers.kPersonTable), "First run"
		  
		  //
		  // Run it again to make sure we get it from the Dictionary too 
		  //
		  Assert.AreEqual "id", adapter.PrimaryKeyField(OrmUnitTestHelpers.kPersonTable), "Second run"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLSelectWithArrayTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  
		  dim sql as string = "SELECT * FROM " + kPersonTable + " WHERE last_name = ?"
		  dim params() as variant
		  params.Append "Jones"
		  
		  dim rs as RecordSet = adapter.SQLSelect(sql, params)
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TablesTest()
		  dim adapter as OrmDbAdapter = OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  
		  dim tables() as string = adapter.Tables
		  Assert.IsTrue tables.IndexOf(OrmUnitTestHelpers.kPersonTable) <> -1, """person"" can't be found"
		  Assert.IsTrue tables.IndexOf(OrmUnitTestHelpers.kSettingTable) <> -1, """setting"" can't be found"
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
