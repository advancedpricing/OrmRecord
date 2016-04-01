#tag Class
Protected Class NullOnEmptyConverterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FromDatabaseTest()
		  dim c as NullOnEmptyConverter = NullOnEmptyConverter.GetInstance
		  dim v as Variant
		  
		  v = nil
		  Assert.AreEqual("", c.FromDatabase(v, nil).StringValue, "Getting nil from database")
		  
		  v = "hi"
		  Assert.AreEqual("hi", c.FromDatabase(v, nil).StringValue, "Getting 'hi' from the database")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToDatabaseTest()
		  dim c as NullOnEmptyConverter = NullOnEmptyConverter.GetInstance
		  
		  Assert.IsNil(c.ToDatabase("", nil), "Sending '' to the database")
		  Assert.AreEqual("hi", c.ToDatabase("hi", nil).StringValue, "Sending 'hi' to the database")
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
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
