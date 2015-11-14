#tag Class
Protected Class OrmMySQLDbAdapter
Inherits OrmDbAdapter
	#tag Event
		Function Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
		  for i as integer = 0 to values.Ubound
		    ps.BindType i, BindTypeOf(values(i))
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
		    return MySQLPreparedStatement.MYSQL_TYPE_DATE
		    
		  case Variant.TypeBoolean
		    return MySQLPreparedStatement.MYSQL_TYPE_TINY
		    
		  case Variant.TypeInt32
		    return MySQLPreparedStatement.MYSQL_TYPE_LONG
		    
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
			Name="LastInsertId"
			Group="Behavior"
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
