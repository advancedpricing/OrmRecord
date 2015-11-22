#tag Class
Protected Class OrmMSSQLDbAdapter
Inherits OrmDbAdapter
	#tag Event
		Function Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
		  for i as integer = 0 to values.Ubound
		    dim value as variant = values(i)
		    ps.BindType i, BindType(value)
		    if value isa OrmTime then
		      ps.Bind i, OrmTime(value).ToString
		    else
		      ps.Bind i, value
		    end if
		  next
		  
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Function IsPlaceholderFormValid(placeholder As String) As Boolean
		  return placeholder = "?"
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnBindTypeOfValue(value As Variant) As Int32
		  select case value.Type
		  case Variant.TypeString, Variant.TypeText
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_STRING
		    
		  case Variant.TypeDate
		    return BindTypeOfDate(value.DateValue)
		    
		  case Variant.TypeBoolean
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TINYINT
		    
		  case Variant.TypeInt32
		    return BindTypeOfInt32(value.Int32Value)
		    
		  case Variant.TypeInt64
		    return MySQLPreparedStatement.MYSQL_TYPE_LONGLONG
		    
		  case Variant.TypeDouble, Variant.TypeSingle, Variant.TypeCurrency
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DOUBLE
		    
		  case Variant.TypeNil
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_NULL
		    
		  case Variant.TypeObject
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BINARY
		    
		  case else
		    if value.IsNull then
		      return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_NULL
		    else
		      raise new OrmDbException("Couldn't find proper bind type", CurrentMethodName)
		    end if
		    
		  end select
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnLastInsertId() As Variant
		  dim id as Variant
		  
		  dim rs as RecordSet = SQLSelect("SELECT SCOPE_IDENTITY() AS last_insert_id")
		  if rs isa RecordSet and not rs.EOF then
		    id = rs.IdxField(1).Value
		  end if
		  rs = nil
		  
		  return id
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnPlaceholder(index As Integer) As String
		  #pragma unused index
		  
		  return "?"
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function BindTypeOfDate(d As Date) As Int32
		  select case d
		  case isa OrmTime
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TIME
		    
		  case isa OrmTimestamp
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TIMESTAMP
		    
		  case isa OrmDate
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DATE
		    
		  case else // OrmDateTime or just Date
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_DATETIME
		    
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BindTypeOfInt32(value As Int32) As Int32
		  select case value
		  case -127 to 128 
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_TINYINT
		  case -32767 to 32768
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_SMALLINT
		  case -2147483647 to 2147483648
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_INT
		  case else
		    return MSSQLServerPreparedStatement.MSSQLSERVER_TYPE_BIGINT
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(db As MSSQLServerDatabase)
		  mDb = db
		  
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
