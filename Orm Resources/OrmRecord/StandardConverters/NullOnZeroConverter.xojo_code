#tag Class
Protected Class NullOnZeroConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  Return If(v.IsNull, 0.0, v)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetInstance() As NullOnZeroConverter
		  Static instance As New NullOnZeroConverter
		  Return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  if v isa OrmIntrinsicType then
		    v = OrmIntrinsicType(v).VariantValue
		  end if
		  
		  return if(v.IsNull or v.DoubleValue = 0.0, nil, v)
		  
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
