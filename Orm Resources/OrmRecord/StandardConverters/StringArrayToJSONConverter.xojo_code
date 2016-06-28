#tag Class
Protected Class StringArrayToJSONConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #pragma unused context
		  
		  dim arr() as string
		  
		  dim j as string = v.StringValue
		  if j.Encoding is nil then
		    j = j.DefineEncoding(Encodings.UTF8)
		  end if
		  
		  dim json as auto = Xojo.Data.ParseJSON(j.ToText)
		  dim jsonArr() as auto
		  
		  try
		    jsonArr = json
		  catch err as TypeMismatchException
		  catch err as NilObjectException
		  end try
		  
		  redim arr(jsonArr.Ubound)
		  for i as integer = 0 to arr.Ubound
		    arr(i) = jsonArr(i)
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
		  dim jsonArr() as text
		  redim jsonArr(arr.Ubound)
		  for i as integer = 0 to arr.Ubound
		    dim s as string = arr(i)
		    if s.Encoding is nil then
		      s = s.DefineEncoding(Encodings.UTF8)
		    end if
		    jsonArr(i) = s.ToText
		  next
		  
		  return Xojo.Data.GenerateJSON(jsonArr)
		  
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
