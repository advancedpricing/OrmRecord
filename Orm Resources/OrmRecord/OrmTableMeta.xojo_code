#tag Class
Protected Class OrmTableMeta
	#tag Method, Flags = &h0
		Function UpdateSQL(db as Database, fields() As OrmFieldMeta) As String
		  select case db
		  case isa PostgreSQLDatabase
		    return UpdateSQL_Numbered("$", 1, fields)
		    
		  case isa SQLiteDatabase
		    return UpdateSQL_Numbered("?", 1, fields)
		    
		  case else
		    raise new OrmRecordException("Unsupported database type", CurrentMethodName)
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function UpdateSQL_Numbered(numberPrefix as String, start as Integer, fields() As OrmFieldMeta) As String
		  dim assignments() as String
		  
		  for each fm as OrmFieldMeta in fields
		    assignments.Append fm.FieldName + "=" + numberPrefix + Str(start)
		    start = start + 1
		  next
		  
		  dim sql as String = _
		  "UPDATE " + TableName + _
		  " SET " + Join(assignments, ",") + _
		  " WHERE id="
		  
		  return sql
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		BaseInsertSQL As String
	#tag EndProperty

	#tag Property, Flags = &h0
		BaseSelectSQL As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructorRs As Introspection.ConstructorInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		ConstructorZero As Introspection.ConstructorInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultOrderBy As String
	#tag EndProperty

	#tag Property, Flags = &h0
		DeleteSQL As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Fields() As OrmFieldMeta
	#tag EndProperty

	#tag Property, Flags = &h0
		FullClassName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IdFieldIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		IdSequenceKey As String
	#tag EndProperty

	#tag Property, Flags = &h0
		InitialValues() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TableName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ValuesAfterInsert() As String
	#tag EndProperty


	#tag Enum, Name = DatabaseType, Type = Integer, Flags = &h0
		Unknown
		  MSSQLServer
		  MySQLCommunity
		  ODBC
		  Oracle
		  PostgreSQL
		SQLite
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="BaseInsertSQL"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BaseSelectSQL"
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
			Name="DeleteSQL"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FullClassName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IdSequenceKey"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="TableName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
