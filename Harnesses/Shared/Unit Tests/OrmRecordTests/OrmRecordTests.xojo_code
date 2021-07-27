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
		Function UnhandledException(err As RuntimeException, methodName As String) As Boolean
		  #pragma unused err
		  #pragma unused methodName
		  
		  DestroyTmpData
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AutoRefreshTest()
		  
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
		  p1.Save(db, true)
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
		Sub GetManyByTemplateTest()
		  dim db as Database = PsqlDatabase
		  
		  dim dob as new Date(2001, 1, 1)
		  
		  dim p as new OrmRecordTestPerson
		  p.FirstName = "John"
		  p.LastName = "Doe"
		  p.DateOfBirth = dob
		  p.SomeBoolean1 = true
		  p.SomeText1 = "M"
		  p.SomeText2 = "same"
		  p.Save db
		  
		  p = new OrmRecordTestPerson
		  p.FirstName = "Jane"
		  p.LastName = "Doe"
		  p.DateOfBirth = dob
		  p.SomeBoolean1 = false
		  p.SomeText1 = "F"
		  p.SomeText2 = "same"
		  p.Save db
		  
		  dim template as OrmRecordTestPerson
		  dim matches() as OrmRecord
		  
		  template = new OrmRecordTestPerson
		  template.LastName = "Doe"
		  matches = OrmRecord.GetManyByTemplate(db, template)
		  Assert.AreEqual(1, CType(matches.Ubound, Integer), "Last Name")
		  
		  template = new OrmRecordTestPerson
		  template.FirstName = "Jane"
		  template.LastName = "Doe"
		  matches = OrmRecord.GetManyByTemplate(db, template)
		  Assert.AreEqual(0, CType(matches.Ubound, Integer), "First Name, Last Name")
		  
		  template = new OrmRecordTestPerson
		  template.FirstName = "Jane"
		  template.DateOfBirth = dob
		  matches = OrmRecord.GetManyByTemplate(db, template)
		  Assert.AreEqual(0, CType(matches.Ubound, Integer), "First Name, DOB")
		  
		  template = new OrmRecordTestPerson
		  template.SomeBoolean1 = True
		  template.DateOfBirth = dob
		  matches = OrmRecord.GetManyByTemplate(db, template)
		  Assert.AreEqual(0, CType(matches.Ubound, Integer), "SomeBoolean1, DOB")
		  
		  template = new OrmRecordTestPerson
		  template.DateOfBirth = dob
		  matches = OrmRecord.GetManyByTemplate(db, template)
		  Assert.AreEqual(1, CType(matches.Ubound, Integer), "DOB")
		  
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
		  dim ubCompare as Int32 = 0
		  Assert.AreEqual(ubCompare, recs.Ubound)
		  Assert.AreEqual("John", OrmRecordTestPerson(recs(0)).FirstName)
		  
		  dim params() as variant
		  params.Append "Jane"
		  
		  recs = OrmRecord.GetMany(db, GetTypeInfo(OrmRecordTestPerson), "first_name = $1", params)
		  Assert.AreEqual(ubCompare, recs.Ubound)
		  Assert.AreEqual("Jane", OrmRecordTestPerson(recs(0)).FirstName)
		  
		  recs = OrmRecord.GetMany(db, GetTypeInfo(OrmRecordTestPerson))
		  ubCompare = 1
		  Assert.AreEqual(ubCompare, recs.Ubound)
		  
		  Exception err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    Assert.Fail(err.Reason)
		    
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertManyTest()
		  const kNegOne as Int32 = -1
		  
		  dim db as Database = PSqlDatabase
		  
		  dim recs() as OrmRecordTestPerson
		  
		  for i as integer = 1 to 100
		    dim rec as new OrmRecordTestPerson
		    rec.FirstName = str(i)
		    rec.LastName = "Jones"
		    recs.Append rec
		  next
		  
		  dim inserted() as OrmRecordTestPerson
		  dim failed() as OrmRecordTestPerson
		  OrmRecordTestPerson.InsertMany db, recs, false, false, inserted, failed
		  
		  Assert.AreEqual recs.Ubound, inserted.Ubound, "Inserted array doesn't match"
		  Assert.AreEqual kNegOne, failed.Ubound, "Failed array doesn't match"
		  
		  for each rec as OrmRecordTestPerson in recs
		    Assert.AreNotEqual OrmRecord.NewId, rec.Id, "Id should have been set"
		    dim newRec as new OrmRecordTestPerson(db, rec.Id)
		    Assert.AreEqual newRec.FirstName, rec.FirstName, "Didn't seem to save"
		    Assert.IsTrue inserted.IndexOf(rec) <> -1, "Record not found in inserted array"
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntrinsicTypeTest()
		  dim db as Database = PSqlDatabase
		  
		  Dim p1 As New OrmRecordTestPerson
		  p1.AutoRefresh = true
		  
		  p1.FirstName = "John"
		  p1.LastName = "Smith"
		  p1.SomeBoolean1 = true
		  p1.Save db
		  
		  Assert.IsTrue p1.SomeBoolean1
		  Assert.IsNil p1.SomeBoolean2
		  
		  p1.SomeBoolean2 = true
		  p1.Save db
		  
		  Assert.IsTrue(p1.SomeBoolean2)
		  
		  dim b as OrmBoolean = true
		  dim v as variant = b
		  Assert.IsTrue(v.BooleanValue)
		  Assert.IsTrue(v)
		  
		  b = false
		  v = b
		  Assert.IsFalse(v.BooleanValue)
		  Assert.IsFalse(v)
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
		  p1.SomeDouble1 = 999999.123
		  p1.Save db
		  
		  Dim p2 As New OrmRecordTestPerson
		  p2.FirstName = "Jane"
		  p2.LastName = "Doe"
		  p2.DateOfBirth = dob
		  p2.PostalCode = 54321
		  p2.SkipThis = "Whaaa?!"
		  p2.SkipMergeByAttribute = "Should skip"
		  p2.SomeBoolean1 = false
		  
		  p2.Save db
		  
		  Assert.IsTrue(p1.Merge(db, p2, False, False), "Merge should not have aborted")
		  
		  Assert.AreEqual("John", p1.FirstName)
		  Assert.AreEqual("Doe", p1.LastName)
		  Assert.AreEqual(dob, p1.DateOfBirth)
		  Assert.AreEqual(12345, p1.PostalCode)
		  Assert.AreEqual("", p1.SkipThis)
		  Assert.AreEqual("", p1.SkipMergeByAttribute)
		  Assert.IsFalse(p1.SomeBoolean1)
		  Assert.AreEqual(999999.123, p1.SomeDouble1.NativeValue, 0.1)
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
		Sub ReadOnlyModelTest()
		  dim db as Database = PSqlDatabase
		  
		  dim p1 as new OrmRecordTestPerson
		  p1.AutoRefresh = true
		  
		  p1.FirstName = "John"
		  p1.LastName = "Doe"
		  
		  p1.Save(db)
		  
		  p1.ClassIsReadOnly = true
		  Assert.IsTrue p1.IsReadOnly, "Class was not marked 'read-only'"
		  
		  #pragma BreakOnExceptions false
		  try
		    p1.Save db
		    Assert.Fail "Read-only model cannot save!"
		  catch err as OrmRecordException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  dim rs as RecordSet = db.SQLSelect("SELECT * FROM " + p1.DatabaseTableName)
		  p1.Constructor(rs)
		  Assert.AreEqual rs.Field("first_name").StringValue, p1.FirstName, "First name does not match"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReadOnlyPropertyTest()
		  dim db as Database = PSqlDatabase
		  
		  dim p1 as new OrmRecordTestPerson
		  p1.AutoRefresh = true
		  
		  p1.FirstName = "John"
		  p1.LastName = "Doe"
		  
		  p1.Save(db)
		  
		  dim default as integer = p1.ReadOnlyProp
		  
		  p1.ReadOnlyProp = 1000000
		  p1.Save db
		  
		  Assert.AreEqual default, p1.ReadOnlyProp, "Read-only property should not have been overwritten"
		  
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
		  p.SomeDouble1 = 999999.123
		  
		  p.Save PSqlDatabase
		  Assert.IsTrue(1 = p.Id, "Id = 1 is: " + p.Id.ToText)
		  Assert.IsTrue(1 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "1 record exists")
		  Assert.AreEqual(999999.123, p.SomeDouble1, 0.1)
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.AsNew), Integer(p.LastSaveType), "Not marked as new"
		  
		  p.Save PSqlDatabase, true
		  Assert.IsTrue(2 = p.Id, "Id = 2 is: " + p.Id.ToText)
		  Assert.IsTrue(2 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "2 records exists")
		  Assert.AreEqual(999999.123, p.SomeDouble1, 0.1)
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.AsNew), Integer(p.LastSaveType), "Not marked as new after AsNew"
		  
		  //
		  // Make sure the Id is reverted after a faulty save
		  //
		  dim origId as integer = p.Id
		  p.NotNullInt = 0 // Will force null
		  #pragma BreakOnExceptions false
		  try
		    p.Save PSqlDatabase, true
		    Assert.Fail "Should not have been able to save a NULL"
		    
		  catch err as OrmRecordException
		    Assert.AreEqual origId, p.Id
		    
		    p.NotNullInt = 3
		    p.Save PSqlDatabase, true
		    Assert.AreEqual 4, p.Id, "Id = 4 is: " + p.Id.ToString // Will have skipped 3
		    
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveBlankRecordTest()
		  dim db as Database = PsqlDatabase
		  
		  Dim p As New OrmRecordTestPerson
		  p.Save db
		  
		  Assert.AreNotEqual OrmRecord.NewId, p.Id
		  
		  dim p1 as OrmRecordTestPerson = new OrmRecordTestPerson(db, p.Id)
		  
		  Assert.AreEqual p.Id, p1.Id
		  
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
		  
		  p1.Save(db, true)
		  Assert.AreEqual(p2.FirstName, p1.FirstName, "First names should match after save as new")
		  Assert.AreEqual(p2.LastName, p1.LastName, "Last names should match after save as new")
		  
		  dim id as Integer = p1.Id
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
		  p1.LastName = "Doe"
		  p1.SomeText1 = "Hi"
		  p1.Save PSqlDatabase
		  Assert.IsTrue(1 = p1.Id, "Id = 1 is: " + p1.Id.ToText)
		  Assert.IsTrue(1 = OrmUnitTestHelpers.Count(PSqlDatabase, OrmRecordTestPerson.kTableName), "1 record exists")
		  Assert.AreEqual("Hi", p1.SomeText1.NativeValue)
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.AsNew), Integer(p1.LastSaveType), "Not marked as new"
		  
		  p1.FirstName = "Joe"
		  p1.SomeDouble1 = 999999.123
		  p1.SomeText1 = "hi"
		  p1.SomeText2 = "Hi there"
		  p1.Save PSqlDatabase
		  Assert.AreEqual(1, p1.Id, "ID does not match")
		  Assert.AreEqual("Joe", p1.FirstName, "First name does not match")
		  Assert.AreEqual(999999.123, p1.SomeDouble1, 0.1, "SomeDouble1 does not match")
		  Assert.AreSame("hi", p1.SomeText1.NativeValue, "SomeText1 does not match")
		  Assert.AreSame("Hi there", p1.SomeText2.NativeValue, "SomeText2 does not match")
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.AsExisting), Integer(p1.LastSaveType), "Not marked as existing"
		  
		  Dim p2 As New OrmRecordTestPerson(PSqlDatabase, p1.Id)
		  Assert.AreEqual(1, p2.Id, "ID does not match after reload")
		  Assert.AreEqual("Joe", p2.FirstName, "First name does not match after reload")
		  Assert.AreEqual(999999.123, p2.SomeDouble1, 0.1, "SomeDouble1 does not match after reload")
		  Assert.AreSame("hi", p1.SomeText1.NativeValue, "SomeText1 does not match after reload")
		  Assert.AreSame("Hi there", p1.SomeText2.NativeValue, "SomeText2 does not match after reload")
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.None), Integer(p2.LastSaveType), "Not marked as no save type"
		  
		  p1.SomeText1 = nil
		  p1.Save PSqlDatabase
		  
		  p2 = new OrmRecordTestPerson(PSqlDatabase, p1.Id)
		  Assert.IsNil(p2.SomeText1, "SomeText1 not nil after reload")
		  
		  //
		  // Make sure that changing one property does not affect the others
		  //
		  p2 = new OrmRecordTestPerson
		  p2.Id = p1.Id
		  p2.FirstName = "Bobby"
		  p2.Save PSqlDatabase
		  Assert.AreEqual("", p2.LastName, "p2.LastName should be empty")
		  Assert.AreEqual Integer(OrmRecord.SaveTypes.AsExisting), Integer(p2.LastSaveType), "Not marked as existing 2"
		  
		  p2.Refresh PSqlDatabase
		  Assert.AreEqual("Bobby", p2.FirstName, "FirstName should not have channged after Refresh")
		  Assert.AreEqual(p1.LastName, p2.LastName, "LastName should have reloaded after Refresh")
		  
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


	#tag Constant, Name = kCreateTmpData, Type = String, Dynamic = False, Default = \"CREATE TABLE tmp_person (\n  id SERIAL PRIMARY KEY\x2C\n  first_name VARCHAR(40)\x2C\n  last_name VARCHAR(40)\x2C\n  date_of_birth TIMESTAMP DEFAULT \'2015-01-13\'::TIMESTAMP\x2C\n  postal_code INTEGER\x2C\n  skip_this VARCHAR(10)\x2C\n  skip_merge_by_attribute VARCHAR(20)\x2C\n  some_boolean1 BOOLEAN\x2C\n  some_boolean2 BOOLEAN\x2C\n  some_double1 NUMERIC(12\x2C2)\x2C\n  some_double2 NUMERIC(12\x2C 2)\x2C\n  some_text1 VARCHAR(256)\x2C\n  some_text2 VARCHAR(256)\x2C\n  not_null_int INTEGER NOT NULL DEFAULT 1\n) ;\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDestroyTmpData, Type = String, Dynamic = False, Default = \"DROP TABLE IF EXISTS tmp_person;", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
