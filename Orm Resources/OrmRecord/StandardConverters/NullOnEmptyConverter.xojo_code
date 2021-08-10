#tag Class
Protected Class NullOnEmptyConverter
Inherits OrmBaseConverter
	#tag Method, Flags = &h0
		Function FromDatabase(v As Variant, context As OrmRecord) As Variant
		  #pragma Unused context
		  
		  if v.IsNull then
		    return ""
		    
		  elseif v.Type = Variant.TypeString then
		    dim s as string = v.StringValue.Trim
		    return s
		    
		  else
		    return v
		    
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetInstance() As NullOnEmptyConverter
		  static instance as new NullOnEmptyConverter
		  return instance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToDatabase(v As Variant, context As OrmRecord) As Variant
		  #Pragma Unused context
		  
		  if v.IsNull then
		    
		    return nil
		    
		  elseif v.Type = Variant.TypeString then
		    
		    dim s as string = v.StringValue.Trim
		    if s = "" then
		      return nil
		    else
		      return s
		    end if
		    
		  elseif v.Type = Variant.TypeText then
		    
		    dim t as text = v.TextValue.Trim
		    if t.Empty then
		      return nil
		    else
		      return t
		    end if
		    
		  else 
		    
		    return v
		    
		  end if
		  
		End Function
	#tag EndMethod


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
