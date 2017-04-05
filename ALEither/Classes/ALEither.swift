//
//  ALEither.swift
//  Pods
//
//  Created by Alex Hmelevski on 2017-04-05.
//
//

import Foundation


public enum ALEither<Right, E> {
    //    public typealias E = Error
    case right(value: Right)
    case wrong(value: E)
    
    init(value: Right) {
        self = .right(value: value)
    }
    
    init(error: E) {
        self = .wrong(value: error)
    }
    
    init?(value: Right?, error: E?) {
        if let e = error {
            self = .wrong(value: e)
            return
        }
        
        if let v = value {
            self = .right(value: v)
            return
        }
        return nil
        //        let er = NSError(domain: "ALEither", code: -1, userInfo: ["info": "Can't create ALEither when both parametres are nil"])
        //        self = .wrong(value: er)
        
    }
    
    // MARK: FUNCTIONAL
    
    /// Map function calls transfrom function on value if it Right, if wrong returns
    /// current state
    /// - Parameter transform: function to apply
    /// - Returns: ALEither<U, Wrong>
    func map<U>(transform: (Right) -> U) -> ALEither<U, E> {
        switch self {
        case .right(let val): return .right(value: transform(val))
        case .wrong(let err): return .wrong(value: err)
        }
    }
    
    /// Conditional function, returns Either with valid value according to predicate block
    /// If predicate false - returns nil
    /// - Parameter predicate: Predicate
    /// - Returns: ALEither<Right, Wrong>?
    
    func take(if predicate: (Right) -> Bool) -> ALEither<Right, E>? {
        switch self {
        case .right(let val): return predicate(val) ? self : nil
        case .wrong: return self
        }
    }
    
    /// Conditional check for Either returns current state if predicate true or default value
    ///
    /// - Parameters:
    ///   - predicate: (Right) -> Bool
    ///   - default: Default value
    /// - Returns: ALEither<Right, Wrong>
    
    func take(if predicate: (Right) -> Bool, default: Right) -> ALEither<Right, E> {
        switch self {
        case .right(let val): return predicate(val) ? self : .right(value: `default`)
        case .wrong: return self
        }
    }
    
    /// Conditional check for Either returns current state if predicate true or an error value
    ///
    /// - Parameters:
    ///   - predicate: (Right) -> Bool
    ///   - default: Default error
    /// - Returns: ALEither<Right, Wrong>
    func takeIf(predicate: (Right) -> Bool, wrong: E) -> ALEither<Right, E> {
        switch self {
        case .right(let val): return predicate(val) ? self : .wrong(value: wrong)
        case .wrong: return self
        }
    }
    
    func flatMap<U>(f: (Right) -> ALEither<U, E>) -> ALEither<U, E> {
        switch self {
        case .right(let val): return  f(val)
        case .wrong(let err): return .wrong(value: err)
        }
    }
    
    /// Peform work on a chosen thread(asynchtroniously) when a value is available
    ///
    /// - Parameters:
    ///   - queue: Queue where to perform the block
    ///   - work: block of work with value
    /// - Returns: unmodified ALEither
    @discardableResult
    func `do`(onQueue queue: DispatchQueue? = nil, work:  @escaping (Right) -> Void) -> ALEither<Right, E> {
        if case .right(let val) = self {
            performWork(onQueue: queue, work: { work(val) })
            
        }
        return self
    }
    
    /// doOnError function allows to perform some work if the result is wrong,
    ///
    /// - Parameter work: Block of work with error
    /// - Returns: ALEither<Right>
    @discardableResult
    func doOnError(onQueue queue: DispatchQueue? = nil, work: @escaping  (E) -> Void) -> ALEither<Right, E> {
        if case .wrong(let err) = self {
            performWork(onQueue: queue, work: { work(err) })
            
        }
        return self
    }
    
    /// doOnError function allows to perform some work if the result is wrong,
    /// Does additional check for error types
    /// - Parameter work: Block of work with error
    /// - Returns: ALEither<Right>
    @discardableResult
    func doOnError<U: Error>(ofType type: U.Type, work: (U) -> Void) -> ALEither<Right, E> {
        if case .wrong(let err) = self {
            if let e = err as? U {
                work(e)
            }
            
        }
        return self
    }
    
    /// doOnError function allows to perform some work if the result is wrong,
    ///
    /// - Parameter work: Block of work with error
    /// - Returns: ALEither<Right>
    @discardableResult
    func doOnError(if predicate: (E) -> Bool, work: (E) -> Void) -> ALEither<Right, E> {
        if case .wrong(let err) = self {
            work(err)
        }
        return self
    }
    
    /// Allows to provide default value in case of error
    ///
    /// - Parameter value: Default value
    /// - Returns: ALEither<Right>
    func `default`(value: Right) -> ALEither<Right, E> {
        if case .wrong = self {
            return .right(value: value)
        }
        return self
    }
    
    private func performWork(onQueue: DispatchQueue?, work:  @escaping () -> Void) {
        
        onQueue.do(work: { $0.async(execute: work)})
            .doIfNone(work:  work)
        
    }
    
}
