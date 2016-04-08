#tag Class
Protected Class OrmFieldSubclassesTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BooleanTest()
		  dim v as OrmBoolean
		  
		  v = true
		  Assert.IsTrue(v, "Value should be true")
		  v = false
		  Assert.IsFalse(v, "Value should be false")
		  dim s as string = v
		  Assert.AreEqual("false", s, "String value should be 'false'")
		  v = nil
		  Assert.IsNil(v, "Object should be nil again")
		  
		  v = true
		  if v and true then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "And failed against Boolean"
		  end if
		  
		  if v and v then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "And failed against OrmBoolean"
		  end if
		  
		  if true and v then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "AndRight failed against Boolean" 
		  end if
		  
		  if v or true then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "Or failed against Boolean"
		  end if
		  
		  if v or v then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "Or failed against OrmBoolean"
		  end if
		  
		  if true or v then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "OrRight failed against Boolean" 
		  end if
		  
		  if v xor false then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "Xor failed against Boolean"
		  end if
		  
		  dim vFalse as OrmBoolean = false
		  if v xor vFalse then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "Xor failed against OrmBoolean"
		  end if
		  
		  if false xor v then
		    Assert.Pass "Was true"
		  else
		    Assert.Fail "XorRight failed against Boolean" 
		  end if
		  
		  v = not v
		  Assert.IsFalse v, "Not did not work"
		  
		  //
		  // Using NativeValue should raise an exception
		  //
		  #pragma BreakOnExceptions false
		  try
		    v.NativeValue = true
		    Assert.Fail "Using NativeValue should have raised an exception"
		  catch err as UnsupportedOperationException
		    Assert.Pass "Using NativeValue raised an exception"
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CurrencyTest()
		  dim v as OrmCurrency
		  
		  dim c as currency = 1.23
		  dim d as double = 3.67
		  dim i as integer = 5
		  
		  v = c
		  Assert.AreEqual(c, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(d, CType(v.NativeValue, double))
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer))
		  
		  v = 1.23
		  dim adder as double = 0.77
		  dim subtracter as double = 0.23
		  
		  dim c2 as OrmCurrency
		  dim compare as currency
		  dim t as Currency
		  
		  compare = 2.0
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmCurrency"
		  
		  compare = 1.0
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = 0.23 - 1.23
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 1.0
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmCurrency"
		  
		  dim multiplier as double = 2.5
		  v = 5.0
		  compare = 5.0 * 2.5
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmCurrency"
		  
		  dim divider as double = 2.0
		  v = 5.0
		  compare = 5.0 / divider
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = divider / 5.0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5.0 / divider
		  Assert.AreEqual compare, t, "Divide failed against OrmCurrency"
		  
		  v = 5.0
		  compare = 5.0 / divider
		  
		  compare = 5.0 \ divider
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = divider \ 5.0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5.0 \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmCurrency"
		  
		  v = 5.0
		  t = -v
		  compare = -5.0
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 5.0
		  compare = 1.0
		  t = v mod 2.0
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2.0
		  t = 5.0 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5.0
		  c2 = 2.0
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmCurrency"
		  
		  c = 5.0
		  v = c
		  Assert.AreSame c.ToText, v.ToText, "ToText failed"
		  
		End Sub
	#tag EndMethod

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
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleTest()
		  dim v as OrmDouble
		  
		  dim d as double = 1.23
		  dim c as Double = 5.67
		  dim i as integer = 8
		  
		  v = d
		  Assert.AreEqual(d, v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(c, CType(v.NativeValue, Double))
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer))
		  
		  dim oc as OrmDouble = v
		  dim toDouble as double = oc
		  Assert.AreEqual(v.NativeValue, toDouble, 0.1)
		  
		  v = 1.23
		  dim adder as double = 0.77
		  dim subtracter as double = 0.23
		  
		  dim c2 as OrmDouble
		  dim compare as double
		  dim t as Double
		  
		  compare = 2.0
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmDouble"
		  
		  compare = 1.0
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = 0.23 - 1.23
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 1.0
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmDouble"
		  
		  dim multiplier as double = 2.5
		  v = 5.0
		  compare = 5.0 * 2.5
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmDouble"
		  
		  dim divider as double = 2.0
		  v = 5.0
		  compare = 5.0 / divider
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = divider / 5.0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5.0 / divider
		  Assert.AreEqual compare, t, "Divide failed against OrmDouble"
		  
		  v = 5.0
		  compare = 5.0 / divider
		  
		  compare = 5.0 \ divider
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = divider \ 5.0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5.0 \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmDouble"
		  
		  v = 5.0
		  t = -v
		  compare = -5.0
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 5.0
		  compare = 1.0
		  t = v mod 2.0
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2.0
		  t = 5.0 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5.0
		  c2 = 2.0
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmCurrency"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int32Test()
		  dim v as OrmInt32
		  
		  dim i as Int32 = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, Int32), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, Int32), v.NativeValue)
		  
		  v = 10
		  dim adder as Int32 = 1
		  dim subtracter as Int32 = 1
		  
		  dim c2 as OrmInt32
		  dim compare as Int32
		  dim t as Int32
		  
		  compare = 11
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmInt32"
		  
		  compare = 9
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = -9
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 9
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmInt32"
		  
		  dim multiplier as Int32 = 2
		  v = 10
		  compare = 20
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmInt32"
		  
		  dim divider as Int32 = 2
		  v = 10
		  compare = 5
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = 0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5
		  Assert.AreEqual compare, t, "Divide failed against OrmInt32"
		  
		  v = 10
		  compare = 5
		  
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = 0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmInt32"
		  
		  v = 5
		  t = -v
		  compare = -5
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 1
		  t = &hFFFFFFFF
		  c2 = t
		  compare = 1
		  Assert.AreEqual compare, v and t, "And failed"
		  Assert.AreEqual compare, t and v, "AndRight failed"
		  Assert.AreEqual compare, v and c2, "And failed against OrmInt32"
		  
		  compare = &hFFFFFFFF
		  Assert.AreEqual compare, v or t, "Or failed"
		  Assert.AreEqual compare, t or v, "OrRight failed"
		  Assert.AreEqual compare, v or c2, "Or failed against OrmInt32"
		  
		  v = &hFFFF0000
		  t = &h0001FFFE
		  c2 = t
		  compare = &hFFFF0000 xor t
		  Assert.AreEqual compare, v xor t, "Xor failed"
		  Assert.AreEqual compare, t xor v, "XorRight failed"
		  Assert.AreEqual compare, v xor c2, "Xor failed against OrmInt32"
		  
		  i = 5
		  compare = not i
		  v = i
		  v = not v
		  Assert.AreEqual compare, v.NativeValue, "Not failed"
		  
		  v = 5
		  compare = 1
		  t = v mod 2
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2
		  t = 5 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5
		  c2 = 2
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmInt32"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int64Test()
		  dim v as OrmInt64
		  
		  dim i as Int64 = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, Int64), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, Int64), v.NativeValue)
		  
		  v = 10
		  dim adder as Int64 = 1
		  dim subtracter as Int64 = 1
		  
		  dim c2 as OrmInt64
		  dim compare as Int64
		  dim t as Int64
		  
		  compare = 11
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmInt64"
		  
		  compare = 9
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = -9
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 9
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmInt64"
		  
		  dim multiplier as Int64 = 2
		  v = 10
		  compare = 20
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmInt64"
		  
		  dim divider as Int64 = 2
		  v = 10
		  compare = 5
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = 0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5
		  Assert.AreEqual compare, t, "Divide failed against OrmInt64"
		  
		  v = 10
		  compare = 5
		  
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = 0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmInt64"
		  
		  v = 5
		  t = -v
		  compare = -5
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 1
		  t = &hFFFFFFFF
		  c2 = t
		  compare = 1
		  Assert.AreEqual compare, v and t, "And failed"
		  Assert.AreEqual compare, t and v, "AndRight failed"
		  Assert.AreEqual compare, v and c2, "And failed against OrmInt64"
		  
		  compare = &hFFFFFFFF
		  Assert.AreEqual compare, v or t, "Or failed"
		  Assert.AreEqual compare, t or v, "OrRight failed"
		  Assert.AreEqual compare, v or c2, "Or failed against OrmInt64"
		  
		  v = &hFFFF0000
		  t = &h0001FFFE
		  c2 = t
		  compare = &hFFFF0000 xor t
		  Assert.AreEqual compare, v xor t, "Xor failed"
		  Assert.AreEqual compare, t xor v, "XorRight failed"
		  Assert.AreEqual compare, v xor c2, "Xor failed against OrmInt64"
		  
		  i = 5
		  compare = not i
		  v = i
		  v = not v
		  Assert.AreEqual compare, v.NativeValue, "Not failed"
		  
		  v = 5
		  compare = 1
		  t = v mod 2
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2
		  t = 5 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5
		  c2 = 2
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmInt64"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerTest()
		  dim v as OrmInteger
		  
		  dim i as integer = 8
		  dim d as double = 1.23
		  dim c as currency = 5.67
		  
		  v = i
		  Assert.AreEqual(i, v.NativeValue)
		  
		  v = d
		  Assert.AreEqual(CType(d, integer), v.NativeValue)
		  
		  v = c
		  Assert.AreEqual(CType(c, integer), v.NativeValue)
		  
		  v = 10
		  dim adder as Integer = 1
		  dim subtracter as Integer = 1
		  
		  dim c2 as OrmInteger
		  dim compare as Integer
		  dim t as Integer
		  
		  compare = 11
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmInteger"
		  
		  compare = 9
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = -9
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 9
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmInteger"
		  
		  dim multiplier as Integer = 2
		  v = 10
		  compare = 20
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmInteger"
		  
		  dim divider as Integer = 2
		  v = 10
		  compare = 5
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = 0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5
		  Assert.AreEqual compare, t, "Divide failed against OrmInteger"
		  
		  v = 10
		  compare = 5
		  
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = 0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmInteger"
		  
		  v = 5
		  t = -v
		  compare = -5
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 1
		  t = &hFFFFFFFF
		  c2 = t
		  compare = 1
		  Assert.AreEqual compare, v and t, "And failed"
		  Assert.AreEqual compare, t and v, "AndRight failed"
		  Assert.AreEqual compare, v and c2, "And failed against OrmInteger"
		  
		  compare = &hFFFFFFFF
		  Assert.AreEqual compare, v or t, "Or failed"
		  Assert.AreEqual compare, t or v, "OrRight failed"
		  Assert.AreEqual compare, v or c2, "Or failed against OrmInteger"
		  
		  v = &hFFFF0000
		  t = &h0001FFFE
		  c2 = t
		  compare = &hFFFF0000 xor t
		  Assert.AreEqual compare, v xor t, "Xor failed"
		  Assert.AreEqual compare, t xor v, "XorRight failed"
		  Assert.AreEqual compare, v xor c2, "Xor failed against OrmInteger"
		  
		  i = 5
		  compare = not i
		  v = i
		  v = not v
		  Assert.AreEqual compare, v.NativeValue, "Not failed"
		  
		  v = 5
		  compare = 1
		  t = v mod 2
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2
		  t = 5 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5
		  c2 = 2
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmInteger"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntrinsicTypeBaseTest()
		  dim v as OrmDouble = 5.87
		  
		  Assert.IsTrue(v > 0.0)
		  
		  v = 1.23
		  dim c as OrmCurrency = 0.5
		  Assert.IsTrue(v > c, "Compare to another OrmIntrinsicType")
		  
		  c = nil
		  Assert.IsTrue(v > c, "Compare to nil")
		  
		  #pragma BreakOnExceptions false
		  try
		    dim b as OrmBoolean = false
		    Assert.IsFalse(v > b, "Boolean?")
		  catch err as TypeMismatchException
		    Assert.Pass("Comparison to boolean raised an exception")
		  end try
		  #pragma BreakOnExceptions default
		  
		  v = nil
		  Assert.IsTrue(v = nil)
		  
		  dim oi as OrmInteger = 1
		  dim var as variant = oi
		  dim s as string = var.StringValue
		  var = 1
		  dim compare as string = var.StringValue
		  Assert.AreSame compare, s, "Could not convert to string"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SingleTest()
		  dim v as OrmSingle
		  
		  dim s as single = 1.23
		  dim d as Single = 2.887
		  dim c as currency = 5.67
		  dim i as integer = 8
		  
		  v = s
		  dim asSingle as Single = s
		  dim valueAsSingle as Single = v.NativeValue
		  Assert.AreEqual(asSingle, valueAsSingle, 0.1, "Single")
		  
		  v = d
		  Assert.AreEqual(d, CType(v.NativeValue, Single), 0.1, "Single")
		  
		  v = c
		  Assert.AreEqual(c, CType(v.NativeValue, currency), "Currency")
		  
		  v = i
		  Assert.AreEqual(i, CType(v.NativeValue, integer), "Integer")
		  
		  v = 1.23
		  dim adder as Single = 0.77
		  dim subtracter as Single = 0.23
		  
		  dim c2 as OrmSingle
		  dim compare as double
		  dim t as double
		  
		  compare = 2.0
		  t = v + adder
		  Assert.AreEqual compare, t, "Add failed"
		  
		  t = adder + v
		  Assert.AreEqual compare, t, "AddRight failed"
		  
		  c2 = adder
		  t = v + c2
		  Assert.AreEqual compare, t, "Add failed against OrmSingle"
		  
		  compare = 1.0
		  t = v - subtracter
		  Assert.AreEqual compare, t, "Subtract failed"
		  
		  compare = 0.23 - 1.23
		  t = subtracter - v
		  Assert.AreEqual compare, t, "SubtractRight failed"
		  
		  compare = 1.0
		  c2 = subtracter
		  t = v - c2
		  Assert.AreEqual compare, t, "Subtract failed against OrmSingle"
		  
		  dim multiplier as Single = 2.5
		  v = 5.0
		  compare = 5.0 * 2.5
		  
		  t = v * multiplier
		  Assert.AreEqual compare, t, "Multiply failed"
		  
		  t = multiplier * v
		  Assert.AreEqual compare, t, "MultiplyRight failed"
		  
		  c2 = multiplier
		  t = v * c2
		  Assert.AreEqual compare, t, "Multiply failed against OrmSingle"
		  
		  dim divider as Single = 2.0
		  v = 5.0
		  compare = 5.0 / divider
		  
		  t = v / divider
		  Assert.AreEqual compare, t, "Divide failed"
		  
		  compare = divider / 5.0
		  t = divider / v
		  Assert.AreEqual compare, t, "DivideRight failed"
		  
		  c2 = divider
		  t = v / c2
		  compare = 5.0 / divider
		  Assert.AreEqual compare, t, "Divide failed against OrmSingle"
		  
		  v = 5.0
		  compare = 5.0 / divider
		  
		  compare = 5.0 \ divider
		  t = v \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed"
		  
		  compare = divider \ 5.0
		  t = divider \ v
		  Assert.AreEqual compare, t, "IntegerDivideRight failed"
		  
		  c2 = divider
		  t = v \ c2
		  compare = 5.0 \ divider
		  Assert.AreEqual compare, t, "IntegerDivide failed against OrmSingle"
		  
		  v = 5.0
		  t = -v
		  compare = -5.0
		  Assert.AreEqual compare, t, "Negate failed"
		  
		  v = 5.0
		  compare = 1.0
		  t = v mod 2.0
		  Assert.AreEqual compare, t, "Mod failed"
		  
		  v = 2.0
		  t = 5.0 mod v
		  Assert.AreEqual compare, t, "ModRight failed"
		  
		  v = 5.0
		  c2 = 2.0
		  t = v mod c2
		  Assert.AreEqual compare, t, "Mod failed against OrmCurrency"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StringTest()
		  dim v as OrmString
		  dim s as string = "ABC123"
		  
		  v = s
		  Assert.AreSame(s, v.NativeValue)
		  
		  dim t as text = s.ToText
		  v = t
		  Assert.AreSame(t, v.NativeValue.ToText)
		  Assert.IsTrue(v = t)
		  
		  dim compare as string = "thisthat"
		  v = "this"
		  s = v + "that"
		  Assert.AreSame compare, s, "Add failed"
		  
		  v = "that"
		  s = "this" + v
		  Assert.AreSame compare, s, "AddRight failed"
		  
		  s = v + v
		  compare = "thatthat"
		  Assert.AreSame compare, s, "Add failed against OrmString"
		  
		  v = "1.2"
		  Assert.AreEqual 1.2, v.Val, "Val failed"
		  Assert.AreEqual 1.2, v.CDbl, "CDbl failed"
		  Assert.AreEqual CType(1, Int64), v.CLong, "CLong failed"
		  
		  v = "   1   "
		  Assert.AreEqual "1", v.Trim, "Trim failed"
		  Assert.AreEqual "   1", v.RTrim, "RTrim failed"
		  Assert.AreEqual "1   ", v.LTrim, "LTrim failed"
		  
		  s = "aBC dEF"
		  v = s
		  Assert.AreSame s.Uppercase, v.Uppercase, "Uppercase failed"
		  Assert.AreSame s.Lowercase, v.Lowercase, "Lowercase failed"
		  Assert.AreSame s.Titlecase, v.Titlecase, "Titlecase failed"
		  
		  v = "1,2"
		  Assert.AreEqual 2, v.CountFields(","), "CountFields failed"
		  Assert.AreEqual 2, v.CountFieldsB(","), "CountFieldsB failed"
		  Assert.AreEqual "2", v.NthField(",", 2), "NthField failed"
		  Assert.AreEqual "2", v.NthFieldB(",", 2), "NthFieldB failed"
		  
		  dim arr() as string = v.Split(",")
		  Assert.AreEqual 1, arr.Ubound
		  
		  v = v.ConvertEncoding(Encodings.UTF8)
		  Assert.AreEqual Encodings.UTF8.InternetName, v.Encoding.InternetName
		  
		  v = v.DefineEncoding(Encodings.ASCII)
		  Assert.AreEqual Encodings.ASCII.InternetName, v.Encoding.InternetName
		  
		  s = "A"
		  v = s
		  Assert.AreEqual s.Asc, v.Asc
		  Assert.AreEqual s.AscB, v.AscB
		  
		  
		  v = "ÄBCD"
		  Assert.AreEqual "Ä", v.Left(1), "Left failed"
		  Assert.AreEqual "D", v.Right(1), "Right failed"
		  Assert.AreEqual "CD", v.Mid(3), "Mid failed"
		  Assert.AreEqual "B", v.Mid(2, 1), "Mid with length failed"
		  
		  Assert.AreEqual "Ä", v.LeftB(2), "LeftB failed"
		  Assert.AreEqual "D", v.RightB(1), "RightB failed"
		  Assert.AreEqual "CD", v.MidB(4), "MidB failed"
		  Assert.AreEqual "B", v.MidB(3, 1), "MidB with length failed"
		  
		  Assert.AreEqual 2, v.InStr("B"), "InStr failed"
		  Assert.AreEqual 3, v.InStrB("B"), "InStrB failed"
		  
		  s = "Äbcä"
		  v = s
		  Assert.AreSame s.Replace("ä", "a"), v.Replace("ä", "a"), "Replace failed"
		  Assert.AreSame s.ReplaceB("ä", "a"), v.ReplaceB("ä", "a"), "ReplaceB failed"
		  Assert.AreSame s.ReplaceAll("ä", "a"), v.ReplaceAll("ä", "a"), "ReplaceAll failed"
		  Assert.AreSame s.ReplaceAllB("ä", "a"), v.ReplaceAllB("ä", "a"), "ReplaceAllB failed"
		  
		  Assert.AreEqual s.Len, v.Len, "Len failed"
		  Assert.AreEqual s.LenB, v.LenB, "LenB failed"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TextTest()
		  dim v as OrmText
		  dim t as text = "ABC123"
		  
		  v = t
		  Assert.AreSame(t, v.NativeValue)
		  
		  Assert.IsTrue(v < "ZZZ")
		  
		  dim compare as Text = "thisthat"
		  v = "this"
		  t = v + "that"
		  Assert.AreSame compare, t, "Add failed"
		  
		  v = "that"
		  t = "this" + v
		  Assert.AreSame compare, t, "AddRight failed"
		  
		  t = v + v
		  compare = "thatthat"
		  Assert.AreSame compare, t, "Add failed against OrmText"
		  
		  dim s as OrmString = "hi"
		  t = s.ToText
		  Assert.AreEqual "hi", t, "ToText failed"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TimeTest()
		  dim t as new OrmTime
		  Assert.AreEqual 0, t.Hour, "OrmTime Hour"
		  Assert.AreEqual 0, t.Minute, "OrmTime Minute"
		  Assert.AreEqual 0.0, t.Second, "OrmTime Second"
		  
		  dim master as new Date
		  t = master
		  Assert.AreEqual master.TotalSeconds, t.TotalSeconds, "Date and Time TotalSeconds"
		  
		  dim diff as new OrmTime(1, 0, 0)
		  dim newDate as date = master - diff
		  master.TotalSeconds = master.TotalSeconds - 3600
		  Assert.AreEqual master.Hour, newDate.Hour, "Subtract an hour"
		  
		  dim time1 as new OrmTime(1, 0, 0)
		  dim time2 as new OrmTime(0, 0, 5)
		  dim combined as OrmTime = time1 + time2
		  Assert.AreEqual 3605.0, combined.TotalSeconds, "Add 5 minutes"
		  
		  combined = combined - time2
		  Assert.AreEqual 3600.0, combined.TotalSeconds, "Subtract 5 minutes"
		  
		  t = new OrmTime(999, 1, 2)
		  Assert.AreEqual "999:01:02", t.ToString, "Convert to string long"
		  
		  t = new OrmTime(99, 1, 2)
		  Assert.AreEqual "99:01:02", t.ToString, "Convert to string (2-digit hour)"
		  
		  t = new OrmTime(9, 1, 2)
		  Assert.AreEqual "09:01:02", t.ToString, "Convert to string (1-digit hour)"
		  
		  t = new OrmTime(0, 0, 1.2)
		  Assert.AreEqual 1.2, t.TotalSeconds, "TotalSeconds should retain a fraction"
		  Assert.AreEqual "00:00:01", t.ToString, "Fractional seconds should not reflect in string"
		End Sub
	#tag EndMethod


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
