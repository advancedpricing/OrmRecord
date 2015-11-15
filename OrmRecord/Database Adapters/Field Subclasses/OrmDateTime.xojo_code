#tag Class
Protected Class OrmDateTime
Inherits Date
	#tag Method, Flags = &h0
		Sub Operator_Convert(someDate As Date)
		  self.Constructor
		  
		  self.GMTOffset = someDate.GMTOffset
		  self.TotalSeconds = someDate.TotalSeconds
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
