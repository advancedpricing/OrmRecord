#tag Class
Protected Class YNToBooleanConverterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FromDatabaseTest()
		  dim c as YNToBooleanConverter = YNToBooleanConverter.GetInstance
		  dim v as Variant
		  
		  v = nil
		  Assert.IsFalse(c.FromDatabase(v, nil).BooleanValue, "Getting nil from database")
		  
		  v = "Y"
		  Assert.IsTrue(c.FromDatabase(v, nil).BooleanValue, "Getting Y from database")
		  
		  v = "N"
		  Assert.IsFalse(c.FromDatabase(v, nil).BooleanValue, "Getting N from database")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToDatabaseTest()
		  dim c as YNToBooleanConverter = YNToBooleanConverter.GetInstance
		  
		  Assert.AreEqual("Y", c.ToDatabase(True, nil).StringValue, "Sending True to the database")
		  Assert.AreEqual("N", c.ToDatabase(False, nil).StringValue, "Sending False to the database")
		  
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
