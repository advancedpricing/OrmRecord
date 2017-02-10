#tag Class
Protected Class OrmRecordTestPerson
Inherits OrmRecord
	#tag Event
		Function DatabaseFieldNameFor(propertyName As String) As String
		  Return OrmHelpers.CamelCaseToSnakeCase(propertyName)
		End Function
	#tag EndEvent

	#tag Event
		Function DatabaseTableName() As String
		  Return kTableName
		End Function
	#tag EndEvent

	#tag Event
		Function MergeField(name As String, other As OrmRecord, ByRef useValue As Variant) As MergeType
		  Dim o As OrmRecordTestPerson = OrmRecordTestPerson(other)
		  
		  Select Case name
		  Case "FirstName"
		    Return MergeType.Keep
		    
		  Case "LastName"
		    If o.LastName = "Abort" Then
		      Return MergeType.AbortMerge
		    End If
		    
		    Return MergeType.Replace
		    
		  Case "PostalCode"
		    useValue = "12345"
		    Return MergeType.UseProvidedValue
		    
		  Case "SkipThis"
		    Return MergeType.Keep
		    
		  End Select
		  
		  Return MergeType.Default
		End Function
	#tag EndEvent

	#tag Event
		Function OrmShouldSkip(propertyName As String) As Boolean
		  Select Case propertyName
		  Case "SkipThis", "SkipMergeByAttribute"
		    Return True
		    
		  Case Else
		    Return False
		  End Select
		  
		End Function
	#tag EndEvent

	#tag Event
		Function ReturnRelatedFields(ByRef relatedFields() As String) As Boolean
		  #Pragma Unused relatedFields
		  
		  Return True
		End Function
	#tag EndEvent


	#tag Property, Flags = &h0
		DateOfBirth As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		LastName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PostalCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		SkipMergeByAttribute As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SkipThis As String
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeBoolean1 As OrmBoolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeBoolean2 As OrmBoolean
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeDouble1 As OrmDouble
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeDouble2 As OrmDouble
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeText1 As OrmText
	#tag EndProperty

	#tag Property, Flags = &h0
		SomeText2 As OrmText
	#tag EndProperty


	#tag Constant, Name = kTableName, Type = String, Dynamic = False, Default = \"tmp_person", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AutoRefresh"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="FirstName"
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
			Name="IsReadOnly"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="PostalCode"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkipMergeByAttribute"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkipThis"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
