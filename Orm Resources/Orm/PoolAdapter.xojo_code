#tag Interface
Private Interface PoolAdapter
	#tag Method, Flags = &h0
		Sub AttachPool(dbPool As OrmDbPool)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateDate() As Xojo.Core.Date
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DetachFromPool()
		  
		End Sub
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
End Interface
#tag EndInterface
