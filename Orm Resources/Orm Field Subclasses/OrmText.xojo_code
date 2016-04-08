#tag Class
Protected Class OrmText
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Add(other As Text) As Text
		  return Value.TextValue + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_AddRight(other As Text) As Text
		  return other + Value.TextValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Convert() As Text
		  return Value.TextValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Sub Operator_Convert(t As Text)
		  Value = t
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.TextValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not self.Value.IsNull then
			    self.RaiseUnsupportedOperationException
			    return
			  end if
			  
			  self.Value = value
			End Set
		#tag EndSetter
		NativeValue As Text
	#tag EndComputedProperty


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
			Name="NativeValue"
			Group="Behavior"
			Type="Text"
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
