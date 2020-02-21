#tag Class
Protected Class OrmString
Inherits OrmIntrinsicType
	#tag Method, Flags = &h0
		Function Asc() As Integer
		  return Value.StringValue.Asc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AscB() As Integer
		  return Value.StringValue.AscB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CDbl() As Double
		  return Value.StringValue.CDbl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CLong() As Int64
		  return Value.StringValue.CLong
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ConvertEncoding(newEncoding As TextEncoding) As String
		  return Value.StringValue.ConvertEncoding(newEncoding)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountFields(seperator As String) As Integer
		  return Value.StringValue.CountFields(seperator)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountFieldsB(seperator As String) As Integer
		  return Value.StringValue.CountFieldsB(seperator)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefineEncoding(encoding As TextEncoding) As String
		  return Value.StringValue.DefineEncoding(encoding)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encoding() As TextEncoding
		  return Value.StringValue.Encoding
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InStr(start As Integer = 0, find As String) As Integer
		  return Value.StringValue.InStr(start, find)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function InStrB(start As Integer = 0, find As String) As Integer
		  return Value.StringValue.InStrB(start, find)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Left(count As Integer) As String
		  return Value.StringValue.Left(count)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LeftB(count As Integer) As String
		  return Value.StringValue.LeftB(count)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Len() As Integer
		  return Value.StringValue.Len
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LenB() As Integer
		  return Value.StringValue.LenB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lowercase() As String
		  return Value.StringValue.Lowercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LTrim() As String
		  return Value.StringValue.LTrim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mid(start As Integer) As String
		  return Value.StringValue.Mid(start)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mid(start As Integer, length As Integer) As String
		  return Value.StringValue.Mid(start, length)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MidB(start As Integer) As String
		  return Value.StringValue.MidB(start)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MidB(start As Integer, length As Integer) As String
		  return Value.StringValue.MidB(start, length)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NthField(seperator As String, index As Integer) As String
		  return Value.StringValue.NthField(seperator, index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NthFieldB(seperator As String, index As Integer) As String
		  return Value.StringValue.NthFieldB(seperator, index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Add(other As String) As String
		  return Value.StringValue + other
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_AddRight(other As String) As String
		  return other + Value.StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As String
		  return Value.StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(s As String)
		  Value = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Replace(substring As String, replacementString As String) As String
		  return Value.StringValue.Replace(substring, replacementString)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceAll(substring As String, replacementString As String) As String
		  return Value.StringValue.ReplaceAll(substring, replacementString)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceAllB(substring As String, replacementString As String) As String
		  return Value.StringValue.ReplaceAllB(substring, replacementString)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceB(substring As String, replacementString As String) As String
		  return Value.StringValue.ReplaceB(substring, replacementString)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Right(count As Integer) As String
		  return Value.StringValue.Right(count)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RightB(count As Integer) As String
		  return Value.StringValue.RightB(count)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RTrim() As String
		  return Value.StringValue.RTrim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Split(delimiter As String = " ") As String()
		  return Value.StringValue.Split(delimiter)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SplitB(delimiter As String = " ") As String()
		  return Value.StringValue.SplitB(delimiter)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Titlecase() As String
		  return Value.StringValue.Titlecase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText() As Text
		  return Value.StringValue.ToText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Trim() As String
		  return Value.StringValue.Trim
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Uppercase() As String
		  return Value.StringValue.Uppercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Val() As Double
		  return Value.StringValue.Val
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return self.Value.StringValue
			End Get
		#tag EndGetter
		NativeValue As String
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
			Type="String"
			EditorType="MultiLineEditor"
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
