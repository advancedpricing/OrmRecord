#tag Class
Protected Class OrmPostgreSQLDbAdapterTests
Inherits OrmDatabaseTestsBase
	#tag Event
		Function ReturnAdapter() As OrmDbAdapter
		  return OrmUnitTestHelpers.CreatePostgreSQLDbAdapter
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub EndlessPreparedStatementsTest()
		  //
		  // This is a specific test
		  // Ordinarily disabled
		  //
		  
		  return
		  
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim ps as PreparedSQLStatement
		  
		  dim cnt as integer
		  dim sql as string = "SELECT * FROM person"
		  do
		    ps = adapter.Db.Prepare(sql)
		    call ps.SQLExecute
		    ps = nil
		    
		    cnt = adapter.Count("pg_prepared_statements")
		    
		    if UserCancelled then
		      exit do
		    end if
		  loop
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrimaryKeyTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  
		  dim pk as string = adapter.PrimaryKeyField(kSettingTable)
		  Assert.AreEqual "", pk 
		  
		  pk = adapter.PrimaryKeyField(kPersonTable)
		  Assert.AreEqual "id", pk
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
