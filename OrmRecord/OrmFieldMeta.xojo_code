#tag Class
Protected Class OrmFieldMeta
	#tag Property, Flags = &h0
		Converter As OrmBaseConverter
	#tag EndProperty

	#tag Property, Flags = &h0
		FieldName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Prop As Introspection.PropertyInfo
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="FieldName"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
