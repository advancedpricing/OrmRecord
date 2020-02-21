#tag Class
Protected Class OrmDate
Inherits OrmDateTime
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor
		  
		  ResetTime
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copyDate As Date)
		  super.Constructor(copyDate)
		  
		  ResetTime
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(year as integer, month as integer = 1, day as integer = 1, hour as integer = 0, minute as integer = 0, second as integer = 0, gmtOffset As Double = - 10000)
		  #pragma unused hour
		  #pragma unused minute
		  #pragma unused second
		  
		  super.Constructor(year, month, day, 0, 0, 0, gmtOffset)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FromDate(someDate As Date) As OrmDate
		  if someDate is nil then
		    return nil
		  else
		    return new OrmDate(someDate)
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As String
		  return SQLDate
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResetTime()
		  Date(self).Hour = 0
		  Date(self).Minute = 0
		  Date(self).Second = 0
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return 0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #pragma unused value
			  
			  Date(self).Hour = 0
			End Set
		#tag EndSetter
		Hour As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return 0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #pragma unused value
			  
			  Date(self).Minute = 0
			End Set
		#tag EndSetter
		Minute As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return 0
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #pragma unused value
			  
			  Date(self).Second = 0
			End Set
		#tag EndSetter
		Second As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ResetTime
			  return Date(self).SQLDateTime
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Date(self).SQLDateTime = value
			  ResetTime
			End Set
		#tag EndSetter
		SQLDateTime As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  ResetTime
			  return Date(self).TotalSeconds
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Date(self).TotalSeconds = value
			  ResetTime
			End Set
		#tag EndSetter
		TotalSeconds As Double
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AbbreviatedDate"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Day"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DayOfWeek"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DayOfYear"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GMTOffset"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Hour"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
			Name="LongDate"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LongTime"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Minute"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Month"
			Visible=false
			Group="Behavior"
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
			Name="Second"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShortDate"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShortTime"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SQLDate"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SQLDateTime"
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
		#tag ViewProperty
			Name="TotalSeconds"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WeekOfYear"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Year"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
