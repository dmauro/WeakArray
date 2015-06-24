//
//  WeakArray.swift
//  WeakArray
//
//  Created by David Mauro on 7/27/14.
//  Copyright (c) 2014 David Mauro. All rights reserved.
//

import Foundation

// MARK: Operator Overloads

public func ==<T: Equatable>(lhs: WeakArray<T>, rhs: WeakArray<T>) -> Bool {
    var areEqual = false
    if lhs.count == rhs.count {
        areEqual = true
        for i in 0..<lhs.count {
            if lhs[i] != rhs[i] {
                areEqual = false
                break
            }
        }
    }
    return areEqual
}

public func !=<T: Equatable>(lhs: WeakArray<T>, rhs: WeakArray<T>) -> Bool {
    return !(lhs == rhs)
}

public func ==<T: Equatable>(lhs: ArraySlice<T?>, rhs: ArraySlice<T?>) -> Bool {
    var areEqual = false
    if lhs.count == rhs.count {
        areEqual = true
        for i in 0..<lhs.count {
            if lhs[i] != rhs[i] {
                areEqual = false
                break
            }
        }
    }
    return areEqual
}

public func !=<T: Equatable>(lhs: ArraySlice<T?>, rhs: ArraySlice<T?>) -> Bool {
    return !(lhs == rhs)
}

public func +=<T> (inout lhs: WeakArray<T>, rhs: WeakArray<T>) -> WeakArray<T> {
    lhs.items += rhs.items
    return lhs
}

public func +=<T> (inout lhs: WeakArray<T>, rhs: Array<T>) -> WeakArray<T> {
    for item in rhs {
        lhs.append(item)
    }
    return lhs
}

private class Weak<T: AnyObject> {
    weak var value : T?
    var description: String {
        if let val = value {
            return "\(val)"
        } else {
            return "nil"
        }
    }

    init (value: T?) {
        self.value = value
    }
}

// MARK:-

public struct WeakArray<T: AnyObject>: SequenceType, Printable, DebugPrintable, ArrayLiteralConvertible {
    // MARK: Private
    private typealias WeakObject = Weak<T>
    private typealias GeneratorType = WeakGenerator<T>
    private var items = [WeakObject]()

    // MARK: Public
    public var description: String {
        return items.description
    }
    public var debugDescription: String {
        return items.debugDescription
    }
    public var count: Int {
        return items.count
    }
    public var isEmpty: Bool {
        return items.isEmpty
    }
    public var first: T? {
        return self[0]
    }
    public var last: T? {
        return self[count - 1]
    }

    // MARK: Methods

    public init() {}
    
    public init(arrayLiteral elements: T...) {
        for element in elements {
            append(element)
        }
    }

    public func generate() -> GeneratorType {
        let weakSlice: ArraySlice<WeakObject> = items[0..<items.count]
        let slice: ArraySlice<T?> = weakSlice.map { $0.value }
        return GeneratorType(items: slice)
    }

    // MARK: - Slice-like Implementation

    public subscript(index: Int) -> T? {
        get {
            let weak = items[index]
            return weak.value
        }
        set(value) {
            let weak = Weak(value: value)
            items[index] = weak
        }
    }

    public subscript(range: Range<Int>) -> ArraySlice<T?> {
        get {
            let weakSlice: ArraySlice<WeakObject> = items[range]
			let slice : ArraySlice<T?> = weakSlice.map { $0.value }
            return slice
        }
        set(value) {
            items[range] = value.map {
                (value: T?) -> WeakObject in
                return Weak(value: value)
            }
        }
    }

    mutating public func append(value: T?) {
        let weak = Weak(value: value)
        items.append(weak)
    }

    mutating public func insert(newElement: T?, atIndex i: Int) {
        let weak = Weak(value: newElement)
        items.insert(weak, atIndex: i)
    }

    mutating public func removeAtIndex(index: Int) -> T? {
        let weak = items.removeAtIndex(index)
        return weak.value
    }

    mutating public func removeLast() -> T? {
        let weak = items.removeLast()
        return weak.value
    }

    mutating public func removeAll(keepCapacity: Bool) {
        items.removeAll(keepCapacity: keepCapacity)
    }

    mutating public func removeRange(subRange: Range<Int>) {
        items.removeRange(subRange)
    }

    mutating public func replaceRange(subRange: Range<Int>, with newElements: ArraySlice<T?>) {
        let weakElements = newElements.map { Weak(value: $0) }
        items.replaceRange(subRange, with: weakElements)
    }

    mutating public func splice(newElements: ArraySlice<T?>, atIndex i: Int) {
        let weakElements = newElements.map { Weak(value: $0) }
        items.splice(weakElements, atIndex: i)
    }

    mutating public func extend(newElements: ArraySlice<T?>) {
        let weakElements = newElements.map { Weak(value: $0) }
        items.extend(weakElements)
    }

    public func filter(includeElement: (T?) -> Bool) -> WeakArray<T> {
        var filtered: WeakArray<T> = []
        for item in items {
            if includeElement(item.value) {
                filtered.append(item.value)
            }
        }
        return filtered
    }

    public func reverse() -> WeakArray<T> {
        var reversed: WeakArray<T> = []
        let reversedItems = items.reverse()
        for item in reversedItems {
            reversed.append(item.value)
        }
        return reversed
    }
}

// MARK:-

public struct WeakGenerator<T>: GeneratorType {
    typealias Element = T
    private var items: ArraySlice<T?>

    mutating public func next() -> T? {
        while !items.isEmpty {
            let next = items[0]
            items = items[1..<items.count]
            if next != nil {
                return next
            }
        }
        return nil
    }
}
