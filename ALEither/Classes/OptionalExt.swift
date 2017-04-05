//
//  OptionalExt.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-04-05.
//
//

import Foundation


//
//  OptionalExtension.swift
//  MyWeatherApp
//
//  Created by Alex Hmelevski on 2017-02-01.
//  Copyright © 2017 Alex Crow. All rights reserved.
//

import Foundation

extension Optional {
    
    /// Conditional function, returns Either with valid value according to predicate block
    /// If predicate false - returns nil
    /// - Parameter predicate: Predicate
    /// - Returns: ALEither<Right, Wrong>?
    
    func take(if predicate: (Wrapped) -> Bool) -> Wrapped? {
        switch self {
            case .some(let val): return predicate(val) ? self : nil
            case .none: return self
        }
    }
    
    /// Conditional check for Either returns current state if predicate true or default value
    ///
    /// - Parameters:
    ///   - predicate: (Right) -> Bool
    ///   - default: Default value
    /// - Returns: ALEither<Right, Wrong>
    
    func take(if predicate: (Wrapped) -> Bool, default: Wrapped) -> Wrapped? {
        switch self {
            case .some(let val): return predicate(val) ? self : `default`
            case .none: return self
        }
    }
    
    /// Peform work on a chosen thread(asynchroniously) when a value is available
    ///
    /// - Parameters:
    ///   - queue: Queue where to perform the block
    ///   - work: block of work with value
    /// - Returns: unmodified Wrapped?
    @discardableResult
    func `do`(onQueue queue: DispatchQueue, work:  @escaping (Wrapped) -> Void) -> Wrapped? {
        if case .some(let val) = self {
            performWork(onQueue: queue, work: { work(val) })
        }
        return self
    }
    
    /// Peform work on a chosen thread(asynchroniously) when a value is available
    ///
    /// - Parameters:
    ///   - queue: Queue where to perform the block
    ///   - work: block of work with value
    /// - Returns: unmodified Wrapped?
    @discardableResult
    public func `do`( work: (Wrapped) -> Void) -> Wrapped? {
        if case .some(let val) = self {
            work(val)
        }
        return self
    }
    
    /// doNone function allows to perform some work if the result is none,
    ///
    /// - Parameter work: Block of work
    /// - Returns: Wrapped?
    @discardableResult
    public func doIfNone(work: () -> Void) -> Wrapped? {
        if case .none = self {
            work()
        }
        return self
    }
    
    private func performWork(onQueue: DispatchQueue?, work:  @escaping () -> Void) {
        guard let q = onQueue else {
            work()
            return
        }
        
        q.async(execute: work)
        
    }
    
    @discardableResult
    func debug(message: String? = nil) -> Wrapped? {
        message.do(work: { print($0 + " " + "\(self)") })
            .doIfNone(work: { print(self ?? "nil") })
        return self
    }
    
}
