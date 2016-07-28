#tag Class
Protected Class OrmPostgreSQLDbAdapter
Inherits OrmDbAdapter
	#tag Event
		Function Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
		  //
		  // There is a bug in the Xojo as of this writing where
		  // double values >= 1000.0 will generate a database error
		  // when inserted through a prepared statement
		  //
		  
		  for i as integer = 0 to values.Ubound
		    dim v as variant = values(i)
		    
		    select case v.Type
		    case Variant.TypeSingle
		      ps.Bind i, str(v.SingleValue)
		      
		    case Variant.TypeDouble
		      ps.Bind i, str(v.DoubleValue)
		      
		    case Variant.TypeCurrency
		      ps.Bind i, str(v.CurrencyValue)
		      
		    case else
		      ps.Bind i, v
		      
		    end select
		  next
		  
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Function Insert(table As String, values As Dictionary, ByRef returnLastInsertId As Variant) As Boolean
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
		  sql = "INSERT INTO " + QuoteField(table)
		  if fields.Ubound <> -1 then
		    sql = sql + _
		    " ( " + join(fields, ", ") + " ) VALUES ( " + _
		    join(placeholders, ", ") + " ) "
		  else
		    sql = sql + " DEFAULT VALUES "
		  end if
		  
		  dim primaryKey as string = PrimaryKeyField(table)
		  if primaryKey <> "" then
		    sql = sql + "RETURNING " + QuoteField(primaryKey)
		  end if
		  
		  if primaryKey = "" then
		    SQLExecute sql, fieldValues
		    returnLastInsertId = nil
		  else
		    dim rs as RecordSet = SQLSelect(sql, fieldValues)
		    returnLastInsertId = rs.IdxField(1).Value
		  end if
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Function IsPlaceholderFormValid(placeholder As String) As Boolean
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "^\$\d+$"
		  end if
		  
		  return rx.Search(placeholder) isa RegExMatch
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnPlaceholder(index As Integer) As String
		  return "$" + str(index)
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(db As PostgreSQLDatabase)
		  super.Constructor
		  mDb = db
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As PostgreSQLDatabase
		  return PostgreSQLDatabase(mDb)
		End Function
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
