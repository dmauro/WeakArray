Swift WeakArray
========
Version 1.0  
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
	let a = WeakArray<MyType>()
	
You can also pass in an array literal when creating a weak array, but because Arrays cannot hold optionals you'll need to get a non-optional value first if you want to do this:

	let view: UIView? = UIView()
	let a = WeakArray<UIView>(array: [view!])
	
Otherwise a WeakArray works just like an Array:

	let a = WeakArray<AnyObject>()
	
	let view: UIView? = UIView()
	
	// Operator +=
	a += view
	
	// Append
	a.append(view)
	
	// Replace with index
	a[0] = view
	
	// Replace with range
	a[0..1] = [view, view]
	
	// Remove Last
	a.removeLast()
	
	// Remove at index
	let view: UIView? = a.removeAtIndex(0)
	
	// isEmpty and count
	if (!a.isEmpty) {
		println("Count: \(a.count)")
	}

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
	