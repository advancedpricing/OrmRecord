#tag Class
Protected Class StringArrayToJSONConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #pragma unused context
		  
		  dim j as string = v.StringValue
		  dim json as new JSONItem(j)
		  
		  dim ub as integer = json.Count - 1
		  dim arr() as string
		  redim arr(ub)
		  
		  for i as integer = 0 to ub
		    arr(i) = json(i).StringValue
		  next i
		  
		  return arr
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetInstance() As StringArrayToJSONConverter
		  static instance as new StringArrayToJSONConverter
		  return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #pragma unused context
		  
		  dim arr() as string = v
		  
		  dim j as new JSONItem("[]")
		  for i as integer = 0 to arr.Ubound
		    j.Append arr(i)
		  next i
		  
		  return j.ToString
		  
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
