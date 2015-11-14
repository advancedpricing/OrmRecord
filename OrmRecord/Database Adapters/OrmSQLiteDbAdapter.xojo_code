#tag Class
Protected Class OrmSQLiteDbAdapter
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
		  dim rs as RecordSet = SQLSelect("SELECT last_insert_rowid()")
		  if rs is nil or rs.EOF then
		    return 0
		  else
		    return rs.IdxField(1).Int64Value
		  end if
		  
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
		Sub StartTransaction()
		  SQLExecute "BEGIN TRANSACTION"
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass