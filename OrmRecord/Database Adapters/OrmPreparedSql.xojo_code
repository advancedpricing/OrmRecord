#tag Class
Protected Class OrmPreparedSql
	#tag Method, Flags = &h0
		Sub Constructor(adapter As OrmDbAdapter)
		  self.Adapter = adapter
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(ParamArray params() As Variant)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(ParamArray params() As Variant) As RecordSet
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Adapter As OrmDbAdapter
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mPreparedStatement As PreparedSQLStatement
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mSQL As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPreparedStatement
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if mPreparedStatement is nil then
			    mPreparedStatement = value
			  else
			    raise new OrmDbException("Can't replace PreparedStatement once it's been created", CurrentMethodName)
			  end if
			End Set
		#tag EndSetter
		PreparedStatement As PreparedSQLStatement
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mSQL
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if mPreparedStatement is nil then
			    mSQL = value
			  else
			    raise new OrmDbException("Can't replace SQL once the PreparedStatement has been created", CurrentMethodName)
			  end if
			End Set
		#tag EndSetter
		SQL As String
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
