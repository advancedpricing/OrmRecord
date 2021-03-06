#tag Class
Class OrmDbAdapter
Implements PoolAdapter
	#tag Method, Flags = &h21
		Private Sub AdjustParamsArray(ByRef values() As Variant)
		  if not (values is nil) and values.Ubound = 0 and values(0).IsArray then
		    dim a as auto = values(0)
		    values = a
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AttachPool(dbPool As OrmDbPool)
		  Pool = dbPool
		End Sub
	#tag EndMethod

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

	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  //
		  // Cannot be instantiated directly
		  //
		  
		  mCreateDate = Xojo.Core.Date.Now
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

	#tag Method, Flags = &h21
		Private Function CreateDate() As Xojo.Core.Date
		  if mCreateDate is nil then
		    //
		    // Better late than never
		    //
		    mCreateDate = Xojo.Core.Date.Now
		  end if
		  
		  return mCreateDate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateNamedDictionary(placeholders() As String, ByRef dict As Dictionary)
		  dict = new Dictionary
		  
		  dim paramIndex as integer = -1
		  
		  for i as integer = 0 to placeholders.Ubound
		    dim ph as string = placeholders(i)
		    dim name as string = ph.Mid(2)
		    
		    if not dict.HasKey(name) then
		      paramIndex = paramIndex + 1
		      dict.Value(name) = paramIndex
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return mDb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord(table As String, primaryKeyValue As Variant)
		  if RaiseEvent DeleteRecord(table, primaryKeyValue) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  dim primaryKeyField as string = PrimaryKeyField(table)
		  if primaryKeyField = "" then
		    raise new OrmDbException("No primary key field", CurrentMethodName)
		  end if
		  
		  dim sql as string
		  sql = "DELETE FROM " + QuoteField(table) + " WHERE " + QuoteField(primaryKeyField) + " = " + Placeholder(1)
		  SQLExecute sql, primaryKeyValue
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  dim p as AdapterPool = Pool
		  if p isa Object then
		    p.Release self
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DetachFromPool()
		  Pool = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldSchema(table As String) As RecordSet
		  return Db.FieldSchema(table)
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
		Function Insert(table As String, values As Dictionary) As Variant
		  //
		  // Any subclass that overrides this method MUST set mLastInsertId too
		  //
		  
		  mLastInsertId = nil
		  
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
		  sql = "INSERT INTO " + _
		  QuoteField(table) + " "
		  
		  if fields.Ubound <> -1 then
		    sql = sql + _
		    " ( " + _
		    join(fields, ", ") + _
		    " ) VALUES ( " + _
		    join(placeholders, ", ") + _
		    " )"
		  else
		    sql = sql + " DEFAULT VALUES"
		  end if
		  
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
		Function LastInsertId() As Variant
		  return mLastInsertId
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MakeOrderedParams(placeholders() As String, dict As Dictionary) As Variant()
		  dim params() as variant
		  redim params(dict.Count - 1)
		  
		  dim added() as string
		  dim paramIndex as integer = -1
		  for i as integer = 0 to placeholders.Ubound
		    dim ph as string = placeholders(i).Mid(2) // Discard the leading symbol
		    if added.IndexOf(ph) = -1 then
		      dim value as variant = dict.Value(ph)
		      paramIndex = paramIndex + 1
		      params(paramIndex) = value
		      added.Append ph
		    end if
		  next
		  
		  return params
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NormalizeSQL(ByRef sql As String, ByRef params() As Variant, prepared As OrmPreparedStatement)
		  //
		  // Analyze the SQL and convert it to whatever the specific db engine needs
		  // If a OrmPreparedStatement is given, use it or store data to it
		  //
		  
		  AdjustParamsArray params
		  
		  #if DebugBuild then
		    dim givenSql as string = sql
		    dim givenParams() as variant = params
		    #pragma unused givenSql
		    #pragma unused givenParams
		  #endif
		  
		  if params is nil or params.Ubound = -1 then
		    //
		    // Nothing to do
		    //
		    SQLOperationMessage = "No params given, processing directly"
		    return
		  end if
		  
		  dim placeholders() as string
		  dim newPhType as OrmPreparedStatement.PlaceholderTypes
		  dim oldPhType as OrmPreparedStatement.PlaceholderTypes
		  dim okPlaceholder as boolean
		  
		  if prepared isa OrmPreparedStatement then
		    
		    if prepared.IsPrepared then
		      placeholders = prepared.Placeholders
		      newPhType = prepared.NewPlaceholderType
		      oldPhType = prepared.OrigPlaceholderType
		      okPlaceholder = prepared.IsOriginalPlaceholderAcceptable
		    else
		      raise new OrmDbException("An OrmPreparedStatement was given without a PreparedSQLStatement attached", CurrentMethodName)
		    end if
		    
		  else
		    
		    okPlaceholder = SwapPlaceholders(sql, placeholders, oldPhType, newPhType)
		    if placeholders.Ubound = -1 then
		      //
		      // No placeholders found
		      //
		      SQLOperationMessage = "No placeholders found, sending to the Db engine"
		      return
		    end if
		  end if
		  
		  //
		  // Massage the params if needed
		  //
		  
		  //
		  // If pair array or Dictionary was provided then let's transfer it into a Dictionary
		  // and adjust the params
		  //
		  dim namedDict as Dictionary
		  if params(0) isa Pair then
		    PairsToDictionary(params, namedDict)
		    dim v() as variant
		    params = v
		  elseif params(0) isa Dictionary then
		    namedDict = Dictionary(params(0))
		    dim v() as variant
		    params = v
		  end if
		  
		  //
		  // Convert any namedDict to an ordered array matching the 
		  // placeholder positions (assumes named indexes
		  //
		  if namedDict isa Dictionary then
		    params = MakeOrderedParams(placeholders, namedDict)
		    SQLOperationMessage = "Params reordered"
		  elseif prepared isa OrmPreparedStatement and prepared.IsPrepared then
		    SQLOperationMessage = "Using already-prepared statement"
		  elseif okPlaceholder then
		    SQLOperationMessage = "SQL sent to Db engine without modification"
		  else
		    SQLOperationMessage = "SQL normalized for engine"
		  end if
		  
		  //
		  // If the new type is ordered and it's different from the 
		  // old type, we have to expand the params
		  //
		  if newPhType = OrmPreparedStatement.PlaceholderTypes.Ordered and newPhType <> oldPhType and params.Ubound < placeholders.Ubound then
		    dim firstIndex as integer = params.Ubound + 1
		    redim params(placeholders.Ubound)
		    
		    for i as integer = placeholders.Ubound downto firstIndex
		      dim ph as string = placeholders(i)
		      dim prevIndex as integer = placeholders.IndexOf(ph)
		      params(i) = params(prevIndex)
		    next
		    
		    SQLOperationMessage = if(SQLOperationMessage = "", "P", SQLOperationMessage + ", p") + "arams expanded"
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PairsToDictionary(ByRef params() As Variant, ByRef dict As Dictionary)
		  dict = new Dictionary
		  
		  for i as integer = 0 to params.Ubound
		    dim p as Pair = params(i)
		    dim key as string = p.Left.StringValue
		    dim value as variant = p.Right
		    
		    if key = "" then
		      raise new OrmDbException("No valid name provided in pair", CurrentMethodName)
		    end if
		    
		    dict.Value(key) = value
		  next
		  
		End Sub
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
		Function Prepare(sql As String) As OrmPreparedStatement
		  dim oldPhType as OrmPreparedStatement.PlaceholderTypes
		  dim newPhType as OrmPreparedStatement.PlaceholderTypes
		  dim placeholders() as string
		  
		  dim newSql as string = sql
		  dim isAcceptable as boolean = SwapPlaceholders(newSql, placeholders, oldPhType, newPhType)
		  
		  dim ps as PreparedSQLStatement = Db.Prepare(newSql)
		  
		  dim prepared as new OrmPreparedStatement(self, ps, sql, placeholders, oldPhType, newPhType, isAcceptable)
		  return prepared
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
		Attributes( hidden )  Sub SQLExecute(prepared As OrmPreparedStatement, params() As Variant)
		  dim sql as string
		  call SQLSelectWithSql sql, params, SelectModes.SQLExecute, prepared
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql As String, ParamArray params() As Variant)
		  call SQLSelectWithSql sql, params, SelectModes.SQLExecute
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function SQLSelect(prepared As OrmPreparedStatement, params() As Variant) As RecordSet
		  dim sql as string
		  return SQLSelectWithSql(sql, params, SelectModes.SQLSelect, prepared)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql As String, ParamArray params() As Variant) As RecordSet
		  dim rs as RecordSet = SQLSelectWithSql(sql, params, SelectModes.SQLSelect)
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SQLSelectWithSql(ByRef sql As String, ByRef params() As Variant, mode As SelectModes, prepared As OrmPreparedStatement = Nil) As RecordSet
		  NormalizeSQL sql, params, prepared
		  
		  dim rs as RecordSet
		  
		  if prepared is nil and (params is nil or params.Ubound = -1) then
		    //
		    // No params so we can just select
		    //
		    select case mode
		    case SelectModes.SQLSelect
		      rs = Db.SQLSelect(sql)
		    case SelectModes.SQLExecute
		      Db.SQLExecute sql
		    case else
		      raise new OrmDbException("Unknown SelectMode", CurrentMethodName)
		    end select
		    
		  else
		    
		    dim ps as PreparedSQLStatement
		    if prepared is nil then
		      ps = Db.Prepare(sql)
		      RaiseDbException CurrentMethodName
		    else
		      ps = prepared.PreparedStatement
		    end if
		    
		    if not RaiseEvent Bind(ps, params) then
		      raise new OrmDbException("Could not bind values", CurrentMethodName)
		    end if
		    
		    select case mode
		    case SelectModes.SQLSelect
		      rs = ps.SQLSelect
		    case SelectModes.SQLExecute
		      ps.SQLExecute
		    case else
		      raise new OrmDbException("Unknown SelectMode", CurrentMethodName)
		    end select
		    
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
		Function StartTransaction() As OrmDbTransaction
		  return new OrmDbTransaction(self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SwapPlaceholders(ByRef sql As String, placeholders() As String, ByRef originalPhType As OrmPreparedStatement.PlaceholderTypes, ByRef newPhType As OrmPreparedStatement.PlaceholderTypes) As Boolean
		  #if DebugBuild then
		    dim givenSql as string = sql
		    dim givenOrigType as OrmPreparedStatement.PlaceholderTypes = originalPhType
		    dim givenNewType as OrmPreparedStatement.PlaceholderTypes = newPhType
		    #pragma unused givenSql
		    #pragma unused givenOrigType
		    #pragma unused givenNewType
		  #endif
		  
		  dim rx as RegEx = MatchPlaceholderRegEx
		  
		  dim map() as RegExMatch 
		  
		  dim match as RegExMatch = rx.Search(sql)
		  while match isa RegExMatch
		    if match.SubExpressionCount > 1 then
		      map.Append match
		      placeholders.Append match.SubExpressionString(0)
		    end if
		    
		    match = rx.Search()
		  wend 
		  
		  if map.Ubound = -1 then
		    //
		    // Nothing do to
		    //
		    return true
		  end if
		  
		  originalPhType = OrmPreparedStatement.PlaceholderTypes(map(0).SubExpressionCount - 1)
		  dim isAcceptable as boolean = IsPlaceholderFormValid(placeholders(0))
		  
		  if isAcceptable then
		    newPhType = originalPhType
		    
		  else
		    //
		    // We have to adjust the SQL
		    //
		    
		    dim newPh as string
		    for mapIndex as integer = map.Ubound downto 0
		      match = map(mapIndex)
		      
		      dim ph as string = placeholders(mapIndex)
		      dim phIndex as integer = if(originalPhType = OrmPreparedStatement.PlaceholderTypes.Ordered, mapIndex + 1, placeholders.IndexOf(ph) + 1)
		      dim phLenB as integer = ph.LenB
		      dim startB as integer = match.SubExpressionStartB(0)
		      
		      newPh = Placeholder(phIndex)
		      sql = sql.LeftB(startB) + newPh + sql.MidB(startB + phLenB + 1)
		    next
		    
		    if newPh.LenB = 1 then
		      newPhType = OrmPreparedStatement.PlaceholderTypes.Ordered
		    else
		      newPhType = OrmPreparedStatement.PlaceholderTypes.Indexed
		    end if
		  end if
		  
		  return isAcceptable
		  
		End Function
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
		Sub UpdateRecord(table As String, primaryKeyValue As Variant, values As Dictionary)
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
		  
		  fieldValues.Append primaryKeyValue
		  
		  dim sql as string
		  sql = "UPDATE " + QuoteField(table) + " SET " + join(fields, ", ") + " WHERE " + _
		  QuoteField(primaryKeyField) + " = " + Placeholder(dictKeys.Ubound + 2)
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
		Event Insert(table As String, values As Dictionary, ByRef returnLastInsertId As Variant) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event IsPlaceholderFormValid(placeholder As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnBindTypeOfValue(value As Variant) As Int32
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnLastInsertId() As Variant
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


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mMatchPlaceholderRegEx is nil then
			    mMatchPlaceholderRegEx = new RegEx
			    mMatchPlaceholderRegEx.SearchPattern = kMatchPlaceholderPattern
			    mMatchPlaceholderRegEx.Options.Greedy = true
			    mMatchPlaceholderRegEx.Options.ReplaceAllMatches = false
			  end if
			  
			  return mMatchPlaceholderRegEx
			End Get
		#tag EndGetter
		Private MatchPlaceholderRegEx As RegEx
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCreateDate As Xojo.Core.Date
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mDb As Database
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastInsertId As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mMatchPlaceholderRegEx As RegEx
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mPoolWR As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mPoolWR is nil then
			    return nil
			  else
			    return AdapterPool(mPoolWR.Value)
			  end if
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    mPoolWR = nil
			  else
			    mPoolWR = new WeakRef(value)
			  end if
			  
			End Set
		#tag EndSetter
		Private Pool As AdapterPool
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  static dict as new Dictionary
			  return dict
			End Get
		#tag EndGetter
		Protected Shared PrimaryKeysDict As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		SQLOperationMessage As Text
	#tag EndProperty


	#tag Constant, Name = kMatchPlaceholderPattern, Type = String, Dynamic = False, Default = \"(\?x-U)\n\n(\?:\n  # The first three will match things that should be ignored\n  `[^`]+` |\n  \"[^\"]+\" |\n  \'[^\']+\' |\n  # Just loop past these\n\n  (\?<\x3D^|[[:punct:]\\s]) # Preceded by BOL\x2C punct\x2C or whitespace\n\n  # Match a named entry (\":VVV\" or \"@VVV\")\n  (\?\'named\'[:@]\\w+) |\n\n  # Match an indexed entry (\"\?\\d\" or \"$d\")\n  (\?\'indexed\'[\?$]\\d+) | \n\n  # Match an ordered entry (\"\?\")\n  (\?\'ordered\'\\\?)\n)\n\n# Whatever is matched\x2C punct\x2C whitespace\x2C or eol should come next\n(\?\x3D[[:punct:]\\s]|$)\n\n# If only one of the ignored items is matched\x2C there will be no subgroups\n# Otherwise:\n#  $1 \x3D named\n#  $2 \x3D indexed\n#  $3 \x3D ordered", Scope = Private
	#tag EndConstant


	#tag Enum, Name = SelectModes, Type = Integer, Flags = &h21
		SQLSelect
		SQLExecute
	#tag EndEnum


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
			Name="SQLOperationMessage"
			Group="Behavior"
			Type="Text"
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
