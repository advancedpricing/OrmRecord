#tag Class
Protected Class OrmDbTransactionTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub TransactionTest()
		  const kZero as Int64 = 0
		  const kPersonTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim intialCount as Int64 = adapter.Count(kPersonTable)
		  
		  //
		  // Create scope
		  //
		  
		  if true then
		    dim transaction as new OrmDbTransaction(db)
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
		    dim transaction as new OrmDbTransaction(db)
		    db.SQLExecute "DELETE FROM " + kPersonTable
		    transaction.Commit
		  end if
		  
		  dim newCount as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual kZero, newCount
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
