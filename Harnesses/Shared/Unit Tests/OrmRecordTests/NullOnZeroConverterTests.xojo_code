#tag Class
Protected Class NullOnZeroConverterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FromDatabaseTest()
		  dim c as NullOnZeroConverter = NullOnZeroConverter.GetInstance
		  dim v as Variant
		  
		  v = 0
		  Assert.AreEqual(0, c.FromDatabase(v, nil).IntegerValue, "Getting nil from database")
		  
		  v = 10
		  Assert.AreEqual(10, c.FromDatabase(v, nil).IntegerValue, "Getting 10 from the database")
		  
		  v = -10
		  Assert.AreEqual(-10, c.FromDatabase(v, nil).IntegerValue, "Getting -10 from the database")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToDatabaseTest()
		  dim c as NullOnZeroConverter = NullOnZeroConverter.GetInstance
		  
		  Assert.IsNil(c.ToDatabase(0, nil), "Sending 0 to the database")
		  Assert.AreEqual(10, c.ToDatabase(10, nil).IntegerValue, "Sending 10 to the database")
		  Assert.AreEqual(-10, c.ToDatabase(-10, nil).IntegerValue, "Sending -10 to the database")
		  
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
