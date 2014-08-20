//
//  WeakArrayTests.swift
//  WeakArrayTests
//
//  Created by David Mauro on 7/27/14.
//  Copyright (c) 2014 David Mauro. All rights reserved.
//

import Foundation
import XCTest
import WeakArray

class Object: NSObject {
    override var description: String {
    return "object"
    }
}

class WeakArrayTests: XCTestCase {
    func testAddingObjectIncreasesCount() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        XCTAssert(a.count == 1, "Array count did not increase")
    }
    func testAddingObjectWithAppendIncreasesCount() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        XCTAssert(a.count == 1, "Array count did not increase")
    }

    func testCanStoreAndRetriveObject() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        XCTAssert(a[0] == obj, "Retrieved object was \(a[0]) instead of expected obj")
    }

    func testStoredObjectsAreNotRetained() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        obj = nil
        XCTAssertNil(a[0], "We retrieved \(a[0]) instead of nil")
    }

    func testCanStoreWithSubscript() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        a.append(obj1)
        a[0] = obj2
        XCTAssert(a[0] == obj2, "Retrieved object was \(a[0]) instead of expected obj")
    }

    func testCanSetWithRange() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        var obj3: Object? = Object()
        var obj4: Object? = Object()
        a.append(obj1)
        a.append(obj2)
        a.append(obj3)
        a.append(obj4)
        a[1...3] = [obj1, obj1, obj1]
        XCTAssert(a[0] == obj1, "Retrieved object was \(a[0]) instead of expected obj")
        XCTAssert(a[1] == obj1, "Retrieved object was \(a[0]) instead of expected obj")
        XCTAssert(a[2] == obj1, "Retrieved object was \(a[0]) instead of expected obj")
        XCTAssert(a[3] == obj1, "Retrieved object was \(a[0]) instead of expected obj")
    }

    func testCanGetWithRange() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        a.append(obj1)
        a.append(obj2)
        a.append(nil)
        let slice = a[0...2]
        println("Slice: \(slice)")
        XCTAssert(slice[0] == obj1, "First entry did not match")
        XCTAssert(slice[1] == obj2, "Second entry did not match")
        XCTAssertNil(slice[2], "Third entry should be nil")
    }

    func testAppendingWeakArraytoWeakArray() {
        var a1 = WeakArray<Object>()
        var a2 = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        var obj3: Object? = Object()
        var obj4: Object? = Object()
        a1.append(obj1)
        a1.append(obj2)
        a2.append(obj3)
        a2.append(obj4)
        a1 += a2
        XCTAssert(a1.count == 4, "Count is incorrect")
        XCTAssert(a1[2] == obj3, "Incorrect object added")
        XCTAssert(a1[3] == obj4, "Incorrect object added")
    }

    func testAppendingArrayToWeakArray() {
        var a1 = WeakArray<Object>()
        var a2 = [Object]()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        var obj3: Object? = Object()
        var obj4: Object? = Object()
        a1.append(obj1)
        a1.append(obj2)
        a2.append(obj3!)
        a2.append(obj4!)
        a1 += a2
        XCTAssert(a1.count == 4, "Count is incorrect")
        XCTAssert(a1[2] == obj3, "Incorrect object added")
        XCTAssert(a1[3] == obj4, "Incorrect object added")
    }

    func testAppendingFromArrayDoesNotRetain() {
        var a1 = WeakArray<Object>()
        var a2: [Object] = []
        var obj: Object? = Object()
        a2.append(obj!)
        a1 += a2
        a2.removeLast()
        XCTAssert(a1[0] == obj, "Object was not added")
        obj = nil
        XCTAssertNil(a1[0], "Object did not become nil")
    }

    func testIterationGetsCorrectObjects() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        a.append(obj)
        a.append(obj)
        var i = 0
        for value in a {
            XCTAssert(value == obj, "Iterated value did not match")
            i++
        }
        XCTAssert(i == 3, "Iteration count did not match")
    }

    func testIterationIsNotInterruptedByNilObject() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        var obj3: Object? = Object()
        a.append(obj1)
        a.append(obj2)
        a.append(obj3)
        obj2 = nil
        var i = 0
        for value in a {
            i++
        }
        XCTAssert(i == 2, "Iteration count did not match")
    }

    func testModifyingAnArrayDoesNotAffectCopies() {
        var a = WeakArray<Object>()
        var obj: Object? = Object()
        a.append(obj)
        var b = a
        b[0] = nil
        XCTAssertNotNil(a[0], "Changing one array affected the other")
    }

    func testCanBeConstructedWithArrayLiteral() {
        var obj: Object? = Object()
        var a: WeakArray<Object> = [obj!]
        XCTAssert(a[0] == obj, "Object was not added")
    }

    func testFirst() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        a.append(obj1)
        a.append(obj2)
        XCTAssert(a.first == obj1, "First object did not match")
    }

    func testLast() {
        var a = WeakArray<Object>()
        var obj1: Object? = Object()
        var obj2: Object? = Object()
        a.append(obj1)
        a.append(obj2)
        XCTAssert(a.last == obj2, "Last object did not match")
    }
}

