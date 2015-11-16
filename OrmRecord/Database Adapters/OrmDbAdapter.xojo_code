#tag Class
Protected Class OrmDbAdapter
	#tag Method, Flags = &h1
		Protected Function BindType(value As Variant) As Int32
		  return ReturnBindTypeOfValue(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Commit()
		  Db.Commit
		  RaiseDbException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  //
		  // Cannot be instantiated directly
		  //
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count(table As String, whereClause As String = "", ParamArray params() As Variant) As Int64
		  dim sql as string = "SELECT COUNT(*) FROM " + QuoteField(table)
		  
		  whereClause = whereClause.Trim
		  if whereClause <> "" then
		    sql = sql + " WHERE " + whereClause 
		  end if
		  
		  dim rs as RecordSet = SQLSelect(sql, params)
		  return rs.IdxField(1).Int64Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return mDb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(table As String, primaryKeyValue As Int64)
		  if RaiseEvent DeleteRecord(table, primaryKeyValue) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  dim primaryKeyField as string = PrimaryKeyField(table)
		  if primaryKeyField = "" then
		    raise new OrmDbException("No primary key field", CurrentMethodName)
		  end if
		  
		  dim sql as string
		  sql = "DELETE FROM " + QuoteField(table) + " WHERE " + QuoteField(primaryKeyField) + " = " + str(primaryKeyValue)
		  SQLExecute sql
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldSchema(table As String) As RecordSet
		  return Db.FieldSchema(table)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetAdapter(db As Database) As OrmDbAdapter
		  dim adapter as OrmDbAdapter
		  
		  select case db
		  case isa MySQLCommunityServer
		    adapter = new OrmMySQLDbAdapter(MySQLCommunityServer(db))
		    
		  case isa PostgreSQLDatabase
		    adapter = new OrmPostgreSQLDbAdapter(PostgreSQLDatabase(db))
		    
		  case isa SQLiteDatabase
		    adapter = new OrmSQLiteDbAdapter(SQLiteDatabase(db))
		    
		  case else
		    dim err as new RuntimeException
		    err.Message = "Can't locate an appropriate adapter"
		    raise err 
		    
		  end select
		  
		  adapter.mDb = db
		  return adapter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Indexes(table As String) As String()
		  dim result() as string
		  dim rs as RecordSet = Db.IndexSchema(table)
		  while not rs.EOF
		    result.Append rs.IdxField(1).StringValue
		    rs.MoveNext
		  wend
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Insert(table As String, values As Dictionary) As Int64
		  //
		  // Any subclass that overrides this method MUST set mLastInsertId too
		  //
		  
		  mLastInsertId = 0
		  
		  if RaiseEvent Insert(table, values, mLastInsertId) then
		    //
		    // The subclass should set mLastInsertId
		    // (See note below)
		    //
		    
		    RaiseDbException CurrentMethodName
		    return mLastInsertId
		  end if
		  
		  dim dictKeys() as variant = values.Keys
		  dim fieldValues() as variant = values.Values
		  dim fields() as string
		  dim placeholders() as string
		  for i as integer = 0 to dictKeys.Ubound
		    dim field as string = dictKeys(i).StringValue
		    fields.Append QuoteField(field)
		    placeholders.Append Placeholder(i + 1)
		  next
		  
		  dim sql as string
		  sql = "INSERT INTO " + QuoteField(table) + " ( " + join(fields, ", ") + " ) VALUES ( " + _
		  join(placeholders, ", ") + " )"
		  SQLExecute sql, fieldValues
		  
		  //
		  // Ask the subclass for the LastInsertId
		  // Note: If the subclass returns true from the Insert event, 
		  // the following code will never execute so the subclass does
		  // not have to implement ReturnLastInsertId either.
		  // Instead, the subclass should set mLastInsertId directly through
		  // the returnLastInsertId parameter in the Insert event.
		  //
		  mLastInsertId = RaiseEvent ReturnLastInsertId()
		  return mLastInsertId
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastInsertId() As Int64
		  return mLastInsertId
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As Database
		  return Db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Placeholder(index As Integer) As String
		  dim ph as string = RaiseEvent ReturnPlaceholder(index)
		  if ph = "" then
		    ph = "?"
		  end if
		  return ph
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrimaryKeyField(table As String) As String
		  dim primaryKeyField as string = PrimaryKeysDict.Lookup(table, "")
		  
		  if primaryKeyField = "" then
		    dim rs as RecordSet = Db.FieldSchema(table)
		    while not rs.EOF
		      if rs.Field("IsPrimary").BooleanValue then
		        primaryKeyField = rs.Field("ColumnName").StringValue
		        primaryKeysDict.Value(table) = primaryKeyField
		        exit while
		      end if
		      rs.MoveNext
		    wend
		  end if
		  
		  return primaryKeyField
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function QuoteField(fieldName As String) As String
		  const kQuote as string = """"
		  const kDoubledQuotes as string = kQuote + kQuote
		  
		  if fieldName = "" then
		    return ""
		  end if
		  
		  dim result as string = RaiseEvent ReturnQuotedField(fieldName)
		  if result = "" then
		    result = kQuote + fieldName.ReplaceAll(kQuote, kDoubledQuotes) + kQuote
		  end if
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RaiseDbException(methodName As String)
		  if Db.Error then
		    raise new OrmDbException(Db.ErrorMessage, methodName)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReleaseSavePoint(name As String)
		  SQLExecute "RELEASE SAVEPOINT '" + name + "'"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rollback()
		  Db.Rollback
		  RaiseDbException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackToSavePoint(name As String)
		  SQLExecute "ROLLBACK TO SAVEPOINT " + QuoteField(name)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePoint(name As String)
		  SQLExecute "SAVEPOINT " + QuoteField(name)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql As String, ParamArray params() As Variant)
		  if not (params is nil) and params.Ubound = 0 and params(0).IsArray then
		    params = params(0)
		  end if
		  
		  if params is nil or params.Ubound = -1 then
		    //
		    // If there are no parameters, we can do a straight execute
		    //
		    Db.SQLExecute sql
		    
		  else
		    
		    dim ps as PreparedSQLStatement = Db.Prepare(sql)
		    RaiseDbException CurrentMethodName
		    
		    if not RaiseEvent Bind(ps, params) then
		      raise new OrmDbException("Could not bind values", CurrentMethodName)
		    end if
		    
		    ps.SQLExecute
		    
		  end if
		  
		  RaiseDbException CurrentMethodName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql As String, ParamArray params() As Variant) As RecordSet
		  dim rs as RecordSet
		  
		  if not (params is nil) and params.Ubound = 0 and params(0).IsArray then
		    params = params(0)
		  end if
		  
		  if params is nil or params.Ubound = -1 then
		    //
		    // No params we se can just select
		    //
		    rs = Db.SQLSelect(sql)
		    
		  else
		    
		    dim ps as PreparedSQLStatement = Db.Prepare(sql)
		    RaiseDbException CurrentMethodName
		    
		    if not RaiseEvent Bind(ps, params) then
		      raise new OrmDbException("Could not bind values", CurrentMethodName)
		    end if
		    
		    rs = ps.SQLSelect
		    
		  end if
		  
		  RaiseDbException CurrentMethodName
		  
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartTransaction()
		  SQLExecute "START TRANSACTION"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Tables() As String()
		  dim result() as string
		  dim rs as RecordSet = Db.TableSchema
		  while not rs.EOF
		    result.Append rs.IdxField(1).StringValue
		    rs.MoveNext
		  wend
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateRecord(table As String, primaryKeyValue As Int64, values As Dictionary)
		  if RaiseEvent UpdateRecord(table, primaryKeyValue, values) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  dim fields() as string
		  dim dictKeys() as variant = values.Keys
		  dim fieldValues() as variant = values.Values
		  
		  for i as integer = 0 to dictKeys.Ubound
		    fields.Append QuoteField(dictKeys(i).StringValue) + " = " + Placeholder(i + 1)
		  next
		  
		  dim primaryKeyField as string = PrimaryKeyField(table)
		  if primaryKeyField = "" then
		    raise new OrmDbException("No primary key field", CurrentMethodName)
		  end if
		  
		  dim sql as string
		  sql = "UPDATE " + QuoteField(table) + " SET " + join(fields, ", ") + " WHERE " + _
		  QuoteField(primaryKeyField) + " = " + str(primaryKeyValue)
		  SQLExecute sql, fieldValues
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DeleteRecord(table As String, primaryKeyValue As Int64) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Insert(table As String, values As Dictionary, ByRef returnLastInsertId As Int64) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnBindTypeOfValue(value As Variant) As Int32
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnLastInsertId() As Int64
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnPlaceholder(index As Integer) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnQuotedField(fieldName As String) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UpdateRecord(table As String, primaryKeyValue As Int64, values As Dictionary) As Boolean
	#tag EndHook


	#tag Property, Flags = &h1
		Protected mDb As Database
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastInsertId As Int64
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  static dict as new Dictionary
			  return dict
			End Get
		#tag EndGetter
		Protected Shared PrimaryKeysDict As Dictionary
	#tag EndComputedProperty


	#tag ViewBehavior
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
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
