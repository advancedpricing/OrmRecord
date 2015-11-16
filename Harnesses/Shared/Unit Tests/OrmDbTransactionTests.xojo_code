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
		  
		  if true then
		    dim transaction as new OrmDbTransaction(adapter)
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
		    dim transaction as new OrmDbTransaction(adapter)
		    db.SQLExecute "DELETE FROM " + kPersonTable
		    transaction.Commit
		  end if
		  
		  dim newCount as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual kZero, newCount
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
