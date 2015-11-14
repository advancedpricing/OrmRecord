#tag Class
Protected Class OrmDbAdapterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub DbErrorTest()
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
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
		Sub PrimaryKeyTest()
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  Assert.AreEqual "id", adapter.PrimaryKeyFieldFor(UnitTestHelpers.kPersonTable), "First run"
		  
		  //
		  // Run it again to make sure we get it from the Dictionary too 
		  //
		  Assert.AreEqual "id", adapter.PrimaryKeyFieldFor(UnitTestHelpers.kPersonTable), "Second run"
		  
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
