#tag Class
Protected Class OrmDbTransactionTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub TransactionTest()
		  const kZero as Int64 = 0
		  const kPersonTable = UnitTestHelpers.kPersonTable
		  
		  dim adapter as OrmDbAdapter = UnitTestHelpers.CreateSQLiteDbAdapter
		  dim db as Database = adapter.Db
		  
		  dim intialCount as Int64 = adapter.Count(kPersonTable)
		  
		  //
		  // Create scope
		  //
		  
		  //
		  // Note: Using db.SQLSelect directly since we are only
		  // testing transactions here
		  //
		  
		  if true then
		    dim transaction as new OrmDbTransaction(adapter) // One way to create transactions
		    #pragma unused transaction
		    
		    db.SQLExecute "DELETE FROM " + kPersonTable
		    dim newCount as Int64 = adapter.Count(kPersonTable)
		    Assert.AreEqual kZero, newCount
		  end if
		  
		  Assert.AreEqual intialCount, adapter.Count(kPersonTable), "After rollback"
		  
		  //
		  // Now commit
		  //
		  
		  if true then
		    dim transaction as OrmDbTransaction = adapter.StartTransaction // Other way to create transactions
		    db.SQLExecute "DELETE FROM " + kPersonTable
		    transaction.Commit
		  end if
		  
		  dim newCount as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual kZero, newCount
		  
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
