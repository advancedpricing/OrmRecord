#tag Class
Protected Class OrmPreparedStatement
Implements PreparedSQLStatement
	#tag Method, Flags = &h0
		Sub Bind(dict As Dictionary)
		  if dict is nil then
		    // 
		    // Do nothing
		    //
		    return
		  end if
		  
		  dim keys() as variant = dict.Keys
		  dim values() as variant = dict.Values
		  
		  for i as integer = 0 to keys.Ubound
		    Bind keys(i).StringValue, values(i)
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bind(zeroBasedParam As Integer, value As Variant)
		  // Part of the PreparedSQLStatement interface.
		  
		  if ValuesDictionary isa Dictionary then
		    raise new OrmDbException("Can't bind by name and index", CurrentMethodName)
		  end if
		  
		  if ValuesArray is nil then
		    dim v() as Variant
		    redim v(UniquePlaceholderCount - 1)
		    ValuesArray = v
		  end if
		  
		  if ValuesArray.Ubound < zeroBasedParam then
		    redim ValuesArray(zeroBasedParam)
		  end if
		  
		  ValuesArray(zeroBasedParam) = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub Bind(zeroBasedParam As Integer, value As Variant, type As Integer)
		  // Part of the PreparedSQLStatement interface.
		  
		  Bind zeroBasedParam, value
		  
		  #pragma unused type
		  
		  //
		  // We don't need type, so just ignore it
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bind(pairs() As Pair)
		  if pairs is nil then
		    //
		    // Do nothing
		    //
		    return
		  end if
		  
		  for each p as Pair in Pairs
		    Bind p.Left.StringValue, p.Right
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bind(name As String, value As Variant)
		  if not (ValuesArray is nil) then
		    raise new OrmDbException("Can't bind by name and index", CurrentMethodName)
		  elseif OrigPlaceholderType <> PlaceholderTypes.Named then
		    raise new OrmDbException("Can't bind named values because the placeholders were indexed or ordered", CurrentMethodName)
		  end if
		  
		  if ValuesDictionary is nil then
		    ValuesDictionary = new Dictionary
		  end if
		  
		  ValuesDictionary.Value(name) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bind(values() As Variant)
		  if values is nil then
		    //
		    // Do nothing
		    //
		    
		  elseif values.Ubound <> -1 and values(0) isa Pair then
		    
		    for each v as variant in values
		      dim p as Pair = Pair(v)
		      Bind p.Left.StringValue, p.Right
		    next
		    
		  elseif values.Ubound = 0 and values(0) isa Dictionary then
		    Bind Dictionary(values(0))
		    
		  else
		    
		    for i as integer = 0 to values.Ubound
		      Bind i, values(i)
		    next
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub BindType(types() As Integer)
		  // Part of the PreparedSQLStatement interface.
		  
		  #pragma unused types
		  
		  //
		  // This isn't needed, so just ignore it
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( hidden )  Sub BindType(zeroBasedIndex As Integer, type As Integer)
		  // Part of the PreparedSQLStatement interface.
		  
		  #pragma unused zeroBasedIndex
		  #pragma unused type
		  
		  //
		  // This isn't needed, so just ignore it
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(adapter As OrmDbAdapter, ps As PreparedSQLStatement, sql As String, placeholders() As String, origPhType As PlaceholderTypes, newPhType As PlaceholderTypes, origIsAcceptable As Boolean)
		  self.Adapter = adapter
		  mPreparedStatement = ps
		  mSQL = sql
		  self.mPlaceholders = CopyStringArray(placeholders)
		  mOrigPlaceholderType = origPhType
		  mNewPlaceholderType = newPhType
		  mIsOriginalPlaceholderAcceptable = origIsAcceptable
		  
		  //
		  // Count the unique placeholders
		  //
		  
		  if origPhType <> PlaceholderTypes.Ordered then
		    
		    UniquePlaceholderCount = 0
		    for i as integer = placeholders.Ubound downto 0
		      dim pos as integer = placeholders.IndexOf(placeholders(i))
		      if pos = i then
		        UniquePlaceholderCount = UniquePlaceholderCount + 1
		      end if
		    next
		    
		  else
		    
		    UniquePlaceholderCount = placeholders.Ubound + 1
		    
		  end if
		  
		  ValuesArray = nil
		  ValuesDictionary = nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CopyStringArray(arr() As String) As String()
		  dim copy() as string
		  redim copy(arr.Ubound)
		  for i as integer = 0 to arr.Ubound
		    copy(i) = arr(i)
		  next
		  
		  return copy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FetchParams(givenParams() As Variant) As Variant()
		  if not (givenParams is nil) and givenParams.Ubound = 0 and givenParams(0).IsArray then
		    dim a as auto = givenParams(0)
		    givenParams = a
		  end if
		  
		  if givenParams is nil or givenParams.Ubound = -1 then
		    if ValuesDictionary isa Dictionary then
		      dim v() as Variant
		      v.Append ValuesDictionary
		      givenParams = v
		    elseif not (ValuesArray is nil) then
		      givenParams = ValuesArray
		    end if
		  end if
		  
		  return givenParams
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsOriginalPlaceholderAcceptable() As Boolean
		  return mIsOriginalPlaceholderAcceptable
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NewPlaceholderType() As PlaceholderTypes
		  return mNewPlaceholderType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OrigPlaceHolderType() As PlaceholderTypes
		  return mOrigPlaceholderType
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Placeholders() As String()
		  return CopyStringArray(mPlaceholders)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PreparedStatement() As PreparedSQLStatement
		  return mPreparedStatement
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQL() As String
		  return mSQL
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(ParamArray params() As Variant)
		  params = FetchParams(params)
		  
		  Adapter.SQLExecute self, params
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(ParamArray params() As Variant) As RecordSet
		  params = FetchParams(params)
		  
		  return Adapter.SQLSelect(self, params)
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mAdapterWR is nil then
			    return nil
			  else
			    return OrmDbAdapter(mAdapterWR.Value)
			  end if
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value is nil then
			    mAdapterWR = nil
			  else
			    mAdapterWR = new WeakRef(value)
			  end if
			End Set
		#tag EndSetter
		Private Adapter As OrmDbAdapter
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mPreparedStatement isa PreparedSQLStatement
			End Get
		#tag EndGetter
		IsPrepared As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mAdapterWR As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsOriginalPlaceholderAcceptable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNewPlaceholderType As PlaceholderTypes
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOrigPlaceholderType As PlaceholderTypes
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPlaceholders() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPreparedStatement As PreparedSQLStatement
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSQL As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UniquePlaceholderCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ValuesArray() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ValuesDictionary As Dictionary
	#tag EndProperty


	#tag Enum, Name = PlaceholderTypes, Type = Integer, Flags = &h0
		Unknown = 0
		  Named = 1
		  Indexed = 2
		Ordered = 3
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsPrepared"
			Group="Behavior"
			Type="Boolean"
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
