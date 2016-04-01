#tag Class
Class OrmDbPool
Implements AdapterPool
	#tag Method, Flags = &h21
		Private Sub CleanupOneReleased()
		  //
		  // Called by HandleCleanupTimerAction, and
		  // that already checked Released.Ubound
		  // It will also have entered the CriticalSection
		  //
		  
		  dim holder as PoolAdapter = Released.Pop
		  dim db as Database = holder.Db
		  
		  dim makeItGoAway as boolean = true // Assume this
		  
		  if db.Error or not db.Connect then
		    //
		    // Let it go away
		    //
		    
		  else
		    //
		    // Make sure it's not in the pool already
		    //
		    dim exists as boolean
		    for each poolItem as PoolAdapter in Pool
		      if poolItem.Db is db then
		        exists = true
		        exit for poolItem
		      end if
		    next
		    
		    //
		    // If that db connection already exists, we
		    // let this one go away
		    //
		    
		    if not exists then
		      //
		      // Eliminate any leftover transaction
		      //
		      db.Rollback
		      if not db.Error then
		        //
		        // It passed all the tests so
		        // put it back into the pool
		        //
		        Pool.Append holder
		        makeItGoAway = false
		      end if
		      
		    end if
		  end if
		  
		  if makeItGoAway then
		    holder.DetachFromPool
		    holder = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if mCleanupTimer isa Timer then
		    mCleanupTimer.Mode = Timer.ModeOff
		    RemoveHandler mCleanupTimer.Action, AddressOf HandleCleanupTimerAction
		    mCleanupTimer = nil
		  end if
		  
		  //
		  // Drain the pool
		  //
		  
		  for each holder as PoolAdapter in Released
		    holder.DetachFromPool
		  next
		  redim Released(-1)
		  
		  for each holder as PoolAdapter in Pool
		    holder.DetachFromPool
		  next
		  redim Pool(-1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FillPool()
		  if FillPoolTimer is nil then
		    //
		    // Maybe construction hasn't finished yet
		    //
		    FillPoolTimer = new Xojo.Core.Timer
		    FillPoolTimer.CallLater 1, AddressOf FillPool
		    
		  else
		    
		    PoolManagerCS.Enter
		    
		    dim minUbound as integer = MinimumInPool - 1
		    while Pool.Ubound < minUbound
		      dim holder as PoolAdapter = PoolAdapter(RaiseEvent CreateDbAdapter)
		      holder.AttachPool self
		      Pool.Append holder
		    wend
		    
		    PoolManagerCS.Leave
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get() As OrmDbAdapter
		  dim available as OrmDbAdapter 
		  
		  //
		  // We will do our best to get a connection
		  // If the available connection errors out, we will keep pulling
		  // from the pool or create a new one
		  //
		  
		  do
		    
		    available = GetNextAvailable
		    
		    dim isNew as boolean = (available is nil)
		    if isNew then
		      available = RaiseEvent CreateDbAdapter
		      PoolAdapter(available).AttachPool self
		    end if
		    
		    if not available.Db.Connect then
		      
		      RaiseEvent Error(available.Db)
		      PoolAdapter(available).DetachFromPool
		      available = nil
		      
		      if isNew then
		        //
		        // Nothing more to try
		        //
		        exit do
		      end if
		      
		    else
		      
		      //
		      // Successful connection
		      //
		      
		      RaiseEvent Assigned(OrmDbAdapter(available))
		      
		      //
		      // By using a Timer and cleaning some time after the last request, we avoid cleaning up connections 
		      // we could otherwise use during periods of high activity
		      //
		      
		      CleanupTimer.Period = if(Released.Ubound = -1, kCleanupTimerDefaultPeriod, kCleanupTimerReleasedPeriod)
		      CleanupTimer.Mode = Timer.ModeMultiple
		      CleanupTimer.Reset
		      
		    end if
		    
		  loop until available isa Object
		  
		  return available
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetNextAvailable() As OrmDbAdapter
		  dim available as PoolAdapter 
		  
		  PoolManagerCS.Enter
		  if Pool.Ubound <> -1 then
		    available = Pool.Pop
		  end if
		  PoolManagerCS.Leave
		  
		  return OrmDbAdapter(available)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleCleanupTimerAction(sender As Timer)
		  
		  //
		  // See if there are any released that need to be processed
		  //
		  
		  dim now as Xojo.Core.Date = if(MaximumAllowedAgeInMinutes > 0, Xojo.Core.Date.Now, nil)
		  dim nowSecs as double = if(now is nil, 0.0, now.SecondsFrom1970)
		  
		  PoolManagerCS.Enter
		  
		  if Released.Ubound <> -1 then
		    //
		    // Process these one at a time to avoid taking too much time
		    //
		    CleanupOneReleased
		    
		  else
		    
		    //
		    // Nothing in the Released set, so review the Pool
		    //
		    
		    //
		    // NOTE: We don't refill the pool here because we don't know how many are outstanding
		    // and we don't want to take the time to set up new connections that
		    // we may not need.
		    //
		    // If, because of errors and whatnot, we fall under the minimum, they
		    // will be replenished after the next Get/Release cycle.
		    //
		    
		    //
		    // Check the age of each connection and remove the older ones if needed
		    //
		    
		    if MaximumAllowedAgeInMinutes > 0 then
		      dim newPool() as PoolAdapter
		      dim sorter() as double
		      
		      for each holder as PoolAdapter in Pool
		        dim holderSecs as double = holder.CreateDate.SecondsFrom1970
		        dim secsAlive as double = nowSecs - holderSecs
		        dim minsAlive as double = secsAlive / 60.0
		        if minsAlive < MaximumAllowedAgeInMinutes then
		          newPool.Append holder
		          sorter.Append secsAlive
		        end if
		      next
		      
		      //
		      // Sort it so the oldest are at the bottom of the pool
		      //
		      sorter.SortWith newPool
		      Pool = newPool
		    end if
		    
		    //
		    // Move the pool back to the minimum
		    //
		    if Pool.Ubound >= MinimumInPool then
		      for i as integer = MinImumInPool to Pool.Ubound
		        PoolAdapter(Pool(i)).DetachFromPool
		      next
		      redim Pool(MinImumInPool - 1)
		    end if
		    
		    
		  end if
		  
		  PoolManagerCS.Leave
		  
		  //
		  // Adjust the Timer
		  //
		  if Released.Ubound <> -1 then
		    //
		    // Process again quickly
		    //
		    sender.Period = kCleanupTimerReleasedPeriod
		    sender.Reset
		    
		  elseif Pool.Ubound >= MinimumInPool then
		    sender.Period = kCleanupTimerDefaultPeriod
		    sender.Reset
		    
		  elseif Pool.Ubound = -1 or MaximumAllowedAgeInMinutes <= 0 then
		    //
		    // Nothing to check
		    //
		    sender.Mode = Timer.ModeOff
		    
		  else
		    //
		    // Adjust according to the age of the oldest Pool
		    // Would have been sorted so the oldest is at the bottom
		    //
		    dim howOld as double = (nowSecs - Pool(Pool.Ubound).CreateDate.SecondsFrom1970) / 60.0
		    dim whatsLeft as integer = MaximumAllowedAgeInMinutes - howOld
		    dim newPeriod as integer = whatsLeft * 60 * 1000
		    if newPeriod < kCleanupTimerDefaultPeriod then
		      newPeriod = kCleanupTimerDefaultPeriod
		    end if
		    
		    sender.Period = newPeriod
		    sender.Reset
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PoolManagerCS() As CriticalSection
		  if mPoolManagerCS is nil then
		    mPoolManagerCS = new CriticalSection
		  end if
		  
		  return mPoolManagerCS
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Release(holder As OrmDbAdapter)
		  if RaiseEvent Released(holder) then
		    return
		  end if
		  
		  Released.Append holder
		  
		  //
		  // These will be processed during cleanup
		  //
		  CleanupTimer.Period = kCleanupTimerReleasedPeriod
		  CleanupTimer.Mode = Timer.ModeMultiple
		  CleanupTimer.Reset
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Assigned(holder As OrmDbAdapter)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CreateDbAdapter() As OrmDbAdapter
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(db As Database)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Released(holder As OrmDbAdapter) As Boolean
	#tag EndHook


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mCleanupTimer is nil then
			    mCleanupTimer = new Timer
			    Addhandler mCleanupTimer.Action, AddressOf HandleCleanupTimerAction
			  end if
			  
			  return mCleanupTimer
			End Get
		#tag EndGetter
		Private CleanupTimer As Timer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private FillPoolTimer As Xojo.Core.Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		MaximumAllowedAgeInMinutes As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mCleanupTimer As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mMinimumInPool
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value < 0 then
			    value = 0
			  end if
			  
			  mMinimumInPool = value
			  FillPool
			End Set
		#tag EndSetter
		MinimumInPool As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mMinimumInPool As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPoolManagerCS As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Pool() As PoolAdapter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Released() As PoolAdapter
	#tag EndProperty


	#tag Constant, Name = kCleanupTimerDefaultPeriod, Type = Double, Dynamic = False, Default = \"10000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCleanupTimerReleasedPeriod, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant


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
			Name="MaximumAllowedAgeInMinutes"
			Visible=true
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumInPool"
			Visible=true
			Group="Behavior"
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
