#tag Class
Protected Class OrmCurrency
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Add(other As Currency) As Currency
		  return Value.CurrencyValue + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_AddRight(other As Currency) As Currency
		  return other + Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As Currency
		  return Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(c As Currency)
		  Value = c
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Divide(other As Currency) As Currency
		  return Value.CurrencyValue / other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_DivideRight(other As Currency) As Currency
		  return other / Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_IntegerDivide(other As Currency) As Currency
		  return Value.CurrencyValue \ other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_IntegerDivideRight(other As Currency) As Currency
		  return other \ Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Modulo(divisor As Int64) As Int64
		  return Value.CurrencyValue mod divisor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_ModuloRight(dividend As Int64) As Int64
		  return dividend mod Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Multiply(other As Currency) As Currency
		  return Value.CurrencyValue * other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_MultiplyRight(other As Currency) As Currency
		  return other * Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Negate() As Currency
		  return -Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Subtract(other As Currency) As Currency
		  return Value.CurrencyValue - other
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_SubtractRight(other As Currency) As Currency
		  return other - Value.CurrencyValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText() As Text
		  return Value.CurrencyValue.ToText
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.CurrencyValue
			End Get
		#tag EndGetter
		NativeValue As Currency
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
