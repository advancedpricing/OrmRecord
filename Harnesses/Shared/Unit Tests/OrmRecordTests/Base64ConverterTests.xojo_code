#tag Class
Protected Class Base64ConverterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FromDatabaseTest()
		  dim c as Base64Converter = Base64Converter.GetInstance
		  dim v as Variant
		  
		  v = nil
		  Assert.IsTrue(c.FromDatabase(v, nil).IsNull, "Getting nil from database")
		  
		  v = ""
		  Assert.AreEqual "", c.FromDatabase(v, nil).StringValue, "Getting an empty string from database"
		  
		  var actual as string = "!@#$%"
		  var encoded as string = Base64Encode(actual)
		  
		  Assert.AreEqual actual, c.FromDatabase(encoded, nil).StringValue, "Getting Base64 from database"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToDatabaseTest()
		  dim c as Base64Converter = Base64Converter.GetInstance
		  
		  var actual as string
		  var encoded as string
		  
		  actual = ""
		  encoded = ""
		  Assert.AreEqual encoded, c.ToDatabase(actual, nil).StringValue, "Sending empty to database"
		  
		  Assert.IsNil c.ToDatabase(nil, nil), "Sending nil to database"
		  
		  actual = "!@#$%"
		  encoded = EncodeBase64(actual)
		  Assert.AreSame encoded, c.ToDatabase(actual, nil).StringValue, "Encodeds to database"
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
End Class
#tag EndClass
