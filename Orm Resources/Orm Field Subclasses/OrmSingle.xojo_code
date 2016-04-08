#tag Class
Protected Class OrmSingle
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Add(other As Single) As Single
		  return Value.SingleValue + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_AddRight(other As Single) As Single
		  return other + Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Convert() As Single
		  return Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Sub Operator_Convert(s As Single)
		  Value = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Divide(other As Single) As Single
		  return Value.SingleValue / other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_DivideRight(other As Single) As Single
		  return other / Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_IntegerDivide(other As Single) As Single
		  return Value.SingleValue \ other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_IntegerDivideRight(other As Single) As Single
		  return other \ Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Modulo(divisor As Int64) As Int64
		  return Value.SingleValue mod divisor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_ModuloRight(dividend As Int64) As Int64
		  return dividend mod Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Multiply(other As Single) As Single
		  return Value.SingleValue * other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_MultiplyRight(other As Single) As Single
		  return other * Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Negate() As Single
		  return -Value.SingleValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_Subtract(other As Single) As Single
		  return Value.SingleValue - other
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden ) Function Operator_SubtractRight(other As Single) As Single
		  return other - Value.SingleValue
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.SingleValue
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
		NativeValue As Single
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
			Type="Single"
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
