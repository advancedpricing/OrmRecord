#tag Class
Protected Class OrmSQLiteDbAdapterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CountTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kTable)
		  dim expected as Int64 = rs.RecordCount
		  rs = nil
		  
		  dim actual as Int64 = adapter.Count(kTable)
		  Assert.AreEqual expected, actual
		  
		  rs = db.SQLSelect("SELECT * FROM " + kTable + " WHERE id = 1")
		  expected = rs.RecordCount
		  rs = nil
		  
		  actual = adapter.Count(kTable, "id = ?", 1)
		  Assert.AreEqual expected, actual
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecordTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kTable + " LIMIT 1")
		  dim id as Int64 = rs.Field("id").Int64Value
		  rs = nil
		  
		  adapter.DeleteRecord kTable, id
		  
		  rs = adapter.SQLSelect("SELECT id FROM " + kTable + " WHERE id = ?", id)
		  Assert.IsTrue rs is nil or rs.RecordCount = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kTable + " ORDER BY id DESC LIMIT 1")
		  dim lastId as Int64 = rs.IdxField(1).Int64Value
		  
		  dim insertId as Int64 = adapter.Insert(kTable, values)
		  Assert.AreEqual lastId + 1, insertId
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kTable + " WHERE first_name = ? AND last_name = ?", _
		  values.Value("first_name").StringValue, values.Value("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		  for each key as variant in values.Keys
		    Assert.AreSame values.Value(key).StringValue, rs.Field(key.StringValue).StringValue
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePointTest()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecuteTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT COUNT(*) FROM " + kTable)
		  dim origCount as integer = rs.IdxField(1).IntegerValue
		  rs = nil
		  
		  adapter.SQLExecute "DELETE FROM " + kTable + " WHERE first_name = ?", "Kitty"
		  rs = db.SQLSelect("SELECT COUNT(*) FROM " + kTable)
		  Assert.AreEqual origCount - 1, rs.IdxField(1).IntegerValue
		  rs = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLSelectTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rsDirect as RecordSet = db.SQLSelect("SELECT * FROM " + kTable)
		  
		  dim rs as RecordSet = adapter.SQLSelect("SELECT * FROM " + kTable)
		  Assert.AreEqual rsDirect.RecordCount, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kTable + " WHERE first_name = ?", "Kitty")
		  Assert.AreEqual 1, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kTable + " WHERE first_name = ? AND last_name = ?", _
		  rsDirect.Field("first_name").StringValue, _
		  rsDirect.Field("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TransactionTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Joe"
		  values.Value("last_name") = "Dodode"
		  
		  dim cnt as Int64 = adapter.Count(kTable)
		  
		  adapter.StartTransaction
		  dim id as Int64 = adapter.Insert(ktable, values)
		  adapter.Rollback
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kTable + " WHERE id = " + str(id))
		  Assert.AreEqual 0, rs.RecordCount
		  rs = nil
		  
		  adapter.StartTransaction
		  call adapter.Insert(ktable, values)
		  adapter.Commit
		  
		  dim newCnt as Int64 = adapter.Count(kTable)
		  Assert.AreEqual cnt + 1, newCnt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecordTest()
		  const kTable = UnitTestHelpers.kPersonTable
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kTable + " LIMIT 1")
		  dim id as Int64 = rs.Field("id").Int64Value
		  rs = nil
		  
		  adapter.UpdateRecord kTable, id, values
		  rs = db.SQLSelect("SELECT * FROM " + kTable + " LIMIT 1")
		  Assert.AreEqual id, rs.Field("id").Int64Value
		  Assert.AreEqual values.Value("first_name").StringValue, rs.Field("first_name").StringValue
		  Assert.AreEqual values.Value("last_name").StringValue, rs.Field("last_name").StringValue
		  rs = nil
		End Sub
	#tag EndMethod


End Class
#tag EndClass
