#tag Class
Protected Class OrmDate
Inherits OrmDateTime
	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor
		  
		  Hour = 0
		  Minute = 0
		  Second = 0
		End Sub
	#tag EndMethod


End Class
#tag EndClass
