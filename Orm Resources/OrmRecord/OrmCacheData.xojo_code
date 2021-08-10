#tag Class
Protected Class OrmCacheData
	#tag Method, Flags = &h0
		Sub Constructor()
		  RecordsDict = new Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(arr() As OrmRecordCacheable)
		  self.Constructor
		  
		  for each rec as OrmRecordCacheable in arr
		    RecordsDict.Value(rec.Id) = rec
		    RecordsArray.Append rec
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(id as Integer) As OrmRecordCacheable
		  return RecordsDict.Lookup(id, nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UpdateOrAppend(rec As OrmRecordCacheable) As OrmRecordCacheable
		  dim cached as OrmRecordCacheable = Get(rec.Id)
		  if cached is nil then
		    RecordsArray.Append rec
		    RecordsDict.Value(rec.Id) = rec
		    cached = rec
		  else
		    cached.CopyFrom rec
		  end if
		  
		  return cached
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		RecordsArray() As OrmRecordCacheable
	#tag EndProperty

	#tag Property, Flags = &h0
		RecordsDict As Dictionary
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
