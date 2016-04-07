#tag Class
Protected Class OrmFieldSubclassesTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BooleanTest()
		  dim v as OrmBoolean
		  
		  v = true
		  Assert.IsTrue(v, "Value should be true")
		  v = false
		  Assert.IsFalse(v, "Value should be false")
		  dim s as string = v
		  Assert.AreEqual("false", s, "String value should be 'false'")
		  v = nil
		  Assert.IsNil(v, "Object should be nil again")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CurrencyTest()
		  dim v as OrmCurrency
		  
		  dim c as currency = 1.23
		  dim d as double = 3.67
		  dim i as integer = 5
		  
		  v = c
		  Assert.AreEqual(c, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(d, CType(v.NativeValue, double))
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer))
		End Sub
	#tag EndMethod

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
		Sub DoubleTest()
		  dim v as OrmDouble
		  
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  dim i as integer = 8
		  
		  v = d
		  Assert.AreEqual(d, v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(c, CType(v.NativeValue, currency))
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer))
		  
		  dim oc as OrmCurrency = v
		  dim toDouble as double = oc
		  Assert.AreEqual(v.NativeValue, toDouble, 0.1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int32Test()
		  dim v as OrmInt32
		  
		  dim i as Int32 = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, Int32), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, Int32), v.NativeValue)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int64Test()
		  dim v as OrmInt64
		  
		  dim i as Int64 = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, Int64), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, Int64), v.NativeValue)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerTest()
		  dim v as OrmInteger
		  
		  dim i as integer = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, integer), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, integer), v.NativeValue)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntrinsicTypeBaseTest()
		  dim v as OrmDouble = 5.87
		  
		  Assert.IsTrue(v > 0.0)
		  
		  v = 1.23
		  dim c as OrmCurrency = 0.5
		  Assert.IsTrue(v > c, "Compare to another OrmIntrinsicType")
		  
		  c = nil
		  Assert.IsTrue(v > c, "Compare to nil")
		  
		  #pragma BreakOnExceptions false
		  try
		    dim b as OrmBoolean = false
		    Assert.IsFalse(v > b, "Boolean?")
		  catch err as TypeMismatchException
		    Assert.Pass("Comparison to boolean raised an exception")
		  end try
		  #pragma BreakOnExceptions default
		  
		  v = nil
		  Assert.IsTrue(v = nil)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SingleTest()
		  dim v as OrmSingle
		  
		  dim s as single = 1.23
		  dim d as double = 2.887
		  dim c as currency = 5.67
		  dim i as integer = 8
		  
		  v = s
		  dim asDouble as double = s
		  dim valueAsDouble as double = v.NativeValue
		  Assert.AreEqual(asDouble, valueAsDouble, 0.1, "Single")
		  
		  v = d
		  Assert.AreEqual(d, CType(v.NativeValue, double), 0.1, "Double")
		  
		  v = c
		  Assert.AreEqual(c, CType(v.NativeValue, currency), "Currency")
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer), "Integer")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringTest()
		  dim v as OrmString
		  dim s as string = "ABC123"
		  
		  v = s
		  Assert.AreSame(s, v.NativeValue)
		  
		  dim t as text = s.ToText
		  v = t
		  Assert.AreSame(t, v.NativeValue.ToText)
		  Assert.IsTrue(v = t)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TextTest()
		  dim v as OrmText
		  dim t as text = "ABC123"
		  
		  v = t
		  Assert.AreSame(t, v.NativeValue)
		  
		  Assert.IsTrue(v < "ZZZ")
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
