#tag Class
Protected Class OrmBoolean
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_And(other As Boolean) As Boolean
		  return Value.BooleanValue and other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_AndRight(other As Boolean) As Boolean
		  return other and Value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Convert() As Boolean
		  return Value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Sub Operator_Convert(b As Boolean)
		  Value = b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Not() As Boolean
		  return not Value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Or(other As Boolean) As Boolean
		  return Value.BooleanValue or other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_OrRight(other As Boolean) As Boolean
		  return other or Value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Xor(other As Boolean) As Boolean
		  return Value.BooleanValue xor other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_XorRight(other As Boolean) As Boolean
		  return other xor Value.BooleanValue
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.BooleanValue
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
		NativeValue As Boolean
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
			Type="Boolean"
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
