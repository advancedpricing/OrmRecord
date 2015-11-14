#tag Class
Protected Class OrmSQLiteDbAdapterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub DeleteRecordTest()
		  const kTable = "person"
		  
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
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM person ORDER BY id DESC LIMIT 1")
		  dim lastId as Int64 = rs.IdxField(1).Int64Value
		  
		  dim insertId as Int64 = adapter.Insert("person", values)
		  Assert.AreEqual lastId + 1, insertId
		  
		  rs = adapter.SQLSelect("SELECT * FROM person WHERE first_name = ? AND last_name = ?", _
		  values.Value("first_name").StringValue, values.Value("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		  for each key as variant in values.Keys
		    Assert.AreSame values.Value(key).StringValue, rs.Field(key.StringValue).StringValue
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecuteTest()
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT COUNT(*) FROM person")
		  dim origCount as integer = rs.IdxField(1).IntegerValue
		  rs = nil
		  
		  adapter.SQLExecute "DELETE FROM person WHERE first_name = ?", "Kitty"
		  rs = db.SQLSelect("SELECT COUNT(*) FROM person")
		  Assert.AreEqual origCount - 1, rs.IdxField(1).IntegerValue
		  rs = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLSelectTest()
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rsDirect as RecordSet = db.SQLSelect("SELECT * FROM person")
		  
		  dim rs as RecordSet = adapter.SQLSelect("SELECT * FROM person")
		  Assert.AreEqual rsDirect.RecordCount, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM person WHERE first_name = ?", "Kitty")
		  Assert.AreEqual 1, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM person WHERE first_name = ? AND last_name = ?", _
		  rsDirect.Field("first_name").StringValue, _
		  rsDirect.Field("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecordTest()
		  const kTable = "person"
		  
		  dim db as SQLiteDatabase = UnitTestHelpers.CreateSQLiteDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kTable + " LIMIT 1")
		  dim id as Int64 = rs.Field("id").Int64Value
		  dim originalValues as Dictionary = OrmHelpers.RecordSetRowToDictionary(rs)
		  rs = nil
		  
		  adapter.UpdateRecord "person", id, values
		  rs = db.SQLSelect("SELECT * FROM " + kTable + " LIMIT 1")
		  Assert.AreEqual id, rs.Field("id").Int64Value
		  Assert.AreEqual values.Value("first_name").StringValue, rs.Field("first_name").StringValue
		  Assert.AreEqual values.Value("last_name").StringValue, rs.Field("last_name").StringValue
		  rs = nil
		End Sub
	#tag EndMethod


End Class
#tag EndClass
