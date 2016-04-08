#tag Class
Protected Class OrmInt32
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Add(other As Int32) As Int32
		  return Value.Int32Value + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_AddRight(other As Int32) As Int32
		  return other + Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_And(other As Int32) As Int32
		  return Value.Int32Value and other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_AndRight(other As Int32) As Int32
		  return other and Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Convert() As Int32
		  return Value.Int32Value
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Sub Operator_Convert(i As Int32)
		  Value = i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Divide(other As Int32) As Int32
		  return Value.Int32Value / other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_DivideRight(other As Int32) As Int32
		  return other / Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_IntegerDivide(other As Int32) As Int32
		  return Value.Int32Value \ other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_IntegerDivideRight(other As Int32) As Int32
		  return other \ Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Modulo(divisor As Int32) As Int32
		  return Value.Int32Value mod divisor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_ModuloRight(dividend As Int32) As Int32
		  return dividend mod Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Multiply(other As Int32) As Int32
		  return Value.Int32Value * other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_MultiplyRight(other As Int32) As Int32
		  return other * Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Negate() As Int32
		  return -Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Not() As Int32
		  return not Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Or(other As Int32) As Int32
		  return Value.Int32Value or other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_OrRight(other As Int32) As Int32
		  return other or Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Subtract(other As Int32) As Int32
		  return Value.Int32Value - other
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_SubtractRight(other As Int32) As Int32
		  return other - Value.Int32Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Xor(other As Int32) As Int32
		  return Value.Int32Value xor other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_XorRight(other As Int32) As Int32
		  return other xor Value.Int32Value
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.Int32Value
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
		NativeValue As Int32
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
			Type="Int32"
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
