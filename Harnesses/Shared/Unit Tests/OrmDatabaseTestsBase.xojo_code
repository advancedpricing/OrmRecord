#tag Class
Protected Class OrmDatabaseTestsBase
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CountTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
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
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kPersonTable + " ORDER BY id ASC")
		  dim id as Int64 = rs.Field("id").Int64Value
		  rs = nil
		  
		  adapter.DeleteRecord kPersonTable, id
		  
		  rs = adapter.SQLSelect("SELECT id FROM " + kPersonTable + " WHERE id = " + adapter.Placeholder(1), id)
		  Assert.IsTrue rs is nil or rs.RecordCount = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FetchPreparedStatements(adapter As OrmDbAdapter)
		  //
		  // Ordinarily don't need this
		  //
		  
		  return
		  
		  if adapter.Db isa PostgreSQLDatabase then
		    
		    dim sql as string = "SELECT * FROM pg_prepared_statements"
		    dim rs as RecordSet = adapter.SQLSelect(sql)
		    
		    while not rs.EOF
		      System.DebugLog "STATEMENT: " + rs.Field("name").StringValue 
		      for i as integer = 1 to rs.FieldCount
		        System.DebugLog "  " + rs.IdxField(i).Name + ": " + rs.IdxField(i).StringValue
		      next
		      
		      rs.MoveNext
		    wend
		    
		    System.DebugLog "====== END STATEMENT ======="
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetAdapter() As OrmDbAdapter
		  return RaiseEvent ReturnAdapter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndexedParamsTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  
		  //
		  // MySQL doesn't do indexed params
		  //
		  if not (adapter isa OrmMySQLDbAdapter or adapter isa OrmMSSQLDbAdapter) then
		    dim sql as string = "SELECT * FROM " + kPersonTable + " WHERE first_name = " + adapter.Placeholder(1) + _
		    " OR last_name = " + adapter.Placeholder(1)
		    dim rs as RecordSet = adapter.SQLSelect(sql, "Jones")
		    Assert.IsFalse rs.EOF, "Expected records not found"
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  values.Value("age") = 130
		  values.Value("some_date") = new OrmDate(2014,1, 12)
		  values.Value("some_time") = new OrmTime(11, 12, 13)
		  values.Value("some_ts") = new OrmTimestamp(2001, 5, 6, 13, 59, 43)
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT id FROM " + kPersonTable + " ORDER BY id DESC")
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
		Sub PreparedStatementTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  
		  dim ps as OrmPreparedStatement = adapter.Prepare( _
		  "SELECT * FROM " + kPersonTable + " WHERE first_name = $1 or last_name = $2 or last_name = $1" _
		  )
		  FetchPreparedStatements adapter
		  
		  dim rs as RecordSet
		  
		  rs = ps.SQLSelect("John", "Jones")
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Ordered array"
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  FetchPreparedStatements adapter
		  
		  rs = ps.SQLSelect("Kitty", "Jones")
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Ordered array 2"
		  if rs isa RecordSet then
		    Assert.AreEqual 2, rs.RecordCount
		  end if
		  FetchPreparedStatements adapter
		  
		  ps.Bind 0, "Kitty"
		  ps.Bind 1, "Jones"
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, ordered"
		  if rs isa RecordSet then
		    Assert.AreEqual 2, rs.RecordCount
		  end if
		  FetchPreparedStatements adapter
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, ordered - reuse last params"
		  if rs isa RecordSet then
		    Assert.AreEqual 2, rs.RecordCount
		  end if
		  
		  ps = adapter.Prepare( _
		  "SELECT * FROM " + kPersonTable + " WHERE first_name = :first or last_name = :last or last_name = :first" _
		  )
		  
		  dim pairs() as pair
		  pairs.Append "first" : "John"
		  pairs.Append "last" : "Jones"
		  
		  rs = ps.SQLSelect(pairs)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  FetchPreparedStatements adapter
		  
		  dim dict as new Dictionary
		  for each p as Pair in pairs
		    dict.Value(p.Left.StringValue) = p.Right
		  next
		  
		  rs = ps.SQLSelect(dict)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  
		  ps.Bind "first", "John"
		  ps.Bind "last", "Jones"
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, named"
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  
		  ps.Bind pairs
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, named, pairs"
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  
		  ps.Bind dict
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, named, dictionary"
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  
		  rs = ps.SQLSelect()
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs, "Bound, named, dictionary - reuse last params"
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount
		  end if
		  
		  ps = nil
		  FetchPreparedStatements adapter
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrepareTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  dim ps as PreparedSQLStatement
		  dim sql() as string
		  
		  sql.Append "SELECT * FROM bad_table"
		  sql.Append "SELECT * FROM person WHERE bad_field = 1"
		  sql.Append "SELECT * FROM bad_table WHERE bad_field = :name"
		  sql.Append "SELECT * FROM person WHERE first_name = :name:"
		  sql.Append "SELECT * FROM person WHERE firs = ?"
		  
		  for each s as string in sql
		    ps = db.Prepare(s)
		    Assert.IsNotNil ps
		    Assert.IsFalse db.Error, s.ToText
		    Assert.Message db.ErrorMessage.ToText
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePointTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
		  dim initialCount as Int64 = adapter.Count(kPersonTable)
		  
		  adapter.StartTransaction
		  adapter.SavePoint("first")
		  
		  dim newCount as Int64
		  
		  if not (adapter isa OrmMSSQLDbAdapter) then
		    adapter.DeleteRecord kPersonTable, 1
		    adapter.SavePoint("after1Delete")
		    
		    adapter.DeleteRecord kPersonTable, 2
		    adapter.SavePoint("after2Deletes")
		    
		    newCount = adapter.Count(kPersonTable)
		    Assert.AreEqual initialCount - 2, newCount
		    
		    adapter.RollbackToSavePoint("after1Delete")
		    newCount = adapter.Count(kPersonTable)
		    Assert.AreEqual initialCount - 1, newCount
		  end if
		  
		  adapter.RollbackToSavePoint("first")
		  newCount = adapter.Count(kPersonTable)
		  Assert.AreEqual initialCount, newCount
		  
		  db.Rollback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecuteTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
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
		  
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
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
		Sub StandardizedSQLTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  
		  dim sql as string = "SELECT * FROM " + kPersonTable + " WHERE last_name = ?"
		  dim params() as variant
		  params.Append "Jones"
		  
		  dim rs as RecordSet
		  
		  rs = adapter.SQLSelect(sql, params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Ordered placeholder"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", "?1"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Indexed placeholder (?1)"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", "$1"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Indexed placeholder ($1)"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", ":a"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Named placeholder (:a)"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", "@a"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Named placeholder (@a)"
		  end if
		  
		  sql = "SELECT * FROM " + kPersonTable + " WHERE last_name = ?1 or first_name = ?2 or first_name = ?1"
		  params.Append "Jenny"
		  
		  rs = adapter.SQLSelect(sql, params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Indexed placeholder out-of-order entries (?1)"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", "$"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Indexed placeholder out-of-order entries ($1)"
		  end if
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", ":"), params)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Named placeholder out-of-order entries (:1)"
		  end if
		  
		  dim pairs() as pair
		  pairs.Append "1" : "Jones"
		  pairs.Append "2" : "Jenny"
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", ":"), pairs)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Named placeholder with pairs (:1)"
		  end if
		  
		  dim d as new Dictionary
		  d.Value("1") = "Jones"
		  d.Value("2") = "Jenny"
		  
		  rs = adapter.SQLSelect(sql.ReplaceAll("?", ":"), d)
		  Assert.Message adapter.SQLOperationMessage
		  Assert.IsNotNil rs
		  if rs isa RecordSet then
		    Assert.AreEqual 1, rs.RecordCount, "Named placeholder with dictionary (:1)"
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TransactionTest()
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
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
		  dim adapter as OrmDbAdapter = GetAdapter
		  dim db as Database = adapter.Db
		  
		  dim values as new Dictionary
		  values.Value("first_name") = "Jerry"
		  values.Value("last_name") = "Lewis"
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + kPersonTable + " ORDER BY id ASC")
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
		Event ReturnAdapter() As OrmDbAdapter
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
