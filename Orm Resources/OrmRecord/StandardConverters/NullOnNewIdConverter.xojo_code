#tag Class
Protected Class NullOnNewIdConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  Return If(v.IsNull, OrmRecord.NewId, v)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetInstance() As NullOnNewIdConverter
		  Static instance As New NullOnNewIdConverter
		  Return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  return if(v.DoubleValue = OrmRecord.NewId, nil, v)
		  
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
