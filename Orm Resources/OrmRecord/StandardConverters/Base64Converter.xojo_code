#tag Class
Protected Class Base64Converter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  If v.Type <> Variant.TypeString Or v.StringValue = "" Then
		    Return v
		  End If
		  
		  Return DecodeBase64(v.StringValue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetInstance() As Base64Converter
		  Static instance As New Base64Converter
		  Return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  If v.StringValue = "" Then
		    Return Nil
		  End If
		  
		  Return EncodeBase64(v.StringValue)
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
