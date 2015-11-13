#tag Class
Protected Class OrmDbAdapter
	#tag Method, Flags = &h1
		Protected Function BindTypeOf(value As Variant) As Int32
		  return ReturnBindTypeOfValue(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Commit()
		  Db.Commit
		  RaiseDbException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  //
		  // Cannot be instantiated directly
		  //
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Db() As Database
		  return mDb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete(table As String, whereClause As String)
		  if RaiseEvent Delete(table, whereClause) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  #pragma warning "Finish this!!"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetAdapter(db As Database) As OrmDbAdapter
		  dim adapter as OrmDbAdapter
		  
		  select case db
		  case isa PostgreSQLDatabase
		    adapter = new OrmPostgreSQLDbAdapter(PostgreSQLDatabase(db))
		    
		  case else
		    dim err as new RuntimeException
		    err.Message = "Can't locate an appropriate adapter"
		    raise err 
		    
		  end select
		  
		  adapter.mDb = db
		  return adapter
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Insert(table As String, values As Dictionary) As Int64
		  if RaiseEvent Insert(table, values) then
		    RaiseDbException CurrentMethodName
		    return LastInsertId
		  end if
		  
		  #pragma warning "Finish this!!"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RaiseDbException(methodName As String)
		  if Db.Error then
		    raise new OrmRecordException(Db.ErrorMessage, methodName)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Rollback()
		  Db.Rollback
		  RaiseDbException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(sql As String, ParamArray params() As Variant)
		  #pragma unused sql
		  #pragma unused params
		  
		  #pragma warning "Finish this!!"
		  
		  RaiseDbException CurrentMethodName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(sql As String, ParamArray params() As Variant) As RecordSet
		  #pragma unused sql
		  #pragma unused params
		  
		  #pragma warning "Finish this!!"
		  
		  RaiseDbException CurrentMethodName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartTransaction()
		  SQLExecute "START TRANSACTION"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update(table As String, values As Dictionary, whereClause As String)
		  if RaiseEvent Update(table, values, whereClause) then
		    RaiseDbException CurrentMethodName
		    return
		  end if
		  
		  #pragma warning "Finish this!!"
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Bind(ps As PreparedSQLStatement, values() As Variant) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Delete(table As String, whereClause AS String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Insert(table As String, values As Dictionary) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnBindTypeOfValue(value As Variant) As Int32
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReturnLastInsertId() As Int64
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Update(table As String, values As Dictionary, whereClause As String) As Boolean
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return RaiseEvent ReturnLastInsertId
			End Get
		#tag EndGetter
		LastInsertId As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mDb As Database
	#tag EndProperty


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
