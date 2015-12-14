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


End Interface
#tag EndInterface
