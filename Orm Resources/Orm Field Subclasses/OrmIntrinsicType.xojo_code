#tag Class
Protected Class OrmIntrinsicType
	#tag Method, Flags = &h1
		Protected Sub Constructor()
		  //
		  // Allows for a nullable instrinsic type
		  //
		  // Does no allow direct instantiation.
		  // The subclasses must implement Operator_Convert to and from a native type
		  // they represent.
		  //
		  // Each type should create a NativeValue method too
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Compare(compare As Variant) As Integer
		  if compare isa OrmIntrinsicType then
		    compare = OrmIntrinsicType(compare).Value
		  end if
		  
		  if compare.IsNull then
		    return 1
		  end if
		  
		  //
		  // Make sure they are like values or raise an exception
		  //
		  static numberTypes() as Int32 = array( _
		  Variant.TypeInteger, Variant.TypeInt32, Variant.TypeInt64, _
		  Variant.TypeSingle, Variant.TypeDouble, Variant.TypeCurrency _
		  )
		  static textTypes() as Int32 = array(Variant.TypeString, Variant.TypeText)
		  
		  dim valueType as Integer = Value.Type
		  dim compareType as Integer = compare.Type
		  dim myValue as Variant = Value
		  
		  //
		  // Variant comparison of Currency is broken in 2016r2 (at least)
		  // If the span between the values is greater than 214,748, the
		  // Variants will not compare correctly
		  //
		  if valueType = Variant.TypeCurrency then
		    myValue = Value.DoubleValue
		  end if
		  if compareType = Variant.TypeCurrency then
		    compare = compare.DoubleValue
		  end if
		  
		  select case true
		  case valueType = compareType
		  case numberTypes.IndexOf(valueType) <> -1 and numberTypes.IndexOf(compareType) <> -1
		  case textTypes.IndexOf(valueType) <> -1 and textTypes.IndexOf(compareType) <> -1
		    
		  case else
		    raise new TypeMismatchException
		  end select
		  
		  
		  if myValue < compare then
		    return -1
		  elseif myValue > compare then
		    return 1
		  else
		    return 0
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Function Operator_Convert() As String
		  return Value.StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RaiseUnsupportedOperationException()
		  dim err as new UnsupportedOperationException
		  err.Message = "You cannot change the value of an OrmIntrinsicType"
		  raise err 
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected Value As Variant
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Value
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //
			  // This will assist in Serialization
			  //
			  if not self.Value.IsNull then
			    RaiseUnsupportedOperationException
			    return
			  end if
			  
			  self.Value = value
			End Set
		#tag EndSetter
		VariantValue As Variant
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
