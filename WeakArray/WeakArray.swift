//
//  WeakArray.swift
//  WeakArray
//
//  Created by David Mauro on 7/27/14.
//  Copyright (c) 2014 David Mauro. All rights reserved.
//

// Operator Overloads
@infix public func +=<T> (inout lhs: WeakArray<T>, rhs: T?) -> WeakArray<T> {
    lhs.append(rhs)
    return lhs
}

@infix public func +=<T> (inout lhs: WeakArray<T>, rhs: WeakArray<T>) -> WeakArray<T> {
    lhs.items += rhs.items
    return lhs
}

@infix public func +=<T> (inout lhs: WeakArray<T>, rhs: Array<T>) -> WeakArray<T> {
    for item in rhs {
        lhs.append(item)
    }
    return lhs
}

private class Weak<T: AnyObject> {
    weak var value : T?
    var description: String {
        if let val = value? {
            return "\(val)"
        } else {
            return "nil"
        }
    }

    init (value: T?) {
        self.value = value
    }
}

public struct WeakArray<T: AnyObject>: Sequence, Printable, DebugPrintable {
    // Private
    private typealias WeakObject = Weak<T>
    private typealias GeneratorType = WeakGenerator<T>
    private var items = [WeakObject]()

    // Public Vars
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
        return items.count == 0
    }

    // Methods
    public init(array: [T] = []) {
        self += array
    }

    public func generate() -> GeneratorType {
        let weakSlice: Slice<WeakObject> = items[0..<items.count]
        let slice: Slice<T?> = weakSlice.map { $0.value }
        return GeneratorType(items: slice)
    }

    mutating public func append(value: T?) {
        let weak = Weak(value: value)
        items += weak
    }

    mutating public func removeAtIndex(i: Int) -> T? {
        let weak = items.removeAtIndex(i)
        return weak.value
    }

    mutating public func removeLast() -> T? {
        let weak = items.removeLast()
        return weak.value
    }

    public subscript(i: Int) -> T? {
        get {
            let weak = items[i]
            return weak.value
        }
        set(value) {
            let weak = Weak(value: value)
            items[i] = weak
        }
    }

    public subscript(range: Range<Int>) -> Slice<T?> {
        get {
            let weakSlice: Slice<WeakObject> = items[range]
            let slice: Slice<T?> = weakSlice.map { $0.value }
            return slice
        }
        set(value) {
            items[range] = value.map {
                (value: T?) -> Weak<T> in
                return Weak(value: value)
            }
        }
    }
}

public struct WeakGenerator<T>: Generator {
    typealias Element = T
    private var items: Slice<T?>

    mutating public func next() -> T? {
        while !items.isEmpty {
            let next = items[0]
            items = items[1..<items.count]
            if next? {
                return next
            }
        }
        return nil
    }
}
