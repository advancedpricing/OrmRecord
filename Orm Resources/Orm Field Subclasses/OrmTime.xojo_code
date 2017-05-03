#tag Class
Protected Class OrmTime
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(hour As Integer, minute As Integer, second As Double)
		  Constructor
		  
		  mTotalSeconds = (hour * 3600.0) + (minute * 60.0) + second
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(other As OrmTime)
		  Constructor
		  
		  TotalSeconds = other.TotalSeconds
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Add(time As OrmTime) As OrmTime
		  dim newTime as new OrmTime
		  newTime.TotalSeconds = time.TotalSeconds + TotalSeconds
		  return newTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_AddRight(d As Date) As Date
		  dim newDate as new Date(d)
		  newDate.TotalSeconds = newDate.TotalSeconds + TotalSeconds
		  return newDate
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As Date
		  dim d as new Date
		  d.GMTOffset = 0
		  d.TotalSeconds = TotalSeconds
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As String
		  return ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(d As Date)
		  Constructor
		  
		  TotalSeconds = d.TotalSeconds
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Operator_Convert(s As String)
		  dim parts() as string = s.Split(":")
		  TotalSeconds = (parts(0).Val * 3600.0) + (parts(1).Val * 60.0) + parts(2).Val
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Subtract(time As OrmTime) As OrmTime
		  dim newTime as new OrmTime
		  newTime.TotalSeconds = TotalSeconds - time.TotalSeconds
		  return newTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_SubtractRight(d As Date) As Date
		  dim newDate as new Date(d)
		  newDate.TotalSeconds = newDate.TotalSeconds - TotalSeconds
		  return newDate
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTotalSeconds \ 3600
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTotalSeconds = (value * 3600.0) + (Minute * 60.0) + Second
			End Set
		#tag EndSetter
		Hour As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim part as integer = mTotalSeconds mod 3600.0
			  return part \ 60
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTotalSeconds = (Hour * 3600.0) + (value * 60.0) + Second
			End Set
		#tag EndSetter
		Minute As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mTotalSeconds As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTotalSeconds mod 60.0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTotalSeconds = (Hour * 3600.0) + (Minute * 60.0) + value
			End Set
		#tag EndSetter
		Second As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return format(Hour, "#00") + ":" + format(Minute, "00") + ":" + format(Second, "00")
			End Get
		#tag EndGetter
		ToString As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mTotalSeconds
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTotalSeconds = value
			End Set
		#tag EndSetter
		TotalSeconds As Double
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Hour"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
			Name="Minute"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Second"
			Group="Behavior"
			Type="Double"
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
		#tag ViewProperty
			Name="ToString"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TotalSeconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
