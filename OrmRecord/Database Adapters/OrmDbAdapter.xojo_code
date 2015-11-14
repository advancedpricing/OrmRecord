#tag Class
Protected Class OrmDbAdapter
	#tag Method, Flags = &h1
		Protected Function BindTypeOf(value As Variant) As Int32
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
		Function Db() As Database
		  return mDb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete(table As String, whereClause As String)
		  if RaiseEvent Delete(table, whereClause) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  #pragma warning "Finish this!!"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetAdapter(db As Database) As OrmDbAdapter
		  dim adapter as OrmDbAdapter
		  
		  select case db
		  case isa PostgreSQLDatabase
		    adapter = new OrmPostgreSQLDbAdapter(PostgreSQLDatabase(db))
		    
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
		Function Insert(table As String, values As Dictionary) As Int64
		  if RaiseEvent Insert(table, values) then
		    RaiseDbException CurrentMethodName
		    return LastInsertId
		  end if
		  
		  dim dictKeys() as variant = values.Keys
		  dim fieldValues() as variant = values.Values
		  dim fields() as string
		  dim placeholders() as string
		  for i as integer = 0 to dictKeys.Ubound
		    dim field as string = dictKeys(i).StringValue
		    fields.Append field
		    placeholders.Append "?"
		  next
		  
		  dim sql as string
		  sql = "INSERT INTO """ + table + """ ( """ + join(fields, """, """) + """ ) VALUES ( " + _
		  join(placeholders, ", ") + " )"
		  SQLExecute sql, fieldValues
		  
		  return RaiseEvent ReturnLastInsertId
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrimaryKeyFieldFor(table As String) As String
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

	#tag Method, Flags = &h1
		Protected Sub RaiseDbException(methodName As String)
		  if Db.Error then
		    raise new OrmRecordException(Db.ErrorMessage, methodName)
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
		  SQLExecute "ROLLBACK TO SAVEPOINT '" + name + "'"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePoint(name As String)
		  SQLExecute "SAVEPOINT '" + name + "'"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql As String, ParamArray params() As Variant)
		  dim ps as PreparedSQLStatement = Db.Prepare(sql)
		  RaiseDbException CurrentMethodName
		  
		  if not (params is nil) and params.Ubound = 0 and params(0).IsArray then
		    params = params(0)
		  end if
		  
		  if not (params is nil) and params.Ubound <> -1 and _
		    not RaiseEvent Bind(ps, params) then
		    raise new OrmDbException("Could not bind values", CurrentMethodName)
		  end if
		  
		  ps.SQLExecute
		  RaiseDbException CurrentMethodName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql As String, ParamArray params() As Variant) As RecordSet
		  dim ps as PreparedSQLStatement = Db.Prepare(sql)
		  RaiseDbException CurrentMethodName
		  
		  if not (params is nil) and params.Ubound = 0 and params(0).IsArray then
		    params = params(0)
		  end if
		   
		  if not (params is nil) and params.Ubound <> -1 and _
		    not RaiseEvent Bind(ps, params) then
		    raise new OrmDbException("Could not bind values", CurrentMethodName)
		  end if
		  
		  dim rs as RecordSet = ps.SQLSelect
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
		Sub UpdateRecord(table As String, primaryKeyField As String, primaryKeyValue As Int64, values As Dictionary)
		  if RaiseEvent UpdateRecord(table, primaryKeyField, primaryKeyValue, values) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  dim fields() as string
		  dim dictKeys() as variant = values.Keys
		  dim fieldValues() as variant = values.Values
		  
		  for i as integer = 0 to dictKeys.Ubound
		    fields.Append dictKeys(i).StringValue
		  next
		  
		  dim sql as string
		  sql = "UPDATE """ + table + """ SET """ + join(fields, """ = ?, """) + """ = ? WHERE """ + _
		  primaryKeyField + """ = " + str(primaryKeyValue)
		  SQLExecute sql, fieldValues
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Delete(table As String, whereClause AS String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Insert(table As String, values As Dictionary) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnBindTypeOfValue(value As Variant) As Int32
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnLastInsertId() As Int64
	#tag EndHook

	#tag Hook, Flags = &h0
		Event UpdateRecord(table As String, primaryKeyField AS String, primaryKeyValue As Int64, values As Dictionary) As Boolean
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return RaiseEvent ReturnLastInsertId
			End Get
		#tag EndGetter
		LastInsertId As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mDb As Database
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  static dict as new Dictionary
			  return dict
			End Get
		#tag EndGetter
		Shared PrimaryKeysDict As Dictionary
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
