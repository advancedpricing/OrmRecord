#tag Class
Protected Class OrmRecordTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  DestroyTmpData
		  CreateTmpData
		End Sub
	#tag EndEvent

	#tag Event
		Sub TearDown()
		  DestroyTmpData
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(err As RuntimeException, methodName As Text) As Boolean
		  #pragma unused err
		  #pragma unused methodName
		  
		  DestroyTmpData
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AutoRefreshTest()
		  //
		  // This tests refresh by extension
		  //
		  
		  dim db as Database = PSqlDatabase
		  
		  dim p1 as new OrmRecordTestPerson
		  p1.FirstName = "Tony"
		  p1.LastName = "Stark"
		  
		  p1.AutoRefresh = false
		  p1.Save(db)
		  Assert.IsNil(p1.DateOfBirth, "Date of Birth should be nil after save")
		  
		  p1.AutoRefresh = true
		  p1.SaveNew(db)
		  Assert.IsNotNil(p1.DateOfBirth, "Date of Birth should not be nil after save")
		  if Assert.Failed then
		    return
		  end if
		  Assert.AreEqual("2015-01-13", p1.DateOfBirth.SQLDate, "Dates don't match")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyFromTest()
		  //
		  // Same object test
		  //
		  dim p1 as new OrmRecordTestPerson
		  p1.FirstName = "Tony"
		  p1.LastName = "Stark"
		  
		  dim p2 as new OrmRecordTestPerson
		  p2.CopyFrom p1
		  
		  Assert.AreSame(p1.FirstName, p2.FirstName)
		  Assert.AreSame(p1.LastName, p2.LastName)
		  
		  //
		  // From subclass
		  //
		  dim p3 as new OrmRecordTestPersonSubclass
		  p2.FirstName = "Jane"
		  p2.CopyFrom p3
		  
		  Assert.AreSame(p3.FirstName, p2.FirstName)
		  
		  //
		  // To subclass
		  //
		  p2.FirstName = "Jerry"
		  p3.CopyFrom p2
		  
		  Assert.AreSame(p2.FirstName, p3.FirstName)
		  
		  //
		  // Siblings
		  //
		  dim sib as new OrmRecordTestPersonSibling
		  sib.CopyFrom p3
		  
		  Assert.AreSame(p3.FirstName, sib.FirstName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateTmpData()
		  dim db as PostgreSQLDatabase = OrmUnitTestHelpers.GetPSqlDatabase
		  PsqlDatabase = db
		  
		  db.SQLExecute(kCreateTmpData)
		  OrmUnitTestHelpers.RaiseExceptionOnDbError db
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DestroyTmpData()
		  dim db as Database = PSqlDatabase
		  PsqlDatabase = nil
		  
		  if db is nil then
		    db = OrmUnitTestHelpers.GetPSqlDatabase
		  end if
		  
		  db.SQLExecute kDestroyTmpData
		  
		  //
		  // We don't care if there is an error
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FromDictionaryTest()
		  Dim dob As New Date(1970, 2, 5)
		  
		  Dim d As New Dictionary( _
		  "FirstName" : "John", _
		  "LastName" : "Doe", _
		  "PostalCode" : 12345, _
		  "DateOfBirth" : dob, _
		  "NonProperty" : "something" _
		  )
		  
		  //
		  // First with ignoring errors
		  //
		  Dim p As New OrmRecordTestPerson
		  
		  Try
		    #pragma BreakOnExceptions off
		    p.FromDictionary(d, False)
		    #pragma BreakOnExceptions default
		  Catch err As RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    Assert.Fail("FromDictionary shouldn't have caused an exception", err.Message.ToText)
		    Return
		  End
		  
		  // p should have been updated
		  Assert.AreSame("John", p.FirstName)
		  Assert.AreSame("Doe", p.LastName)
		  Assert.AreEqual(12345, p.PostalCode)
		  Assert.AreSame(dob, p.DateOfBirth)
		  
		  //
		  // Should raise an error
		  //
		  p = New OrmRecordTestPerson
		  
		  Try
		    #pragma BreakOnExceptions off
		    p.FromDictionary(d)
		    #pragma BreakOnExceptions default
		    Assert.Fail("FromDictionary should have caused an exception")
		  Catch err As OrmRecordException
		    // Do nothing
		  End Try
		  
		  // p should be unchanged
		  Assert.AreSame("", p.FirstName)
		  Assert.AreSame("", p.LastName)
		  Assert.IsNil(p.DateOfBirth)
		  Assert.AreEqual(0, p.PostalCode)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetManyParamsTest()
		  dim db as Database = PSqlDatabase
		  
		  dim p1 as new OrmRecordTestPerson
		  p1.FirstName = "John"
		  p1.LastName = "Doe"
		  p1.Save(db)
		  
		  dim p2 as new OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Roe"
		  p2.Save(Db)
		  
		  dim recs() as OrmRecord = OrmRecord.GetMany(db, GetTypeInfo(OrmRecordTestPerson), "first_name = $1", "John")
		  Assert.AreEqual(0, recs.Ubound)
		  Assert.AreEqual("John", OrmRecordTestPerson(recs(0)).FirstName)
		  
		  dim params() as variant
		  params.Append "Jane"
		  
		  recs = OrmRecord.GetMany(db, GetTypeInfo(OrmRecordTestPerson), "first_name = $1", params)
		  Assert.AreEqual(0, recs.Ubound)
		  Assert.AreEqual("Jane", OrmRecordTestPerson(recs(0)).FirstName)
		  
		  recs = OrmRecord.GetMany(db, GetTypeInfo(OrmRecordTestPerson))
		  Assert.AreEqual(1, recs.Ubound)
		  
		  Exception err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    Assert.Fail(err.Reason)
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeAbortTest()
		  dim db as Database = PSqlDatabase
		  
		  Dim dob As New Date(2012, 1, 2, 3, 4, 5)
		  
		  Dim p1 As New OrmRecordTestPerson
		  p1.FirstName = "John"
		  p1.LastName = "Smith"
		  p1.PostalCode = 12345
		  
		  p1.Save db
		  
		  Dim p2 As New OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Abort" ' MergeField aborts when LastName = 'Abort'
		  p2.DateOfBirth = dob
		  p2.PostalCode = 54321
		  p2.SkipThis = "Whaaa?!"
		  p2.Save db
		  
		  Assert.IsFalse(p1.Merge(db, p2, False, False), "Merge should have aborted")
		  
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Smith", p1.LastName)
		  Assert.IsNil(p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeDeleteOtherTest()
		  dim db as Database = PSqlDatabase
		  
		  Dim dob As New Date(2012, 1, 2, 3, 4, 5)
		  
		  Dim p1 As New OrmRecordTestPerson
		  p1.FirstName = "John"
		  p1.LastName = "Smith"
		  p1.PostalCode = 12345
		  
		  p1.Save db
		  
		  Dim p2 As New OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Doe"
		  p2.DateOfBirth = dob
		  p2.PostalCode = 54321
		  p2.SkipThis = "Whaaa?!"
		  
		  p2.Save db
		  
		  Assert.IsTrue(p1.Merge(db, p2, True, False), "Delete other should have succeeded")
		  
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Doe", p1.LastName)
		  Assert.AreEqual(dob, p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeTest()
		  dim db as Database = PSqlDatabase
		  
		  Dim dob As New Date(2012, 1, 2, 3, 4, 5)
		  
		  Dim p1 As New OrmRecordTestPerson
		  p1.FirstName = "John"
		  p1.LastName = "Smith"
		  p1.PostalCode = 12345
		  
		  p1.Save db
		  
		  Dim p2 As New OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Doe"
		  p2.DateOfBirth = dob
		  p2.PostalCode = 54321
		  p2.SkipThis = "Whaaa?!"
		  p2.SkipMergeByAttribute = "Should skip"
		  
		  p2.Save db
		  
		  Assert.IsTrue(p1.Merge(db, p2, False, False), "Merge should not have aborted")
		  
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Doe", p1.LastName)
		  Assert.AreEqual(dob, p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  Assert.AreEqual("", p1.SkipMergeByAttribute)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MergeWithSaveTest()
		  dim db as Database = PSqlDatabase
		  
		  Dim dob As New Date(2012, 1, 2, 3, 4, 5)
		  
		  Dim p1 As New OrmRecordTestPerson
		  p1.FirstName = "John"
		  p1.LastName = "Smith"
		  p1.PostalCode = 12345
		  
		  p1.Save db
		  
		  Dim p2 As New OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Doe"
		  p2.DateOfBirth = dob
		  p2.PostalCode = 54321
		  p2.SkipThis = "Whaaa?!"
		  
		  p2.Save db
		  
		  Assert.IsTrue(p1.Merge(db, p2, False, True), "Save should have succeeded")
		  
		  // Before reloading the record
		  Assert.Message "Before reload"
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Doe", p1.LastName)
		  Assert.AreEqual(dob, p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  
		  Dim p1Id As Integer = p1.Id
		  p1 = New OrmRecordTestPerson(db, p1Id)
		  
		  // After reloading the record
		  Assert.Message "After reload"
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Doe", p1.LastName)
		  Assert.AreEqual(dob, p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveTest()
		  Dim p As New OrmRecordTestPerson
		  p.FirstName = "John"
		  
		  p.Save PSqlDatabase
		  Assert.IsTrue(1 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "1 record exists")
		  p.Delete PSqlDatabase
		  Assert.IsTrue(0 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "0 record exists")
		  Assert.IsTrue(p.IsNew, "Removed record should be marked new")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveAsNewTest()
		  Dim p As New OrmRecordTestPerson
		  p.FirstName = "John"
		  
		  p.Save PSqlDatabase
		  Assert.IsTrue(1 = p.Id, "Id = 1 is: " + p.Id.ToText)
		  Assert.IsTrue(1 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "1 record exists")
		  
		  p.SaveNew PSqlDatabase
		  Assert.IsTrue(2 = p.Id, "Id = 2 is: " + p.Id.ToText)
		  Assert.IsTrue(2 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "2 records exists")
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveChangePropertiesOnlyTest()
		  dim db as Database = PSqlDatabase
		  
		  dim p1 as new OrmRecordTestPerson
		  p1.AutoRefresh = true
		  
		  p1.Save(db)
		  Assert.IsFalse(db.Error, "Initial save: " + db.ErrorMessage.ToText)
		  Assert.IsNotNil(p1.DateOfBirth)
		  
		  p1.Delete(db)
		  
		  dim now as new Date
		  p1 = new OrmRecordTestPerson
		  p1.DateOfBirth = now
		  p1.Save(db)
		  Assert.AreEqual(now.SQLDate, p1.DateOfBirth.SQLDate)
		  Assert.AreEqual("", p1.FirstName, "First name should be empty")
		  
		  p1.Delete(db)
		  
		  p1 = new OrmRecordTestPerson
		  p1.AutoRefresh = true
		  
		  dim p2 as new OrmRecordTestPerson
		  p2.AutoRefresh = true
		  
		  p1.FirstName = "John"
		  p1.LastName = "Doe"
		  p1.Save(db)
		  
		  p2.FirstName = "Wendy"
		  p2.LastName = "Smith"
		  p2.Save(db)
		  
		  p1.CopyFrom p2
		  p1.Save(db)
		  Assert.AreEqual(p2.FirstName, p1.FirstName, "First names should match")
		  Assert.AreEqual(p2.LastName, p1.LastName, "Last names should match")
		  
		  p1.SaveNew(db)
		  Assert.AreEqual(p2.FirstName, p1.FirstName, "First names should match after save as new")
		  Assert.AreEqual(p2.LastName, p1.LastName, "Last names should match after save as new")
		  
		  dim id as Int64 = p1.Id
		  dim sql as string = "SELECT id, first_name FROM tmp_person WHERE id=" + str(id)
		  dim rs as RecordSet = db.SQLSelect(sql)
		  
		  dim p3 as new OrmRecordTestPerson(rs)
		  p3.AutoRefresh = true
		  
		  Assert.AreEqual(p1.FirstName, p3.FirstName, "Loaded first name does not match")
		  Assert.AreEqual("", p3.LastName, "Loaded last name should be empty")
		  
		  p3.FirstName = "John"
		  p3.Save(db)
		  Assert.AreEqual("John", p3.FirstName, "After-save first name should match")
		  Assert.AreEqual(p1.LastName, p3.LastName, "After-save last name should match")
		  
		  p1.Refresh(db)
		  Assert.AreEqual(p3.FirstName, p1.FirstName, "Refreshing p1 should have gotten the latest values")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveExistingTest()
		  Dim p1 As New OrmRecordTestPerson
		  p1.FirstName = "John"
		  
		  p1.Save PSqlDatabase
		  Assert.IsTrue(1 = p1.Id, "Id = 1 is: " + p1.Id.ToText)
		  Assert.IsTrue(1 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "1 record exists")
		  
		  p1.FirstName = "Joe"
		  p1.Save PSqlDatabase
		  Assert.AreEqual(CType(1, Int64), p1.Id, "ID does not match")
		  Assert.AreEqual("Joe", p1.FirstName, "First name does not match")
		  
		  Dim p2 As New OrmRecordTestPerson(PSqlDatabase, p1.Id)
		  Assert.AreEqual(CType(1, Int64), p2.Id, "ID does not match after reload")
		  Assert.AreEqual("Joe", p2.FirstName, "First name does not match after reload")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveGetTest()
		  Dim p As New OrmRecordTestPerson
		  p.FirstName = "John"
		  p.LastName = "Doe"
		  p.DateOfBirth = New Date(2010, 1, 2, 3, 4, 5)
		  p.PostalCode = 44444
		  
		  p.Save PSqlDatabase
		  Assert.IsTrue(p.Id > 0)
		  
		  Dim p2 As New OrmRecordTestPerson(PSqlDatabase, p.Id)
		  Assert.AreEqual(p.FirstName, p2.FirstName)
		  Assert.AreEqual(p.LastName, p2.LastName)
		  Assert.AreEqual(p.DateOfBirth, p2.DateOfBirth)
		  Assert.AreEqual(p.PostalCode, p2.PostalCode)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToDictionaryTest()
		  Dim p As New OrmRecordTestPerson
		  
		  Dim dob As New Date(1970, 2, 5)
		  
		  p.DateOfBirth = dob
		  p.FirstName = "John"
		  p.LastName = "Doe"
		  p.PostalCode = 12345
		  
		  Dim d As Dictionary
		  Try
		    d = p.ToDictionary()
		  Catch err As RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    Assert.Fail("Getting a Dictionary raised an exception", err.Message.ToText)
		    Return
		  End
		  
		  Assert.IsNotNil(d)
		  If d Is Nil Then Return
		  
		  Assert.AreSame(dob.SQLDateTime, Date(d.Lookup("DateOfBirth", New Date)).SQLDateTime, "DOB")
		  Assert.AreSame("John", d.Lookup("FirstName", "").StringValue, "FirstName")
		  Assert.AreSame("Doe", d.Lookup("LastName", "").StringValue, "LastName")
		  Assert.AreEqual(12345, d.Lookup("PostalCode", 0).IntegerValue, "PostalCode")
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mDb As SQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PsqlDatabase As PostgreSQLDatabase
	#tag EndProperty


	#tag Constant, Name = kCreateTmpData, Type = String, Dynamic = False, Default = \"CREATE TABLE tmp_person (\n  id SERIAL PRIMARY KEY\x2C\n  first_name VARCHAR(40)\x2C\n  last_name VARCHAR(40)\x2C\n  date_of_birth TIMESTAMP DEFAULT \'2015-01-13\'::TIMESTAMP\x2C\n  postal_code INTEGER\x2C\n  skip_this VARCHAR(10)\x2C\n  skip_merge_by_attribute VARCHAR(20)\n) ;\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDestroyTmpData, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS tmp_person;", Scope = Private
	#tag EndConstant


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
