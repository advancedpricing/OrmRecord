#tag Class
Protected Class OrmSQLiteDbAdapter
Inherits OrmDbAdapter
	#tag Event
		Function Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
		  for i as integer = 0 to values.Ubound
		    ps.BindType i, BindType(values(i))
		    ps.Bind i, values(i)
		  next
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Function IsPlaceholderFormValid(placeholder As String) As Boolean
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "(?mi-Us)^(\?\d*|[:@]\w+)$"
		  end if
		  
		  return rx.Search(placeholder) isa RegExMatch
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnBindTypeOfValue(value As Variant) As Int32
		  select case value.Type
		  case Variant.TypeString, Variant.TypeText, Variant.TypeDate
		    return SQLitePreparedStatement.SQLITE_TEXT
		    
		  case Variant.TypeBoolean
		    return SQLitePreparedStatement.SQLITE_BOOLEAN
		    
		  case Variant.TypeInt32
		    return SQLitePreparedStatement.SQLITE_INTEGER
		    
		  case Variant.TypeInt64
		    return SQLitePreparedStatement.SQLITE_INT64
		    
		  case Variant.TypeDouble, Variant.TypeSingle, Variant.TypeCurrency
		    return SQLitePreparedStatement.SQLITE_DOUBLE
		    
		  case Variant.TypeNil
		    return SQLitePreparedStatement.SQLITE_NULL
		    
		  case Variant.TypeObject
		    return SQLitePreparedStatement.SQLITE_BLOB
		    
		  case else
		    if value.IsNull then
		      return SQLitePreparedStatement.SQLITE_NULL
		    else
		      raise new OrmDbException("Couldn't find proper bind type", CurrentMethodName)
		    end if
		    
		  end select
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnLastInsertId() As Int64
		  dim id as Int64
		  
		  dim rs as RecordSet = SQLSelect("SELECT last_insert_rowid()")
		  if rs isa RecordSet and not rs.EOF then
		    id = rs.IdxField(1).Int64Value
		  end if
		  rs = nil
		  
		  return id
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnPlaceholder(index As Integer) As String
		  return "?" + str(index)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(db As SQLiteDatabase)
		  mDb = db
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As SQLiteDatabase
		  return SQLiteDatabase(super.Db)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrimaryKeyField(table As String) As String
		  dim primaryKeyField as string = super.PrimaryKeyField(table)
		  if primaryKeyField = "" then
		    primaryKeyField = "rowid"
		  end if
		  
		  return primaryKeyField
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartTransaction()
		  SQLExecute "BEGIN TRANSACTION"
		  
		End Sub
	#tag EndMethod


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
