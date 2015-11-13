#tag Class
Protected Class OrmRecordCacheable
Inherits OrmRecord
	#tag Method, Flags = &h0
		 Shared Function Cache(ti As Introspection.TypeInfo) As OrmRecordCacheable()
		  dim data as OrmCacheData = GetCacheData(ti)
		  return CopyArray(data.RecordsArray)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Cache(ti As Introspection.TypeInfo, Assigns records() As OrmRecordCacheable)
		  dim data as OrmCacheData = GetCacheData(ti)
		  
		  dim copy() as OrmRecordCacheable = CopyArray(records)
		  data.RecordsArray = copy
		  
		  dim dict as Dictionary = data.RecordsDict
		  dict.Clear
		  
		  for each rec as OrmRecordCacheable in copy
		    dict.Value(rec.Id) = rec
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function CopyArray(inArr() As OrmRecordCacheable) As OrmRecordCacheable()
		  dim result() as OrmRecordCacheable
		  redim result(inArr.Ubound)
		  
		  for i as integer = 0 to inArr.Ubound
		    result(i) = inArr(i)
		  next
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetCacheData(ti As Introspection.TypeInfo) As OrmCacheData
		  dim result as OrmCacheData = CacheDict.Lookup(ti.FullName, nil)
		  if result is nil then
		    result = new OrmCacheData
		    CacheDict.Value(ti.FullName) = result
		  end if
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetFromCache(ti As Introspection.TypeInfo, id As Integer) As OrmRecordCacheable
		  dim data as OrmCacheData = GetCacheData(ti)
		  return data.RecordsDict.Lookup(id, nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetMany(db As Database, ti As Introspection.TypeInfo, clause As String = "", ParamArray params() As Variant) As OrmRecordCacheable()
		  //
		  // Typecast the result
		  //
		  
		  dim recs() as OrmRecord = OrmRecord.GetMany(db, ti, clause, params)
		  dim result() as OrmRecordCacheable
		  redim result(recs.Ubound)
		  
		  for i as integer = 0 to recs.Ubound
		    result(i) = OrmRecordCacheable(recs(i))
		  next
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function HasCache(ti As Introspection.TypeInfo) As Boolean
		  dim data as OrmCacheData = GetCacheData(ti)
		  return (data.RecordsArray.Ubound <> -1)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  static dict as new Dictionary
			  return dict
			End Get
		#tag EndGetter
		Shared CacheDict As Dictionary
	#tag EndComputedProperty


	#tag ViewBehavior
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
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
