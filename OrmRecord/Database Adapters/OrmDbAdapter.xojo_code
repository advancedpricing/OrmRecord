#tag Class
Protected Class OrmDbAdapter
	#tag Method, Flags = &h21
		Private Sub AdjustParamsArray(ByRef values() As Variant)
		  if not (values is nil) and values.Ubound = 0 and values(0).IsArray then
		    dim a as auto = values(0)
		    values = a
		  end if
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

	#tag Method, Flags = &h21
		Private Sub CreateNamedDictionary(map() As RegExMatch, ByRef dict As Dictionary)
		  dict = new Dictionary
		  
		  dim paramIndex as integer = -1
		  
		  for i as integer = 0 to map.Ubound
		    dim match as RegExMatch = map(i)
		    
		    dim ph as string = match.SubExpressionString(0)
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
		  sql = "INSERT INTO " + _
		  QuoteField(table) + _
		  " ( " + _
		  join(fields, ", ") + _
		  " ) VALUES ( " + _
		  join(placeholders, ", ") + _
		  " )"
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

	#tag Method, Flags = &h21
		Private Sub MakeOrderedParams(map() As RegExMatch, dict As Dictionary, params() As Variant)
		  dim added() as string
		  
		  for i as integer = 0 to map.Ubound
		    dim match as RegExMatch = map(i)
		    
		    dim ph as string = match.SubExpressionString(0).Mid(2) // Discard the leading symbol
		    if added.IndexOf(ph) = -1 then
		      params.Append dict.Value(ph)
		      dict.Value(ph) = i // Index of the value in params
		      added.Append ph
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NormalizeSQL(ByRef sql As String, ByRef params() As Variant)
		  //
		  // Analyze the SQL and convert it to whatever the specific db engine needs
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
		  
		  //
		  // The first placeholder will determine if we need to do anything
		  //
		  
		  dim rx as RegEx = MatchPlaceholderRegEx
		  dim match as RegExMatch = rx.Search(sql)
		  while match isa RegExMatch and match.SubExpressionCount = 1
		    match = rx.Search()
		  wend
		  
		  if match is nil then
		    //
		    // No standardized placeholder
		    //
		    SQLOperationMessage = "No placeholders found, sending to the Db engine"
		    return
		  end if
		  
		  const kOrderedType = 3
		  const kIndexedType = 2
		  const kNamedType = 1
		  
		  dim phType as integer = match.SubExpressionCount - 1
		  dim placeholder as string = match.SubExpressionString(0)
		  
		  //
		  // If pair array was provided or it's named with a Dictionary, let's take special action
		  //
		  dim namedDict as Dictionary
		  if params(0) isa Pair then
		    dim orderedValues() as variant
		    PairsToDictionary(params, namedDict, orderedValues)
		    params = orderedValues
		    
		  elseif phType = kNamedType then
		    if params.Ubound = 0 and params(0) isa Dictionary then
		      namedDict = params(0)
		      //
		      // The order is not known so we'll fill it in later
		      //
		      redim params(-1)
		    end if
		    
		  end if
		  
		  //
		  // See if the db accepts this form of placeholder natively
		  //
		  dim okPlaceholder as boolean
		  if phType <> kNamedType or params.Ubound <> -1 then
		    //
		    // There must be params or it means we have to fill in 
		    // the ordered array of values even if
		    // the placeholder is acceptable to the engine
		    //
		    okPlaceholder = IsPlaceholderFormValid(placeholder)
		  end if
		  
		  if okPlaceholder then
		    //
		    // We will just let the db engine handle it
		    //
		    SQLOperationMessage = "Native placeholder used, sending to engine unmodified"
		    return
		  end if
		  
		  //
		  // If we get here, we have to change the sql
		  //
		  
		  //
		  // Build a placeholder map
		  //
		  dim map() as RegExMatch
		  while match isa RegExMatch
		    if match.SubExpressionCount > 1 then
		      map.Append match
		    end if
		    match = rx.Search
		  wend
		  
		  select case phType
		  case kNamedType
		    if namedDict isa Dictionary and params.Ubound = -1 then
		      //
		      // We need to create an ordered array
		      //
		      MakeOrderedParams(map, namedDict, params)
		      
		      //
		      // Now check to see if the placeholder is ok
		      //
		      okPlaceholder = IsPlaceholderFormValid(placeholder)
		      if okPlaceholder then
		        SQLOperationMessage = "Dictionary converted and native placeholder used, sending to engine unmodified"
		        return
		      end if
		      
		    elseif namedDict is nil then
		      CreateNamedDictionary(map, namedDict)
		    end if
		    NormalizeSQLNamed(map, sql, params, namedDict)
		    
		  case kIndexedType
		    NormalizeSQLIndexed(map, sql, params)
		    
		  case kOrderedType
		    NormalizeSQLOrdered(map, sql)
		    
		  end select
		  
		  SQLOperationMessage = "SQL normalized for engine"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NormalizeSQLIndexed(map() As RegExMatch, ByRef sql As String, params() As Variant)
		  #if DebugBuild then
		    dim givenSql as string = sql
		    dim givenParams() as variant = params
		    #pragma unused givenSql
		    #pragma unused givenParams
		  #endif
		  
		  for mapIndex as integer = map.Ubound downto 0
		    dim match as RegExMatch = map(mapIndex)
		    
		    dim ph as string = match.SubExpressionString(0)
		    dim phIndex as integer = ph.Mid(2).Val
		    dim phLenB as integer = ph.LenB
		    dim startB as integer = match.SubExpressionStartB(0)
		    
		    dim newPh as string = Placeholder(phIndex)
		    sql = sql.LeftB(startB) + newPh + sql.MidB(startB + phLenB + 1)
		    
		    //
		    // Make sure the number of params match in case there is no
		    // indexing option (newPh.LenB will be 1)
		    //
		    if newPh.LenB = 1 and phIndex <> mapIndex then
		      if params.Ubound < map.Ubound then
		        redim params(map.Ubound)
		      end if
		      params(mapIndex) = params(phIndex - 1)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NormalizeSQLNamed(map() As RegExMatch, ByRef sql As String, ByRef params() As Variant, valueDict As Dictionary)
		  //
		  // By the time we get here, each entry in the dictionary will hold 
		  // the proper index of the parameter
		  //
		  
		  #if DebugBuild then
		    dim givenSql as string = sql
		    dim givenParams() as variant = params
		    #pragma unused givenSql
		    #pragma unused givenParams
		  #endif
		  
		  for mapIndex as integer = map.Ubound downto 0
		    dim match as RegExMatch = map(mapIndex)
		    
		    dim ph as string = match.SubExpressionString(0)
		    dim phLenB as integer = ph.LenB
		    dim startB as integer = match.SubExpressionStartB(0)
		    
		    dim name as string = ph.Mid(2)
		    dim paramIndex as integer = valueDict.Value(name)
		    dim phIndex as integer = paramIndex + 1
		    
		    dim newPh as string = Placeholder(phIndex)
		    sql = sql.LeftB(startB) + newPh + sql.MidB(startB + phLenB + 1)
		    
		    //
		    // Make sure the number of params match in case there is no
		    // indexing option (newPh.LenB will be 1)
		    //
		    if newPh.LenB = 1 and paramIndex <> mapIndex then
		      if params.Ubound < map.Ubound then
		        redim params(map.Ubound)
		      end if
		      params(mapIndex) = params(paramIndex)
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub NormalizeSQLOrdered(map() As RegExMatch, ByRef sql As String)
		  #if DebugBuild then
		    dim givenSql as string = sql
		    #pragma unused givenSql
		  #endif
		  
		  for mapIndex as integer = map.Ubound downto 0
		    dim match as RegExMatch = map(mapIndex)
		    
		    dim ph as string = match.SubExpressionString(0)
		    dim phLenB as integer = ph.LenB
		    dim startB as integer = match.SubExpressionStartB(0)
		    
		    dim newPh as string = Placeholder(mapIndex + 1)
		    sql = sql.LeftB(startB) + newPh + sql.MidB(startB + phLenB + 1)
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PairsToDictionary(ByRef params() As Variant, ByRef dict As Dictionary, orderedValues() As Variant)
		  dict = new Dictionary
		  redim orderedValues(-1)
		  
		  for i as integer = 0 to params.Ubound
		    dim p as Pair = params(i)
		    dim key as string = p.Left.StringValue
		    dim value as variant = p.Right
		    
		    if key = "" then
		      raise new OrmDbException("No valid name provided in pair", CurrentMethodName)
		    end if
		    
		    dict.Value(key) = i
		    orderedValues.Append value
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
		Function Prepare(sql As String) As OrmPreparedSql
		  dim ps as new OrmPreparedSql(self)
		  ps.SQL = sql
		  return ps
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
		Attributes( hidden )  Sub SQLExecute(prepared As OrmPreparedSql, params() As Variant)
		  dim sql as string = prepared.SQL
		  NormalizeSQL sql, params
		  
		  if prepared.PreparedStatement is nil then
		    //
		    // Needs to be prepared first
		    //
		    
		    dim ps as PreparedSQLStatement
		    SQLExecuteWithSql sql, ps, params
		    
		    prepared.SQL = sql
		    prepared.PreparedStatement = ps
		    
		  else
		    
		    if params is nil or params.Ubound = -1 then
		      //
		      // No params so we can just select
		      //
		      Db.SQLExecute sql
		      
		    else
		      
		      dim ps as PreparedSQLStatement = prepared.PreparedStatement
		      
		      if not RaiseEvent Bind(ps, params) then
		        raise new OrmDbException("Could not bind values", CurrentMethodName)
		      end if
		      
		      ps.SQLExecute
		      
		    end if
		    
		    RaiseDbException CurrentMethodName
		    
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql As String, ParamArray params() As Variant)
		  dim ps as PreparedSQLStatement
		  SQLExecuteWithSql sql, ps, params
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SQLExecuteWithSql(ByRef sql As String, ByRef ps As PreparedSQLStatement, ByRef params() As Variant)
		  NormalizeSQL sql, params
		  
		  if params is nil or params.Ubound = -1 then
		    //
		    // If there are no parameters, we can do a straight execute
		    //
		    Db.SQLExecute sql
		    
		  else
		    
		    ps = Db.Prepare(sql)
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
		Attributes( hidden )  Function SQLSelect(prepared As OrmPreparedSql, params() As Variant) As RecordSet
		  dim sql as string = prepared.SQL
		  NormalizeSQL sql, params
		  
		  if prepared.PreparedStatement is nil then
		    //
		    // Needs to be prepared first
		    //
		    
		    dim ps as PreparedSQLStatement
		    dim rs as RecordSet = SQLSelectWithSql(sql, ps, params)
		    
		    prepared.SQL = sql
		    prepared.PreparedStatement = ps
		    
		    return rs
		    
		  else
		    
		    dim rs as RecordSet
		    
		    if params is nil or params.Ubound = -1 then
		      //
		      // No params so we can just select
		      //
		      rs = Db.SQLSelect(sql)
		      
		    else
		      
		      dim ps as PreparedSQLStatement = prepared.PreparedStatement
		      
		      if not RaiseEvent Bind(ps, params) then
		        raise new OrmDbException("Could not bind values", CurrentMethodName)
		      end if
		      
		      rs = ps.SQLSelect
		      
		    end if
		    
		    RaiseDbException CurrentMethodName
		    
		    return rs
		    
		    
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql As String, ParamArray params() As Variant) As RecordSet
		  dim ps as PreparedSQLStatement
		  dim rs as RecordSet = SQLSelectWithSql(sql,ps, params)
		  return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SQLSelectWithSql(ByRef sql As String, ByRef ps As PreparedSQLStatement, ByRef params() As Variant) As RecordSet
		  NormalizeSQL sql, params
		  
		  dim rs as RecordSet
		  
		  if params is nil or params.Ubound = -1 then
		    //
		    // No params so we can just select
		    //
		    rs = Db.SQLSelect(sql)
		    
		  else
		    
		    ps = Db.Prepare(sql)
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
		Event IsPlaceholderFormValid(placeholder As String) As Boolean
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

	#tag Property, Flags = &h1
		Protected mDb As Database
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastInsertId As Int64
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mMatchPlaceholderRegEx As RegEx
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

	#tag Property, Flags = &h0
		SQLOperationMessage As Text
	#tag EndProperty


	#tag Constant, Name = kMatchPlaceholderPattern, Type = String, Dynamic = False, Default = \"(\?x-U)\n\n(\?:\n  # The first three will match things that should be ignored\n  `[^`]+` |\n  \"[^\"]+\" |\n  \'[^\']+\' |\n  # Just loop past these\n\n  (\?<\x3D^|[[:punct:]\\s]) # Preceded by BOL\x2C punct\x2C or whitespace\n\n  # Match a named entry (\":VVV\" or \"@VVV\")\n  (\?\'named\'[:@]\\w+) |\n\n  # Match an indexed entry (\"\?\\d\" or \"$d\")\n  (\?\'indexed\'[\?$]\\d+) | \n\n  # Match an ordered entry (\"\?\")\n  (\?\'ordered\'\\\?)\n)\n\n# Whatever is matched\x2C punct\x2C whitespace\x2C or eol should come next\n(\?\x3D[[:punct:]\\s]|$)\n\n# If only one of the ignored items is matched\x2C there will be no subgroups\n# Otherwise:\n#  $1 \x3D named\n#  $2 \x3D indexed\n#  $3 \x3D ordered", Scope = Private
	#tag EndConstant


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
