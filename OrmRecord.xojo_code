#tag Class
Protected Class OrmRecord
	#tag Method, Flags = &h21
		Private Shared Sub AddInstance(instance As OrmRecord)
		  // Keeps a Instance registry for notifications
		  // (and maybe other uses in the future)
		  // Will only be added in the Constructor
		  
		  //
		  // Keep the instances as an array of WeakRefs
		  // The GetInstances method will clear out defunct references
		  //
		  // The key is the table name since that can't change
		  //
		  
		  dim key as variant = instance.DatabaseTableName
		  
		  dim arr() as WeakRef
		  if InstancesDict.HasKey(key) then
		    arr = InstancesDict.Value(key)
		  else
		    InstancesDict.Value(key) = arr
		  end if
		  
		  arr.Append new WeakRef(instance)
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Clone(asNew As Boolean = False) As OrmRecord
		  dim ti as Introspection.TypeInfo = Introspection.GetType(Self)
		  dim o as OrmRecord
		  
		  dim md as OrmTableMeta = GetTableMeta(ti)
		  o = md.ConstructorZero.Invoke
		  
		  if not asNew then
		    o.Id = self.Id
		  end if
		  
		  o.CopyFrom(self)
		  
		  return o
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Dim ti As Introspection.TypeInfo = Introspection.GetType(Self)
		  Dim className As String = ti.FullName
		  OrmMyMeta = OrmMetaCache.Lookup(className, Nil)
		  
		  If OrmMyMeta Is Nil Then
		    //
		    // Create and cache our OrmTableMeta data
		    //
		    
		    OrmMyMeta = New OrmTableMeta
		    OrmMetaCache.Value(className) = OrmMyMeta
		    
		    OrmMyMeta.FullClassName = ti.FullName
		    
		    //
		    // Find our zero parameter constructor
		    //
		    
		    OrmMyMeta.ConstructorZero = OrmHelpers.GetConstructor(ti)
		    OrmMyMeta.ConstructorRs = OrmHelpers.GetConstructor(ti, "RecordSet")
		    
		    //
		    // Get our table name
		    //
		    
		    OrmMyMeta.TableName = RaiseEvent DatabaseTableName
		    If OrmMyMeta.TableName = "" Then
		      OrmMyMeta.TableName = className.CamelToUnder
		    End If
		    
		    //
		    // Get our default order by
		    //
		    OrmMyMeta.DefaultOrderBy = RaiseEvent DefaultOrderBy
		    
		    //
		    // Process our public, readable and writable, non-ignored fields
		    //
		    
		    Dim selectFields() As String
		    Dim assignments() As String
		    
		    dim paramNumber as Integer = 1
		    dim props() as Introspection.PropertyInfo = ti.GetProperties
		    for i as Integer = 0 to props.Ubound
		      dim prop as Introspection.PropertyInfo = props(i)
		      
		      If prop.IsShared or Not prop.IsPublic Or Not prop.CanRead Or Not prop.CanWrite Or OrmShouldSkip(prop.Name) Then
		        Continue For i
		      End If
		      
		      Dim fm As New OrmFieldMeta
		      fm.Prop = prop
		      fm.FieldName = DatabaseFieldNameFor(prop.Name)
		      fm.Converter = FieldConverterFor(prop.Name)
		      
		      If fm.FieldName = "" Then
		        fm.FieldName = prop.Name
		      End If
		      
		      OrmMyMeta.Fields.Append fm
		      selectFields.Append fm.FieldName
		      
		      dim thisParam as String = "$" + Str(paramNumber)
		      assignments.Append fm.FieldName + "=" + thisParam
		      
		      paramNumber = paramNumber + 1
		    Next
		    
		    OrmMyMeta.IdSequenceKey = OrmMyMeta.TableName + "_id_seq"
		    OrmMyMeta.BaseSelectSQL = "SELECT " + Join(selectFields, ",") + " FROM " + OrmMyMeta.TableName
		    OrmMyMeta.DeleteSQL = "DELETE FROM " + OrmMyMeta.TableName + " WHERE id="
		  End If
		  
		  AddInstance self
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(db as Database, id As Integer)
		  Self.Constructor
		  
		  if db is nil then
		    db = GetDb(DatabaseIdentifier)
		  end if
		  
		  Dim rs As RecordSet = db.SQLSelect(OrmMyMeta.BaseSelectSQL + " WHERE id=" + Str(id) + " LIMIT 1")
		  
		  If db.Error Then
		    Raise New OrmRecordException("Could not load object from " + _
		    OrmMyMeta.TableName + " by id " + Str(Id) + db.ErrorMessage, CurrentMethodName)
		  End If
		  
		  If rs.EOF Then
		    Raise New OrmRecordNotFoundException(OrmMyMeta.TableName, id, CurrentMethodName)
		  End If
		  
		  FromRecordSet(rs)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(id As Integer)
		  Self.Constructor(nil, id)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(other as OrmRecord, asNew as Boolean = False)
		  Self.Constructor
		  
		  if not (other is nil) then
		    Self.CopyFrom(other)
		    
		    if asNew = False then
		      Id = other.Id
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(rs As RecordSet)
		  Self.Constructor
		  
		  If rs Is Nil Or rs.EOF Then
		    Raise New OrmRecordNotFoundException(OrmMyMeta.TableName, -1, CurrentMethodName)
		  End If
		  
		  FromRecordSet(rs)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function CopyArray(inArr() As OrmRecord) As OrmRecord()
		  dim result() as OrmRecord
		  redim result(inArr.Ubound)
		  
		  for i as integer = 0 to inArr.Ubound
		    result(i) = inArr(i)
		  next
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyFrom(fromRecord As OrmRecord, includingId as Boolean = False)
		  // Copies the data from an identical object or its common super subclass
		  
		  dim tiMine as Introspection.TypeInfo = Introspection.GetType(self)
		  dim tiTheirs as Introspection.TypeInfo = Introspection.GetType(fromRecord)
		  
		  //
		  // Find the common super
		  //
		  do
		    if tiMine.FullName = tiTheirs.FullName or tiTheirs.IsSubclassOf(tiMine) then
		      exit do
		    end if
		    
		    //
		    // No? Work up the chain
		    //
		    tiMine = tiMine.BaseType
		  loop
		  
		  static tiOrm as Introspection.TypeInfo = GetTypeInfo(OrmRecord)
		  static ormName as string = tiOrm.FullName
		  if tiMine.FullName = ormName then
		    raise new OrmRecordException("Can only copy values from the records that share a super class", CurrentMethodName)
		  end if
		  
		  dim md as OrmTableMeta = GetTableMeta(tiMine)
		  for each f as OrmFieldMeta in md.Fields
		    if includingId or f.Prop.Name <> "Id" then
		      f.Prop.Value(self) = f.Prop.Value(fromRecord)
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Count(db as Database, ti as Introspection.TypeInfo, where as String = "", ParamArray params() as Variant) As Integer
		  const kRecordCount = "record_count"
		  
		  dim md as OrmTableMeta = GetTableMeta(ti)
		  
		  if db is Nil then
		    dim o as OrmRecord = OrmRecord(md.ConstructorZero.Invoke)
		    db = GetDb(o.DatabaseIdentifier)
		  end if
		  
		  if where <> "" then
		    where = " WHERE " + where
		  end if
		  
		  dim sql as String = "SELECT COUNT(*) AS " + kRecordCount + " FROM " + md.TableName + where
		  dim ps as PreparedSQLStatement = db.Prepare(sql)
		  
		  if params <> Nil then
		    for i as Integer = 0 to params.Ubound
		      ps.Bind(i, params(i))
		    next
		  end if
		  
		  dim rs as RecordSet = ps.SQLSelect
		  if db.error then
		    raise new OrmRecordException(db, CurrentMethodName)
		  end if
		  
		  dim recordCount as Integer
		  if not rs.EOF then
		    recordCount = rs.Field(kRecordCount).IntegerValue
		  end if
		  
		  rs.Close
		  
		  return recordCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function DatabaseTableNameFor(ormRecordTypeInfo As Introspection.TypeInfo) As String
		  dim meta as OrmTableMeta = GetTableMeta(ormRecordTypeInfo)
		  return meta.TableName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete(db As Database = Nil)
		  If db Is Nil Then
		    db = GetDb(DatabaseIdentifier)
		  End If
		  
		  If BeforeDelete(db) Or Self.IsNew Then
		    Return
		  End If
		  
		  db.SQLExecute(OrmMyMeta.DeleteSQL + Str(Id))
		  
		  If db.Error Then
		    Raise New OrmRecordException("Could not remove " + OrmMyMeta.TableName + " #" + Str(id) + _
		    db.ErrorMessage, CurrentMethodName)
		  End If
		  
		  Self.Id = NewID
		  
		  RaiseEvent AfterDelete(db)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DoAfterSave(db As Database)
		  RaiseEvent AfterSave(db)
		  
		  Notify nil, NotificationType.ObjectSaved
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExtractTableNameFieldName(field As String) As Pair
		  Dim parts() As String = field.Split(".")
		  
		  If parts.Ubound = -1 Or parts.Ubound > 1 Then // Too many parts
		    Raise New OrmRecordException("Could not extract table name and field name from " + field, CurrentMethodName)
		  End If
		  
		  Dim tableName As String
		  Dim fieldName As String
		  If parts.Ubound = 0 Then
		    tableName = OrmMyMeta.TableName
		    fieldName = parts(0).Trim
		  Else
		    tableName = parts(0).Trim
		    fieldName = parts(1).Trim
		  End If
		  
		  Return New Pair(tableName, fieldName)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FromDictionary(values As Dictionary, failOnInvalid As Boolean = True)
		  IsLoading = True
		  
		  //
		  // Create a Dictionary of valid props by name
		  //
		  
		  Dim propsDict As New Dictionary
		  
		  For Each p As OrmFieldMeta In OrmMyMeta.Fields
		    propsDict.Value(p.Prop.Name) = p
		  Next
		  
		  //
		  // Compare the Dictionary to the prop names
		  // but only if failOnInvalid
		  //
		  
		  If failOnInvalid Then
		    For Each k As Variant In values.Keys
		      If Not propsDict.HasKey(k) Then
		        IsLoading = False
		        
		        Raise New OrmRecordException("The given property '" + k + "' is not valid for this object", CurrentMethodName)
		      End If
		    Next
		  End If
		  
		  //
		  // Cycle through the given Dictionary
		  //
		  
		  For Each k As String In values.Keys
		    Dim p As OrmFieldMeta = propsDict.Lookup(k, Nil)
		    If p <> Nil Then
		      p.Prop.Value(Self) = values.Value(k)
		    End If
		  Next
		  
		  IsLoading = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub FromRecordSet(rs As RecordSet)
		  IsLoading = True
		  
		  If BeforePopulate Then
		    IsLoading = False
		    
		    Return
		  End If
		  
		  For Each clsField As OrmFieldMeta In OrmMyMeta.Fields
		    Dim prop As Introspection.PropertyInfo = clsField.Prop
		    Dim cvt As OrmBaseConverter = clsField.Converter
		    Dim dbField As DatabaseField = rs.Field(clsField.FieldName)
		    
		    If cvt Is Nil Then
		      dim pt as String = prop.PropertyType.FullName
		      
		      select case pt
		      case "Date"
		        prop.Value(Self) = dbField.DateValue
		        
		      case else
		        prop.Value(Self) = dbField.Value
		      end select
		    Else
		      prop.Value(Self) = cvt.FromDatabase(dbField.Value, Self)
		    End If
		  Next
		  
		  AfterPopulate
		  
		  IsLoading = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Get(db As Database, ti As Introspection.TypeInfo, clause As String, ParamArray params() As Variant) As OrmRecord
		  Dim md As OrmTableMeta = GetTableMeta(ti)
		  
		  If db Is Nil Then
		    dim o as OrmRecord = OrmRecord(md.ConstructorZero.Invoke)
		    db = GetDb(o.DatabaseIdentifier)
		  End If
		  
		  Dim sql As String = md.BaseSelectSQL + " WHERE " + clause
		  Dim ps As PreparedSQLStatement = db.Prepare(sql)
		  If db.Error Then
		    Raise New OrmRecordException(db, CurrentMethodName)
		  End If
		  
		  For i As Integer = 0 To params.Ubound
		    ps.Bind(i, params(i))
		  Next
		  
		  Dim rs As RecordSet = ps.SQLSelect
		  If db.Error Then
		    Raise New OrmRecordException(db, CurrentMethodName)
		  End If
		  
		  Dim cParams() As Variant
		  cParams.Append rs
		  
		  Dim o As OrmRecord
		  
		  if rs.EOF then
		    dim ex as OrmRecordNotFoundException
		    ex = new OrmRecordNotFoundException(_
		    "Could not find " + ti.Name + " based on given where clause", CurrentMethodName)
		    ex.SQL = sql
		    raise ex
		  end if
		  
		  If Not rs.EOF Then
		    o = md.ConstructorRs.Invoke(cParams)
		  End If
		  
		  rs.Close
		  
		  Return o
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetDb(key As String = "", newConnection As Boolean = False) As Database
		  dim context as Auto
		  
		  if key <> "" or newConnection then
		    context = key : newConnection
		  end if
		  
		  return DatabaseProvider.GetDatabase(context)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetInstances(dbIdentifier As String, tableName As String, id As Integer) As OrmRecord()
		  dim instances() as OrmRecord
		  
		  dim key as Variant = tableName
		  
		  if InstancesDict.HasKey(key) then
		    
		    dim arr() as WeakRef = InstancesDict.Value(key)
		    for i as integer = arr.Ubound downto 0
		      dim wr as WeakRef = arr(i)
		      dim orm as OrmRecord = if(wr IsA WeakRef, OrmRecord(wr.Value), nil)
		      
		      if orm is nil then
		        arr.Remove i
		      else
		        //
		        // Make sure this instance is for the same database
		        //
		        if orm.DatabaseIdentifier = dbIdentifier and orm.Id = id then
		          instances.Append orm
		        end if
		        
		      end if
		    next
		    
		  end if
		  
		  return instances
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetMany(db As Database, ti As Introspection.TypeInfo, clause As String = "", ParamArray params() As Variant) As OrmRecord()
		  dim meta as OrmTableMeta = GetTableMeta(ti)
		  return GetManyInternal(db, ti, meta.DefaultOrderBy, 0, 0, clause, params)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetManyInternal(db as Database, ti as Introspection.TypeInfo, orderBy as String, offset as Integer, limit as Integer, where as String, params() as Variant) As OrmRecord()
		  //
		  // If params(0) is an array, compensate
		  // It means the caller used GetMany(..., Array(param1, param2)
		  //
		  if not (params is nil) and params.Ubound = 0 and params(0).IsArray then
		    params = params(0)
		  end if
		  
		  dim md as OrmTableMeta = GetTableMeta(ti)
		  
		  If db Is Nil Then
		    dim o as OrmRecord = OrmRecord(md.ConstructorZero.Invoke)
		    db = o.GetDb(o.DatabaseIdentifier)
		  End If
		  
		  dim statementParts() as String = Array(md.BaseSelectSQL)
		  
		  if where <> "" then
		    statementParts.Append "WHERE " + where
		  end if
		  
		  if orderBy <> "" then
		    statementParts.Append "ORDER BY " + orderBy
		  end if
		  
		  if limit > 0 then
		    statementParts.Append "LIMIT " + Str(limit)
		  end if
		  
		  if offset > 0 then
		    statementParts.Append "OFFSET " + Str(offset)
		  end if
		  
		  dim sql as String = Join(statementParts, " ")
		  dim ps as PreparedSQLStatement = db.Prepare(sql)
		  
		  if not (params is nil) then
		    for i as Integer = 0 to params.Ubound
		      ps.Bind(i, params(i))
		    next
		  end if
		  
		  dim rs as RecordSet = ps.SQLSelect
		  if db.error then
		    raise new OrmRecordException(db, CurrentMethodName)
		  end if
		  
		  dim cParams() as Variant
		  cParams.Append rs
		  
		  dim records() as OrmRecord
		  
		  while not rs.EOF
		    records.Append md.ConstructorRs.Invoke(cParams)
		    rs.MoveNext
		  wend
		  
		  rs.Close
		  
		  return records
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetManyLimited(db as Database, ti as Introspection.TypeInfo, offset as Integer, limit as Integer, where as String = "", ParamArray params() as Variant) As OrmRecord()
		  return GetManyInternal(db, ti, "", offset, limit, where, params)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetManyOrdered(db as Database, ti as Introspection.TypeInfo, orderBy as String, where as String = "", ParamArray params() as Variant) As OrmRecord()
		  return GetManyInternal(db, ti, orderBy, 0, 0, where, params)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetManyOrderedAndLimited(db as Database, ti as Introspection.TypeInfo, orderBy as String, offset as Integer, limit as Integer, where as String = "", ParamArray params() as Variant) As OrmRecord()
		  return GetManyInternal(db, ti, orderBy, offset, limit, where, params)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetTableMeta(ti as Introspection.TypeInfo) As OrmTableMeta
		  dim md as OrmTableMeta = OrmMetaCache.Lookup(ti.FullName, Nil)
		  if md is Nil then
		    dim zeroConstructor as Introspection.ConstructorInfo = OrmHelpers.GetConstructor(ti)
		    if zeroConstructor is Nil then
		      dim ex as new OrmRecordException(nil, CurrentMethodName)
		      ex.ErrorNumber = 2
		      ex.Message = ti.FullName + " does not have a zero parameter constructor"
		      raise ex
		    end if
		    
		    call zeroConstructor.Invoke
		    
		    md = OrmMetaCache.Lookup(ti.FullName, Nil)
		  end if
		  
		  if md is nil then
		    dim ex as new OrmRecordException(nil, CurrentMethodName)
		    ex.ErrorNumber = 3
		    ex.Message = "Table Meta Data can not be found or created for " + ti.FullName
		    raise ex
		  end if
		  
		  return md
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNew() As Boolean
		  Return (Id = NewId)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadRelated(db As Database = nil, propertyName As String, ParamArray additionalPropertyNames() As String)
		  propertyName = propertyName.Trim
		  if propertyName = "" then
		    raise new OrmRecordException("You must supply at least one property name. Use kLoadAllRelated to load all.", CurrentMethodName )
		  end if
		  
		  if db is nil then
		    db = GetDb
		  end if
		  
		  if additionalPropertyNames is nil then
		    //
		    // Should never happen, but just in case
		    //
		    additionalPropertyNames = Array(propertyName)
		  else
		    additionalPropertyNames.Insert 0, propertyName
		  end if
		  
		  //
		  // If they asked to load all, any other properties they specified are irrelevant
		  //
		  if additionalPropertyNames.IndexOf(kLoadAllRelated) <> -1 then
		    additionalPropertyNames = Array(kLoadAllRelated)
		  end if
		  
		  RaiseEvent LoadRelatedRecords(db, additionalPropertyNames)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Merge(others() As OrmRecord, ByRef mergeSuccess() As OrmRecord, ByRef mergeFail() As OrmRecord, deleteOthers As Boolean = False, save As Boolean = True) As Boolean
		  // Performs a merge and returns arrays of those that are successful, i.e., the MergeFields event did not abort,
		  // and array of those that failed.
		  //
		  // For those that succeed, deletes the other records if requested.
		  
		  //
		  // Start processing
		  //
		  
		  Dim success As Boolean = True // Assume it's just fine
		  
		  Dim db As Database = GetDb(DatabaseIdentifier)
		  
		  Dim successArr() As OrmRecord
		  Dim failArr() As OrmRecord
		  Dim successIDArr() As String
		  
		  // Run merge on each of the others
		  For Each other As OrmRecord In others
		    If MergeOne(other) Then
		      successArr.Append other
		      If deleteOthers Then
		        successIDArr.Append Str(other.Id)
		      End If
		    Else
		      failArr.Append other
		    End If
		  Next other
		  
		  // Save back to the database if asked
		  If success And save And successArr.Ubound <> -1 Then
		    Save()
		  End If
		  
		  // Delete the other records if asked
		  If success And deleteOthers And successArr.Ubound <> -1 Then
		    
		    // Check to make sure we can first
		    If Self.IsNew Then
		      Raise New OrmRecordException("Merge cannot delete other records when merging into a new record", CurrentMethodName)
		    End If
		    
		    Dim inIDClause As String = " IN (" + Join(successIDArr, ",") + ")"
		    
		    // First update the related records
		    Dim fields() As String = RelatedFields() // Same as the other related fields since they are the same table
		    For Each field As String In Fields
		      
		      Dim p As Pair = ExtractTableNameFieldName(field)
		      
		      Dim tableName As String = p.Left.StringValue
		      Dim fieldName As String = p.Right.StringValue
		      
		      Dim sql As String = "UPDATE " + tableName + " SET " + fieldName + " = " + Str(Self.Id) + " WHERE " + fieldName + inIDClause
		      db.SQLExecute sql
		      If db.Error Then
		        Dim msg As String = db.ErrorMessage
		        Raise New OrmRecordException("Could not update related records wth '" + sql + "': " + msg, CurrentMethodName)
		      End If
		    Next field
		    
		    // Now delete the records
		    Dim sql As String = "DELETE FROM " + OrmMyMeta.TableName + " WHERE id " + inIDClause
		    db.SQLExecute sql
		    If db.Error Then
		      Dim msg As String = db.ErrorMessage
		      Raise New OrmRecordException("Could not delete one or more records during merge: " + msg, CurrentMethodName)
		    End If
		    
		  End If
		  
		  // Return the arrays
		  mergeSuccess = successArr
		  mergeFail = failArr
		  
		  Return success
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Merge(other As OrmRecord, deleteOther As Boolean = False, save As Boolean = True) As Boolean
		  Dim successArr() As OrmRecord
		  Dim failArr() As OrmRecord
		  
		  Return Merge(Array(other), successArr, failArr, deleteOther, save) And successArr.Ubound = 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MergeOne(other As OrmRecord) As Boolean
		  //
		  // Check for errors
		  //
		  
		  If OrmMyMeta.FullClassName <> other.OrmMyMeta.FullClassName Then
		    Raise New OrmRecordException("Merge will only work on records of the same class", CurrentMethodName)
		  End If
		  
		  If other.Id = Self.Id Then
		    Raise New OrmRecordException("You can't merge a record into itself", CurrentMethodName)
		  End If
		  
		  //
		  // Before merge returns True to abort the merge before it ever starts
		  //
		  
		  If BeforeMerge(other) Then
		    Return False
		  End If
		  
		  //
		  // Start processing
		  //
		  
		  Dim success As Boolean = True // Assume it will be just fine
		  
		  Dim updates() As Pair
		  
		  For Each p As OrmFieldMeta In OrmMyMeta.Fields
		    // We don't merge Id
		    If p.Prop.Name = "Id" Then
		      Continue For p
		    End If
		    
		    Dim useValue As Variant
		    Select Case MergeField(p.Prop.Name, other, useValue)
		    Case MergeType.Keep
		      //
		      // User wants us to unconditionally keep what we already have
		      // ... do nothing, it is already set to our own value
		      //
		      
		    Case MergeType.Replace
		      //
		      // User wants us to unconditionally take the value from "Other"
		      //
		      
		      updates.Append p : p.Prop.Value(other)
		      
		    Case MergeType.UseProvidedValue
		      //
		      // User has provided the value to use
		      //
		      
		      updates.Append p : useValue
		      
		    Case MergeType.Default
		      //
		      // User wants us to decide what to do with the merge according
		      // to our merge rules of "Take 'other' when 'self' is empty
		      //
		      
		      Dim v As Variant = p.Prop.Value(Self)
		      Dim o As Variant = p.Prop.Value(other)
		      
		      Select Case p.Prop.PropertyType.Name
		      Case "Currency", "Double", "Integer", "Int32", "Int64"
		        If v = 0 Then
		          updates.Append p : o
		        End If
		        
		      Case "Date"
		        If v.DateValue = Nil Then
		          updates.Append p : o
		        End If
		        
		      Case "String"
		        If v.StringValue = "" Then
		          updates.Append p : o
		        End If
		        
		      Case "Boolean"
		        Raise New OrmRecordException("Error merging field '" + p.Prop.Name + ": " + _
		        "The OrmRecord subclass must decide how Booleans should be merged", CurrentMethodName)
		        
		      Case Else
		        Raise New OrmRecordException("Merge cannot automatically handle " + p.Prop.Name, CurrentMethodName)
		      End Select
		      
		    Case MergeType.NeverMerge
		      Raise New OrmRecordException("This OrmRecord subclass may not be merged", CurrentMethodName)
		      
		    Case MergeType.AbortMerge
		      ReDim updates(-1)
		      success = False
		      Exit For p
		      
		    Case Else
		      Raise New OrmRecordException("For Merge to work, you must implement the event MergeField", _
		      CurrentMethodName)
		    End Select
		  Next
		  
		  // Save the values to this object
		  If success Then
		    Dim updateProp As OrmFieldMeta
		    For Each p As Pair In updates
		      updateProp = p.Left
		      updateProp.Prop.Value(Self) = p.Right
		    Next
		  End If
		  
		  RaiseEvent AfterMerge(success, other)
		  
		  Return success
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Notify(notificationKey As Variant, orm As OrmRecord, type As OrmRecord.NotificationType, otherData As Variant, callingChain As Dictionary)
		  // This protected method matches the parameters of the delegate that will be called.
		  
		  dim keys() as Variant = ObserversDict.Keys
		  for each key as Variant in keys
		    dim v as Variant = ObserversDict.Value(key)
		    dim wr as WeakRef = WeakRef(v)
		    dim o as OrmNotificationReceiver = if(wr IsA WeakRef, OrmNotificationReceiver(wr.Value), nil)
		    
		    //
		    // See if the object is still valid
		    //
		    if o is nil then
		      //
		      // The object no longer exists
		      //
		      ObserversDict.Remove key
		      
		    else
		      o.OrmHandleNotification notificationKey, orm, type, otherData
		      
		    end if
		  next
		  
		  //
		  // Notify other instances of the same table/Id
		  //
		  
		  callingChain.Value(self) = nil
		  
		  dim instances() as OrmRecord = GetInstances(DatabaseIdentifier, DatabaseTableName, self.Id)
		  for each instance as OrmRecord in instances
		    if callingChain.HasKey(instance) then
		      //
		      // It's already been called so skip it
		      //
		      continue for instance
		      
		    else
		      //
		      // This instance is some other object that points to the same table and Id
		      // so notify it of the change too
		      //
		      instance.Notify notificationKey, orm, type, otherData, callingChain
		      
		    end if
		  next instance
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Notify(notificationKey As Variant, type As OrmRecord.NotificationType, otherData As Variant = nil)
		  dim callingChain as new Dictionary
		  Notify notificationKey, self, type, otherData, callingChain
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(other As OrmRecord) As Integer
		  If other Is Nil Or OrmMyMeta.FullClassName <> other.OrmMyMeta.FullClassName Then
		    Return -1
		  End If
		  
		  //
		  // Try to do a quick compare on Id's. If Id's are equal, we can't
		  // assume that the objects are the same though, for example one might
		  // be an old load. Thus, if Id's are different, we can terminate
		  // our compare quickly. If, however, they are the same, we must do
		  // a full property compare.
		  //
		  
		  If Id < other.Id Then
		    Return -1
		  ElseIf Id > other.Id Then
		    Return 1
		  End If
		  
		  For Each p As OrmFieldMeta In OrmMyMeta.Fields
		    If p.Prop.Value(Self) <> p.Prop.Value(other) Then
		      //
		      // We are mainly dealing with inequality here, not
		      // necessarily order. If a particular class is worried
		      // about order, they should implement their own
		      // Operator_Compare
		      //
		      
		      Return -1
		    End If
		  Next
		  
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RegisterObserver(owner As String, observer As OrmNotificationReceiver)
		  if owner = "" then
		    raise new OrmRecordException("Cannot register """" as an Observer's owner", CurrentMethodName)
		  end if
		  if observer is nil then
		    raise new OrmRecordException("Cannot register nil as an observer.", CurrentMethodName)
		  end if
		  
		  //
		  // See if the key already exists and, if so, if it still points to an object
		  //
		  dim existing as WeakRef = ObserversDict.Lookup(owner, nil)
		  if existing IsA WeakRef and existing.Value IsA OrmNotificationReceiver and not (existing.Value Is observer) then
		    raise new OrmRecordException("Duplicate key for notification observer.", CurrentMethodName)
		  end if
		  
		  //
		  // Store only a WeakRef
		  //
		  if observer IsA WeakRef then
		    //
		    // Caller already turned it into a WeakRef
		    //
		    ObserversDict.Value(owner) = observer
		  else
		    ObserversDict.Value(owner) = new WeakRef(observer)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RelatedFields() As String()
		  Dim relatedFields() As String
		  If Not ReturnRelatedFields(relatedFields) Then
		    Raise New OrmRecordException("The OrmRecord subclass must implement the ReturnRelatedFields event and return True", _
		    CurrentMethodName)
		  End If
		  
		  Return relatedFields
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Save(db As Database = Nil, asNew As Boolean = False)
		  if asNew then
		    Id = NewId
		  end if
		  
		  if IsNew then
		    SaveNew(db)
		  else
		    SaveExisting(db)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SaveExisting(db As Database = nil)
		  if db is nil then
		    db = GetDb(DatabaseIdentifier)
		  end if
		  
		  if RaiseEvent BeforeSave(db) Or RaiseEvent BeforeUpdate(db) then
		    return
		  end if
		  
		  dim updateSQL as String = OrmMyMeta.UpdateSQL(db)
		  dim ps as PreparedSQLStatement = db.Prepare(updateSQL + Str(Id))
		  
		  for i as Integer = 0 to OrmMyMeta.Fields.Ubound
		    dim p as OrmFieldMeta = OrmMyMeta.Fields(i)
		    
		    dim v as Variant
		    if p.Converter is nil then
		      v = p.Prop.Value(self)
		    else
		      v = p.Converter.ToDatabase(p.Prop.Value(self), self)
		    end if
		    
		    select case db
		    case isa SQLiteDatabase
		      select case v.Type
		      case Variant.TypeBoolean
		        ps.BindType(i, SQLitePreparedStatement.SQLITE_BOOLEAN)
		        
		      case Variant.TypeDouble, Variant.TypeCurrency
		        ps.BindType(i, SQLitePreparedStatement.SQLITE_DOUBLE)
		        
		      case Variant.TypeInteger
		        ps.BindType(i, SQLitePreparedStatement.SQLITE_INTEGER)
		        
		      case Variant.TypeNil
		        ps.BindType(i, SQLitePreparedStatement.SQLITE_NULL)
		        
		      case else
		        ps.BindType(i, SQLitePreparedStatement.SQLITE_TEXT)
		      end select
		    end select
		    
		    if v.IsNull then
		      ps.Bind(i, nil)
		    else
		      ps.Bind(i, v.StringValue)
		    end if
		  next
		  
		  ps.SQLExecute
		  
		  if db.Error then
		    Logging.Log System.LogLevelDebug, "Failing SQL: " + updateSQL
		    
		    for i as Integer = 0 to OrmMyMeta.Fields.Ubound
		      dim p as OrmFieldMeta = OrmMyMeta.Fields(i)
		      
		      dim v as Variant
		      if p.Converter is nil then
		        v = p.Prop.Value(self)
		      else
		        v = p.Converter.ToDatabase(p.Prop.Value(self), self)
		      end if
		      
		      Logging.Log System.LogLevelDebug, Str(i+1) + " = '" + v + "'"
		    next
		    
		    raise new OrmRecordException(db.ErrorCode, "Could not update recordset: " + _
		    db.ErrorMessage, CurrentMethodName)
		  end if
		  
		  RaiseEvent AfterUpdate(db)
		  DoAfterSave(db)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveNew(db As Database = Nil)
		  If db Is Nil Then
		    db = GetDb(DatabaseIdentifier)
		  End If
		  
		  If BeforeSave(db) Or BeforeInsert(db) Then
		    Return
		  End If
		  
		  Dim rec As New DatabaseRecord
		  
		  If db IsA PostgreSQLDatabase Then
		    Id = OrmHelpers.GetSequenceId(db, OrmMyMeta.IdSequenceKey)
		    If db.Error Then
		      Raise New OrmRecordException(db.ErrorCode, "Couldn't get Primary ID for table: " + OrmMyMeta.TableName, _
		      CurrentMethodName)
		    End If
		  End If
		  
		  For Each p As OrmFieldMeta In OrmMyMeta.Fields
		    select case db
		    case isa SQLiteDatabase
		      if p.FieldName = "Id" then
		        continue for p
		      end if
		    end select
		    
		    Dim v As Variant
		    
		    If p.Converter Is Nil Then
		      v = p.Prop.Value(Self)
		    Else
		      v = p.Converter.ToDatabase(p.Prop.Value(Self), Self)
		    End If
		    
		    Select Case v.Type
		    Case Variant.TypeBoolean
		      rec.BooleanColumn(p.FieldName) = v
		      
		    Case Variant.TypeCurrency
		      rec.CurrencyColumn(p.FieldName) = v
		      
		    Case Variant.TypeDate
		      rec.DateColumn(p.FieldName) = v
		      
		    Case Variant.TypeDouble, Variant.TypeSingle
		      rec.DoubleColumn(p.FieldName) = v
		      
		    Case Variant.TypeInteger, Variant.TypeInt32
		      rec.IntegerColumn(p.FieldName) = v
		      
		    Case Variant.TypeInt64
		      rec.Int64Column(p.FieldName) = v
		      
		    Case Variant.TypeNil
		      rec.Column(p.FieldName) = ""
		      
		    Case Variant.TypeText
		      dim t as text = v.TextValue
		      dim s as string = t
		      rec.Column(p.FieldName) = s
		      
		    Case Variant.TypeString
		      rec.Column(p.FieldName) = v.StringValue
		      
		    Case Else
		      Raise New OrmRecordException( _
		      "Unknown value type during save: " + Str(v.Type) + _
		      "for property: " + p.Prop.Name,  CurrentMethodName)
		    End Select
		  Next
		  
		  db.InsertRecord(OrmMyMeta.TableName, rec)
		  If db.Error Then
		    Raise New OrmRecordException(db.ErrorCode, "Failed to save new " + OrmMyMeta.TableName + _
		    " SQL error: " + db.ErrorMessage, CurrentMethodName)
		    
		  elseif db isa SQLiteDatabase then
		    Id = SQLiteDatabase(db).LastRowID
		  End If
		  
		  AfterInsert(db)
		  DoAfterSave(db)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDictionary() As Dictionary
		  Dim d As New Dictionary
		  
		  For Each p As OrmFieldMeta In OrmMyMeta.Fields
		    d.Value(p.Prop.Name) = p.Prop.Value(Self)
		  Next
		  
		  Return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnregisterObserver(owner As String)
		  if ObserversDict.HasKey(owner) then
		    ObserversDict.Remove owner
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AfterDelete(db As Database)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterInsert(db As Database)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterMerge(success As Boolean, other As OrmRecord)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterPopulate()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterSave(db As Database)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event AfterUpdate(db As Database)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeDelete(db As Database) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeInsert(db As Database) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeMerge(other As OrmRecord) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforePopulate() As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeSave(db As Database) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event BeforeUpdate(db As Database) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DatabaseFieldNameFor(propertyName As String) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DatabaseIdentifier() As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DatabaseTableName() As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DefaultOrderBy() As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FieldConverterFor(propertyName As String) As OrmBaseConverter
	#tag EndHook

	#tag Hook, Flags = &h0
		Event LoadRelatedRecords(db As Database, propertyNames() As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MergeField(name As String, other As OrmRecord, ByRef useValue As Variant) As MergeType
	#tag EndHook

	#tag Hook, Flags = &h0
		Event OrmShouldSkip(propertyName As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnMasterTableData(masterData As Dictionary)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnRelatedFields(ByRef relatedFields() As String) As Boolean
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return RaiseEvent DatabaseIdentifier
			End Get
		#tag EndGetter
		DatabaseIdentifier As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Shared DatabaseProvider As OrmDatabaseProvider
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if OrmMyMeta is nil then
			    return ""
			  else
			    return OrmMyMeta.TableName
			  end if
			  
			End Get
		#tag EndGetter
		DatabaseTableName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if OrmMyMeta is nil then
			    return ""
			  else
			    return OrmMyMeta.DefaultOrderBy
			  end if
			  
			End Get
		#tag EndGetter
		DefaultOrderBy As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Id As Integer = NewId
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mInstancesDict is nil then
			    mInstancesDict = new Dictionary
			  end if
			  
			  return mInstancesDict
			End Get
		#tag EndGetter
		Private Shared InstancesDict As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected IsLoading As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim d as new Dictionary
			  RaiseEvent ReturnMasterTableData(d)
			  
			  if d.Count = 0 then
			    d = nil
			  end if
			  
			  return d
			End Get
		#tag EndGetter
		MasterTableData As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared mInstancesDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObserversDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mOrmMetaCache As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mObserversDict is nil then
			    mObserversDict = new Dictionary
			  end if
			  return mObserversDict
			End Get
		#tag EndGetter
		Private ObserversDict As Dictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If mOrmMetaCache Is Nil Then
			    mOrmMetaCache = New Dictionary
			  End If
			  
			  Return mOrmMetaCache
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mOrmMetaCache = value
			End Set
		#tag EndSetter
		Protected Shared OrmMetaCache As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected OrmMyMeta As OrmTableMeta
	#tag EndProperty


	#tag Constant, Name = kLoadAllRelated, Type = String, Dynamic = False, Default = \"Load All Related", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NewId, Type = Double, Dynamic = False, Default = \"-32768", Scope = Public
	#tag EndConstant


	#tag Enum, Name = MergeType, Flags = &h0
		NotImplemented = 0
		  NeverMerge
		  Default
		  Keep
		  Replace
		  UseProvidedValue
		AbortMerge
	#tag EndEnum

	#tag Enum, Name = NotificationType, Type = Integer, Flags = &h0
		ObjectSaved
		  RelatedObjectSaved
		  RelatedObjectAdded
		  RelatedObjectRemoved
		Message
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="DatabaseIdentifier"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DatabaseTableName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultOrderBy"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Id"
			Group="Behavior"
			InitialValue="NewId"
			Type="Integer"
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
