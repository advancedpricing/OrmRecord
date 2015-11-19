#tag Class
Protected Class OrmFieldSubclassesTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub DateTest()
		  dim master as new Date(2013, 9, 8, 7, 6, 5, 4)
		  dim dt as OrmDateTime = master
		  Assert.AreEqual master.TotalSeconds, dt.TotalSeconds
		  
		  dim ts as OrmTimestamp = master
		  Assert.AreEqual master.TotalSeconds, ts.TotalSeconds
		  
		  dim d as new OrmDate
		  Assert.AreEqual 0, d.Hour, "OrmDate Hour"
		  Assert.AreEqual 0, d.Minute, "OrmDate Minute"
		  Assert.AreEqual 0, d.Second, "OrmDate Second"
		  
		  d = master
		  Assert.AreEqual master.TotalSeconds, d.TotalSeconds
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TimeTest()
		  dim t as new OrmTime
		  Assert.AreEqual 0, t.Hour, "OrmTime Hour"
		  Assert.AreEqual 0, t.Minute, "OrmTime Minute"
		  Assert.AreEqual 0.0, t.Second, "OrmTime Second"
		  
		  dim master as new Date
		  t = master
		  Assert.AreEqual master.TotalSeconds, t.TotalSeconds, "Date and Time TotalSeconds"
		  
		  dim diff as new OrmTime(1, 0, 0)
		  dim newDate as date = master - diff
		  master.TotalSeconds = master.TotalSeconds - 3600
		  Assert.AreEqual master.Hour, newDate.Hour, "Subtract an hour"
		  
		  dim time1 as new OrmTime(1, 0, 0)
		  dim time2 as new OrmTime(0, 0, 5)
		  dim combined as OrmTime = time1 + time2
		  Assert.AreEqual 3605.0, combined.TotalSeconds, "Add 5 minutes"
		  
		  combined = combined - time2
		  Assert.AreEqual 3600.0, combined.TotalSeconds, "Subtract 5 minutes"
		  
		  t = new OrmTime(999, 1, 2)
		  Assert.AreEqual "999:01:02", t.ToString, "Convert to string long"
		  
		  t = new OrmTime(99, 1, 2)
		  Assert.AreEqual "99:01:02", t.ToString, "Convert to string (2-digit hour)"
		  
		  t = new OrmTime(9, 1, 2)
		  Assert.AreEqual "09:01:02", t.ToString, "Convert to string (1-digit hour)"
		  
		  t = new OrmTime(0, 0, 1.2)
		  Assert.AreEqual 1.2, t.TotalSeconds, "TotalSeconds should retain a fraction"
		  Assert.AreEqual "00:00:01", t.ToString, "Fractional seconds should not reflect in string"
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
