#tag Class
Protected Class OrmPreparedSql
	#tag Method, Flags = &h0
		Sub Constructor(adapter As OrmDbAdapter)
		  self.Adapter = adapter
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CopyStringArray(arr() As String) As String()
		  dim copy() as string
		  redim copy(arr.Ubound)
		  for i as integer = 0 to arr.Ubound
		    copy(i) = arr(i)
		  next
		  
		  return copy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PlaceholderList() As String()
		  return CopyStringArray(mPlaceholderList)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PlaceholderList(Assigns arr() As String)
		  if IsPrepared then
		    raise new OrmDbException("Can't set the placeholder list once the PreparedStatement has been created", CurrentMethodName)
		  else
		    mPlaceholderList = CopyStringArray(arr)
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(ParamArray params() As Variant)
		  Adapter.SQLExecute self, params
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(ParamArray params() As Variant) As RecordSet
		  return Adapter.SQLSelect(self, params)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Adapter As OrmDbAdapter
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPreparedStatement isa PreparedSQLStatement
			End Get
		#tag EndGetter
		IsPrepared As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mNewPlaceholderType As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mOrigPlaceholderType As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPlaceholderList() As String
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
			  return mNewPlaceholderType
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not IsPrepared then
			    mNewPlaceholderType = value
			  else
			    raise new OrmDbException("Can't replace placeholder type after the statement has been prepared", CurrentMethodName)
			  end if
			End Set
		#tag EndSetter
		NewPlaceholderType As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mOrigPlaceholderType
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not IsPrepared then
			    mOrigPlaceholderType = value
			  else
			    raise new OrmDbException("Can't replace placeholder type after the statement has been prepared", CurrentMethodName)
			  end if
			End Set
		#tag EndSetter
		OrigPlaceholderType As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPreparedStatement
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not IsPrepared then
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
			  if not IsPrepared then
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
			Name="IsPrepared"
			Group="Behavior"
			Type="Boolean"
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
			Name="NewPlaceholderType"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OrigPlaceholderType"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SQL"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
