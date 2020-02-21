#tag Class
Protected Class OrmInteger
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Add(other As Integer) As Integer
		  return Value.IntegerValue + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_AddRight(other As Integer) As Integer
		  return other + Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_And(other As Integer) As Integer
		  return Value.IntegerValue and other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_AndRight(other As Integer) As Integer
		  return other and Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As Integer
		  return Value.IntegerValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(i As Integer)
		  Value = i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Divide(other As Integer) As Integer
		  return Value.IntegerValue / other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_DivideRight(other As Integer) As Integer
		  return other / Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_IntegerDivide(other As Integer) As Integer
		  return Value.IntegerValue \ other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_IntegerDivideRight(other As Integer) As Integer
		  return other \ Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Modulo(divisor As Integer) As Integer
		  return Value.IntegerValue mod divisor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_ModuloRight(dividend As Integer) As Integer
		  return dividend mod Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Multiply(other As Integer) As Integer
		  return Value.IntegerValue * other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_MultiplyRight(other As Integer) As Integer
		  return other * Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Negate() As Integer
		  return -Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Not() As Integer
		  return not Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Or(other As Integer) As Integer
		  return Value.IntegerValue or other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_OrRight(other As Integer) As Integer
		  return other or Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Subtract(other As Integer) As Integer
		  return Value.IntegerValue - other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_SubtractRight(other As Integer) As Integer
		  return other - Value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Xor(other As Integer) As Integer
		  return Value.IntegerValue xor other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_XorRight(other As Integer) As Integer
		  return other xor Value.IntegerValue
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.IntegerValue
			End Get
		#tag EndGetter
		NativeValue As Integer
	#tag EndComputedProperty


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
			Name="NativeValue"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
