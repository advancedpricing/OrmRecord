#tag Module
Protected Module OrmHelpers
	#tag Method, Flags = &h1
		Protected Function CamelCaseToSnakeCase(s As String) As String
		  static rx as RegEx
		  if rx is nil then
		    rx = new RegEx
		    rx.SearchPattern = "(?mi-Us)(?<!^)\p{Lu}"
		    rx.ReplacementPattern = "_$&"
		    rx.Options.ReplaceAllMatches = true
		  end if
		  
		  s = rx.Replace( s )
		  s = s.Lowercase
		  return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetConstructor(ti As Introspection.TypeInfo, ParamArray types() As String) As Introspection.ConstructorInfo
		  for each ci as Introspection.ConstructorInfo in ti.GetConstructors
		    dim pi() as Introspection.ParameterInfo = ci.GetParameters
		    
		    if pi.Ubound = types.Ubound then
		      //
		      // Not totally apparent: zero parameter constructors will enter the
		      // above IF statement and will not even enter the loop below. It will
		      // skip the loop and be returned right away. i.e. there is no parameter
		      // types to worry about checking.
		      //
		      
		      for i as Integer = 0 to pi.Ubound
		        if pi(i).ParameterType.Name <> types(i) then
		          continue for ci
		        end if
		      next
		      
		      return ci
		    end if
		  next
		  
		  return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetSequenceId(db As Database, seqName As String) As Integer
		  dim id as Integer = -1
		  dim rs as RecordSet
		  
		  select case db
		  case isa PostgreSQLDatabase
		    rs = db.SQLSelect("SELECT NEXTVAL('" + seqName + "')")
		    if db.Error then
		      raise new OrmRecordException("Could not retrieve next available id for sequence '" + seqName + "'", _
		      CurrentMethodName)
		    end if
		    
		  case else
		    raise new OrmRecordException("Unsupported database type", CurrentMethodName)
		  end select
		  
		  if not rs.EOF then
		    id = rs.IdxField(1).IntegerValue
		    
		  else
		    dim msg as String = "Can not get NEXTVAL for " + seqName
		    
		    #if targetweb then
		      if Session.Available then
		        msg = Session.RemoteAddress + ": " + msg
		      end if
		    #endif
		    
		    raise new OrmRecordException(msg, CurrentMethodName)
		  end if
		  
		  rs.Close
		  
		  return id
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RecordSetRowToDictionary(rs As RecordSet) As Dictionary
		  dim dict as new Dictionary
		  
		  dim fieldCount as integer = rs.FieldCount
		  for col as integer = 1 to fieldCount
		    dim fieldName as string = rs.IdxField(col).Name
		    dim fieldValue as variant = rs.IdxField(col).Value
		    dict.Value(fieldName) = fieldValue
		  next
		  
		  return dict
		  
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
