#tag Class
Protected Class OrmMySQLDbAdapter
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
		Function ReturnBindTypeOfValue(value As Variant) As Int32
		  select case value.Type
		  case Variant.TypeString, Variant.TypeText
		    return MySQLPreparedStatement.MYSQL_TYPE_STRING
		    
		  case Variant.TypeDate
		    return BindTypeOfDate(value.DateValue)
		    
		  case Variant.TypeBoolean
		    return MySQLPreparedStatement.MYSQL_TYPE_TINY
		    
		  case Variant.TypeInt32
		    return BindTypeOfInt32(value.Int32Value)
		    
		  case Variant.TypeInt64
		    return MySQLPreparedStatement.MYSQL_TYPE_LONGLONG
		    
		  case Variant.TypeDouble, Variant.TypeSingle, Variant.TypeCurrency
		    return MySQLPreparedStatement.MYSQL_TYPE_DOUBLE
		    
		  case Variant.TypeNil
		    return MySQLPreparedStatement.MYSQL_TYPE_NULL
		    
		  case Variant.TypeObject
		    return MySQLPreparedStatement.MYSQL_TYPE_BLOB
		    
		  case else
		    if value.IsNull then
		      return MySQLPreparedStatement.MYSQL_TYPE_NULL
		    else
		      raise new OrmDbException("Couldn't find proper bind type", CurrentMethodName)
		    end if
		    
		  end select
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnLastInsertId() As Int64
		  dim id as Int64
		  
		  dim rs as RecordSet = SQLSelect("SELECT last_insert_id()")
		  if rs isa RecordSet and not rs.EOF then
		    id = rs.IdxField(1).Int64Value
		  end if
		  rs = nil
		  
		  return id
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnQuotedField(fieldName As String) As String
		  return "`" + fieldName + "`"
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function BindTypeOfDate(d As Date) As Int32
		  select case d
		  case isa OrmTime
		    return MySQLPreparedStatement.MYSQL_TYPE_TIME
		    
		  case isa OrmTimestamp
		    return MySQLPreparedStatement.MYSQL_TYPE_TIMESTAMP
		    
		  case isa OrmDate
		    return MySQLPreparedStatement.MYSQL_TYPE_DATE
		    
		  case else // OrmDateTime or just Date
		    return MySQLPreparedStatement.MYSQL_TYPE_DATETIME
		    
		  end select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BindTypeOfInt32(value As Int32) As Int32
		  static mb as new MemoryBlock(4)
		  mb.LittleEndian = false
		  
		  mb.Int32Value(0) = value
		  dim p as Ptr = mb
		  if p.Byte(0) <> 0 then
		    return MySQLPreparedStatement.MYSQL_TYPE_LONG
		  elseif p.Byte(1) <> 0 or p.Byte(2) <> 0 then
		    return MySQLPreparedStatement.MYSQL_TYPE_SHORT
		  else
		    return MySQLPreparedStatement.MYSQL_TYPE_TINY
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(db As MySQLCommunityServer)
		  mDb = db
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As MySQLCommunityServer
		  return MySQLCommunityServer(super.Db)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartTransaction()
		  SQLExecute "START TRANSACTION"
		  
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
