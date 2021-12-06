#tag Class
Protected Class OrmFieldMeta
	#tag Method, Flags = &h0
		Function ToDatabaseValue(orm As OrmRecord) As Variant
		  dim v as Variant = Prop.Value(orm)
		  
		  if v isa OrmIntrinsicType then
		    v = OrmIntrinsicType(v).VariantValue
		  end if
		  
		  if Converter isa Object then
		    v = Converter.ToDatabase(v, orm)
		  end if
		  
		  return v
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Converter As OrmBaseConverter
	#tag EndProperty

	#tag Property, Flags = &h0
		FieldName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IsDateSubclass As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOrmBooleanSubclass As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsReadOnly As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Prop As Introspection.PropertyInfo
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="FieldName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
	#tag EndViewBehavior
End Class
#tag EndClass
