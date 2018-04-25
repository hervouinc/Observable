//
//  Observable.swift
//  Observable
//
//  Created by Cyril HERVOUIN on 22/05/2017.
//  Copyright © 2017 Cyril HERVOUIN. All rights reserved.
//

import Foundation

private class Observer<T> {

    typealias DidChangeHandler = (_ oldValue: T?, _ currentValue: T?) -> Void

    weak var owner: AnyObject?
    var handlers: [DidChangeHandler]

    init(owner: AnyObject, handlers: [DidChangeHandler]) {
        self.owner = owner
        self.handlers = handlers
    }
}

public class Observable<T> {

    public typealias DidChangeHandler = (_ oldValue: T?, _ currentValue: T?) -> Void

    private var observers = [Observer<T>]()

    public var value: T? {
        didSet {
            for observer in observers {
                for handler in observer.handlers {
                    handler(oldValue, value)
                }
            }
        }
    }

    public init() {
    }

    public init(_ value: T) {
        self.value = value
    }

    public func addObserver(forOwner owner: AnyObject, triggerImmediately: Bool = true, handler: @escaping DidChangeHandler) {
        if let index = observers.index(where: { $0.owner === owner }) {
            observers[index].handlers.append(handler)
        } else {
            observers.append(Observer(owner: owner, handlers: [handler]))
        }

        if triggerImmediately {
            handler(nil, value)
        }
    }

    public func removeObservers(forOwner owner: AnyObject) {
        if let index = observers.index(where: { $0.owner === owner }) {
            observers.remove(at: index)
        }
        removeEmptyOwners()
    }

    private func removeEmptyOwners() {
        observers = observers.filter { $0.owner != nil }
    }
}
