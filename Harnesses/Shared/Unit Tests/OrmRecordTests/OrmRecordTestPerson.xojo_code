#tag Class
Protected Class OrmRecordTestPerson
Inherits OrmRecord
	#tag Event
		Function DatabaseFieldNameFor(propertyName As String) As String
		  select case propertyName
		  case "ReadOnlyProp"
		    return "abs (-999 ) As ""ReadOnlyProp"""
		    
		  case else
		    return OrmHelpers.CamelCaseToSnakeCase(propertyName)
		    
		  end select
		End Function
	#tag EndEvent

	#tag Event
		Function DatabaseTableName() As String
		  Return kTableName
		End Function
	#tag EndEvent

	#tag Event
		Function FieldConverterFor(propertyName As String, propInfo As Introspection.PropertyInfo) As OrmBaseConverter
		  #pragma unused propInfo
		  
		  select case propertyName
		  case "NotNullInt"
		    return NullOnZeroConverter.GetInstance
		    
		  end select
		End Function
	#tag EndEvent

	#tag Event
		Function IsReadOnly() As Boolean
		  return ClassIsReadOnly
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
		  case "ClassIsReadOnly"
		    return true
		    
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
		ClassIsReadOnly As Boolean
	#tag EndProperty

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
		NotNullInt As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		PostalCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		ReadOnlyProp As Integer
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
			Name="LastSaveType"
			Visible=false
			Group="Behavior"
			InitialValue="SaveTypes.None"
			Type="SaveTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - AsNew"
				"2 - AsExisting"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoRefresh"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DatabaseIdentifier"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DatabaseTableName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultOrderBy"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasChanged"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Id"
			Visible=false
			Group="Behavior"
			InitialValue="NewId"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsReadOnly"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotNullInt"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PostalCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReadOnlyProp"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkipMergeByAttribute"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkipThis"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClassIsReadOnly"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
