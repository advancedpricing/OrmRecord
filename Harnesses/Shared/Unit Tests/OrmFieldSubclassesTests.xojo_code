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
		  
		  dim t as new OrmTime
		  Assert.AreEqual 0, t.Year, "OrmTime Year"
		  Assert.AreEqual 0, t.Month, "OrmTime Month"
		  Assert.AreEqual 0, t.Day, "OrmTime Day"
		  
		  t = master
		  Assert.AreEqual master.TotalSeconds, t.TotalSeconds
		End Sub
	#tag EndMethod


End Class
#tag EndClass
