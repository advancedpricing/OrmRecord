#tag Class
Protected Class OrmTestController
Inherits TestController
	#tag Event
		Sub InitializeTestGroups()
		  // Instantiate TestGroup subclasses here so that they can be run
		  
		  Dim group As TestGroup
		  
		  #pragma BreakOnExceptions false
		  
		  group = New XojoUnitTests(Self, "Assertion")
		  group.IncludeGroup = false
		  group = New XojoUnitFailTests(Self, "Always Fail")
		  group.IncludeGroup = false
		  
		  group = new OrmDbAdapterTests(self, "OrmDbAdapter")
		  group = new OrmDbTransactionTests(self, "OrmDbTransaction")
		  group = new OrmFieldSubclassesTests(self, "OrmFieldSubclasses")
		  
		  group = new OrmMSSQLDbAdapterTests(self, "OrmMSSQLDbAdapter")
		  try
		    call OrmUnitTestHelpers.CreateMSSQLDbAdapter
		  catch err as RuntimeException
		    group.IncludeGroup = false
		  end try
		  
		  group = new OrmMySQLDbAdapterTests(self, "OrmMySQLDbAdapter")
		  try
		    call OrmUnitTestHelpers.CreateMySQLDbAdapter
		  catch err as RuntimeException
		    group.IncludeGroup = false
		  end try
		  
		  group = new OrmPostgreSQLDbAdapterTests(self, "OrmPostgreSQLDbAdapter")
		  try
		    call OrmUnitTestHelpers.CreatePostgreSQLDbAdapter
		  catch err as RuntimeException
		    group.IncludeGroup = false
		  end try
		  
		  group = new OrmSQLiteDbAdapterTests(self, "OrmSQLiteDbAdapter")
		  try
		    call OrmUnitTestHelpers.CreateSQLiteDbAdapter
		  catch err as RuntimeException
		    group.IncludeGroup = false
		  end try
		  
		  #pragma BreakOnExceptions default
		  
		  group = new OrmRecordTests(self, "OrmRecord")
		  group = new NullOnEmptyConverterTests(self, "NullOnEmptyConverter")
		  group = new NullOnZeroConverterTests(self, "NullOnZeroConverter")
		  group = new YNToBooleanConverterTests(self, "YNToBooleanConverter")
		  
		End Sub
	#tag EndEvent


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="GroupCount"
			Group="Behavior"
			Type="Integer"
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
			Name="PassedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunGroupCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedCount"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
