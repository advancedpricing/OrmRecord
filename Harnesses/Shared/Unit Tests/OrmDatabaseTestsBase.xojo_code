#tag Class
Protected Class OrmDatabaseTestsBase
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CountTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kPersonTable)
		  dim expected as Int64 = rs.RecordCount
		  rs = nil
		  
		  dim actual as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual expected, actual
		  
		  rs = db.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE id = 1")
		  expected = rs.RecordCount
		  rs = nil
		  
		  actual = adapter.Count(kPersonTable, "id = " + adapter.Placeholder(1), 1)
		  Assert.AreEqual expected, actual
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecordTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kPersonTable + " LIMIT 1")
		  dim id as Int64 = rs.Field("id").Int64Value
		  rs = nil
		  
		  adapter.DeleteRecord kPersonTable, id
		  
		  rs = adapter.SQLSelect("SELECT id FROM " + kPersonTable + " WHERE id = " + adapter.Placeholder(1), id)
		  Assert.IsTrue rs is nil or rs.RecordCount = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDatabase() As Database
		  return RaiseEvent ReturnDatabase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  values.Value("age") = 130
		  values.Value("some_date") = new OrmDate(2014,1, 12)
		  values.Value("some_time") = new OrmTime(11, 12, 13)
		  values.Value("some_ts") = new OrmTimestamp(2001, 5, 6, 13, 59, 43)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kPersonTable + " ORDER BY id DESC LIMIT 1")
		  dim lastId as Int64 = rs.IdxField(1).Int64Value
		  
		  dim insertId as Int64 = adapter.Insert(kPersonTable, values)
		  Assert.AreEqual lastId + 1, insertId
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE first_name = " + adapter.Placeholder(1) + _
		  " AND last_name = " + adapter.Placeholder(2), _
		  values.Value("first_name").StringValue, values.Value("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		  
		  Assert.AreEqual values.Value("first_name").StringValue, rs.Field("first_name").StringValue
		  Assert.AreEqual values.Value("last_name").StringValue, rs.Field("last_name").StringValue
		  Assert.AreEqual values.Value("age").StringValue, rs.Field("age").StringValue
		  Assert.AreEqual values.Value("some_ts").DateValue.SQLDateTime, rs.Field("some_ts").DateValue.SQLDateTime
		  Assert.AreEqual values.Value("some_date").DateValue.SQLDate, rs.Field("some_date").DateValue.SQLDate
		  Assert.AreEqual values.Value("some_time").StringValue, rs.Field("some_time").StringValue
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePointTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(GetDatabase)
		  
		  dim initialCount as Int64 = adapter.Count(kPersonTable)
		  
		  adapter.StartTransaction
		  adapter.SavePoint("first")
		  
		  adapter.DeleteRecord kPersonTable, 1
		  adapter.SavePoint("after1Delete")
		  
		  adapter.DeleteRecord kPersonTable, 2
		  adapter.SavePoint("after2Deletes")
		  
		  dim newCount as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual initialCount - 2, newCount
		  
		  adapter.RollbackToSavePoint("after1Delete")
		  newCount = adapter.Count(kPersonTable)
		  Assert.AreEqual initialCount - 1, newCount
		  
		  adapter.RollbackToSavePoint("first")
		  newCount = adapter.Count(kPersonTable)
		  Assert.AreEqual initialCount, newCount
		  
		  db.Rollback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecuteTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT COUNT(*) FROM " + kPersonTable)
		  dim origCount as integer = rs.IdxField(1).IntegerValue
		  rs = nil
		  
		  adapter.SQLExecute "DELETE FROM " + kPersonTable + " WHERE first_name = " + adapter.Placeholder(1), "Kitty"
		  rs = db.SQLSelect("SELECT COUNT(*) FROM " + kPersonTable)
		  Assert.AreEqual origCount - 1, rs.IdxField(1).IntegerValue
		  rs = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLSelectTest()
		  const kPersonTable = UnitTestHelpers.kPersonTable
		  
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim rsDirect as RecordSet = db.SQLSelect("SELECT * FROM " + kPersonTable)
		  
		  dim rs as RecordSet = adapter.SQLSelect("SELECT * FROM " + kPersonTable)
		  Assert.AreEqual rsDirect.RecordCount, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE first_name = " + adapter.Placeholder(1), "Kitty")
		  Assert.AreEqual 1, rs.RecordCount
		  
		  rs = adapter.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE first_name = " + adapter.Placeholder(1) + _
		  " AND last_name = " + adapter.Placeholder(2), _
		  rsDirect.Field("first_name").StringValue, _
		  rsDirect.Field("last_name").StringValue)
		  Assert.AreEqual 1, rs.RecordCount
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TransactionTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Joe"
		  values.Value("last_name") = "Dodode"
		  
		  dim cnt as Int64 = adapter.Count(kPersonTable)
		  
		  adapter.StartTransaction
		  dim id as Int64 = adapter.Insert(kPersonTable, values)
		  adapter.Rollback
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE id = " + str(id))
		  Assert.AreEqual 0, rs.RecordCount
		  rs = nil
		  
		  adapter.StartTransaction
		  call adapter.Insert(kPersonTable, values)
		  adapter.Commit
		  
		  dim newCnt as Int64 = adapter.Count(kPersonTable)
		  Assert.AreEqual cnt + 1, newCnt
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecordTest()
		  dim db as Database = GetDatabase
		  dim adapter as OrmDbAdapter = OrmDbAdapter.GetAdapter(db)
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kPersonTable + " LIMIT 1")
		  dim id as Int64 = rs.Field("id").Int64Value
		  rs = nil
		  
		  adapter.UpdateRecord kPersonTable, id, values
		  rs = db.SQLSelect("SELECT * FROM " + kPersonTable + " WHERE id = " + str(id))
		  Assert.AreEqual id, rs.Field("id").Int64Value
		  Assert.AreEqual values.Value("first_name").StringValue, rs.Field("first_name").StringValue
		  Assert.AreEqual values.Value("last_name").StringValue, rs.Field("last_name").StringValue
		  rs = nil
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ReturnDatabase() As Database
	#tag EndHook


	#tag Constant, Name = kPersonTable, Type = String, Dynamic = False, Default = \"person", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kSettingTable, Type = String, Dynamic = False, Default = \"setting", Scope = Protected
	#tag EndConstant


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
