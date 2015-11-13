#tag Class
Protected Class YNToBooleanConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  If v Is Nil Then
		    Return False
		  End If
		  
		  Return (v.StringValue = "Y")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetInstance() As YNToBooleanConverter
		  Static instance As New YNToBooleanConverter
		  Return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  If v Is Nil Then
		    Return "N"
		  End If
		  
		  Return If(v.BooleanValue, "Y", "N")
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
