Swift WeakArray
========
Version 0.2  
WeakArray offers a collection type that behaves like a Swift Array, but will not retain any of its objects.

Released under the Apache License, version 2.0

How to Install
==============
This should only be used with the latest version of Xcode 6.

1. Clone this repository.  
2. Add WeakArray.xcodeproj to your main target.  
3. Link the WeakArray framework in your main target.  

Usage
=====
First make sure to import WeakArray:

	import WeakArray
	
When creating a weak array, specify the collection type as you would with an Array:
	
	typealias myType = AnyObject
	var a = WeakArray<MyType>()
	
You can also use array literals to create a WeakArray, but to do so you'll need to unwrap your optionals with ```!```:

	var view: UIView? = UIView()
	var a: WeakArray<UIView> = [view!]
	
Otherwise a WeakArray works just like an Array:

	var a = WeakArray<AnyObject>()
	
	var view: UIView? = UIView()
	
	// Append
	a.append(view)
	
	// Replace with index
	a[0] = view
	
	// Replace with range
	a[0...1] = [view, view]
	
	// Remove Last
	a.removeLast()
	
	// Remove at index
	var view: UIView? = a.removeAtIndex(0)
	
	// isEmpty and count
	if (!a.isEmpty) {
		println("Count: \(a.count)")
	}
	
	// First and Last
	var first: AnyObject? = a.first
	var last: AnyObject? = a.list
	
	// Append WeakArray
	var b = WeakArray<AnyObject>()
	a += b
	
	// Or append a standard library Array
	var c = Array<AnyObject>()
	a += c

You can also enumerate over a WeakArray like you would an Array, but keep in mind it will skip over nil values while count will include them, so **count may not
match the number of enumerations you get**.

	func testIterationIsNotInterruptedByNilObject() {
        var a = WeakArray<UIView>()
        var obj1: UIView? = UIView()
        var obj2: UIView? = UIView()
        var obj3: UIView? = UIView()
        a += obj1
        a += obj2
        a += obj3
        obj2 = nil
        var i = 0     
        for value in a {
            i++
        }
        XCTAssert(a.count == 3, "")
        XCTAssert(i == 2, "")
    }
    
Version History
===============
**v0.2**

* Update to match beta 5 array changes
* Use ArrayLiteralConvertible

**v0.1**

* Released!
	