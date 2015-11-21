#tag Class
Protected Class OrmDbTransaction
	#tag Method, Flags = &h0
		Sub Commit()
		  Adapter.Commit
		  Adapter = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(dbAdapter As OrmDbAdapter)
		  Adapter = dbAdapter
		  Adapter.StartTransaction
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if Adapter isa OrmDbAdapter then
		    Rollback
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReleaseSavePoint(name As String)
		  Adapter.ReleaseSavePoint name
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rollback()
		  Adapter.Rollback
		  Adapter = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RollbackToSavePoint(name As String)
		  Adapter.RollbackToSavePoint name
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePoint(name As String)
		  Adapter.SavePoint name
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Adapter As OrmDbAdapter
	#tag EndProperty


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
