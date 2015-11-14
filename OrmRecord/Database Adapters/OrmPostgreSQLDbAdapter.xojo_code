#tag Class
Protected Class OrmPostgreSQLDbAdapter
Inherits OrmDbAdapter
	#tag Event
		Function Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
		  for i as integer = 0 to values.Ubound
		    ps.Bind i, values(i)
		  next
		  
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Function Insert(table As String, values As Dictionary) As Boolean
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
		  join(placeholders, ", ") + " ) "
		  dim primaryKey as string = PrimaryKeyFieldFor(table)
		  if primaryKey <> "" then
		    sql = sql + "RETURNING """ + primaryKey + """"
		  end if
		  
		  if primaryKey = "" then
		    SQLExecute sql, fieldValues
		    mLastInsertId = 0
		  else
		    dim rs as RecordSet = SQLSelect(sql, fieldValues)
		    mLastInsertId = rs.IdxField(1).Int64Value
		  end if
		  
		  return true
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnLastInsertId() As Int64
		  return mLastInsertId
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(db As PostgreSQLDatabase)
		  mDb = db
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As PostgreSQLDatabase
		  return PostgreSQLDatabase(super.Db)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mLastInsertId As Int64
	#tag EndProperty


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
			Name="mLastInsertId"
			Group="Behavior"
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