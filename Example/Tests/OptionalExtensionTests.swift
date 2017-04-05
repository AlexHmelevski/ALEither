//
//  OptionalExtensionTests.swift
//  ALEither
//
//  Created by Alex Hmelevski on 2017-04-05.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

@testable import ALEither

class OptionalExtensionTests: XCTestCase {
    
    var exp: XCTestExpectation!
    override func setUp() {
        super.setUp()
      //  exp = expectation(description: "test")
    }
    
    func test_take_if_returns_valid_data() {
        let d = Optional(2).take(if: { $0 != 0})
        XCTAssertNotNil(d)
        XCTAssertEqual(d!, 2)
    }
    
    func test_take_if_returns_nil() {
        let d = Optional(2).take(if: { $0 < 0})
        XCTAssertNil(d)
    }
    
    func test_take_if_with_default_returns_valid_data() {
        let d = Optional(2).take(if: { $0 != 0}, default: 10)
        XCTAssertNotNil(d)
        XCTAssertEqual(d!, 2)
    }
    
    func test_take_if_with_default_returns_default() {
        let d = Optional(2).take(if: { $0 < 0}, default: 10)
        XCTAssertNotNil(d)
        XCTAssertEqual(d!, 10)
    }
    
    
    func test_do_perform_work() {
        var doCalled = false
        Optional(2).do(work: {_ in
            doCalled = true
        })
        
        XCTAssertTrue(doCalled)
    }
    
    func test_skip_perform_work() {
        var doCalled = false
        Optional<Int>.none.do(work: {_ in
            doCalled = true
        })
        
        XCTAssertFalse(doCalled)
    }
    
    func test_doIfNone_perform_work() {
        var doCalled = false
        Optional(2).doIfNone(work: {_ in
            doCalled = true
        })
        
       XCTAssertFalse(doCalled)
    }
    
    func test_skipIfNone_perform_work() {
        var doCalled = false
        Optional<Int>.none.doIfNone(work: {_ in
            doCalled = true
        })
        XCTAssertTrue(doCalled)
    }
}
