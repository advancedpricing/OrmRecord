#tag Class
Protected Class OrmFlagHolder
	#tag Method, Flags = &h21
		Private Sub Constructor(enteredCS As CriticalSection)
		  MyCS = enteredCS
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(signaledSemaphore As Semaphore)
		  MySemaphore = signaledSemaphore
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  Leave
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Enter(flag As CriticalSection) As OrmFlagHolder
		  flag.Enter
		  return new OrmFlagHolder(flag)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Enter(flag As Semaphore) As OrmFlagHolder
		  flag.Signal
		  return new OrmFlagHolder(flag)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Leave()
		  if MyCS isa object then
		    MyCS.Leave
		    MyCS = nil
		  elseif MySemaphore isa object then
		    MySemaphore.Release
		    MySemaphore = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function TryEnter(flag As CriticalSection) As OrmFlagHolder
		  if flag.TryEnter then
		    return new OrmFlagHolder(flag)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function TryEnter(flag As Semaphore) As OrmFlagHolder
		  if flag.TrySignal then
		    return new OrmFlagHolder(flag)
		  else
		    return nil
		  end if
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private MyCS As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MySemaphore As Semaphore
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
