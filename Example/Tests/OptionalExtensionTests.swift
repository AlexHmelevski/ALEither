//
//  OptionalExtensionTests.swift
//  ALEither
//
//  Created by Alex Hmelevski on 2017-04-05.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

@testable import ALEither

func currentQueueName() -> String? {
    let name = __dispatch_queue_get_label(nil)
    return String(cString: name, encoding: .utf8)
}

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
        
        XCTAssertNil(Optional<Int>.none.take(if: {$0 > 0 }))
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
    
    func test_do_perform_work_on_expected_queue() {
        var doCalled = false
        let queue = DispatchQueue(label: "TestQ")
        exp = expectation(description: "Test")
        
        Optional(2).do(on:queue, work: {_ in
            doCalled = true
            XCTAssertEqual(currentQueueName(), "TestQ")
            self.exp.fulfill()
        })
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue(doCalled)
        }
        
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
        Optional<Int>.none.doIfNone(work: {_ in
            doCalled = true
        })
        
       XCTAssertTrue(doCalled)
    }
    
    func test_doIfNone_perform_work_on_expected_queue() {
        var doCalled = false
        let queue = DispatchQueue(label: "TestQ")
        exp = expectation(description: "Test")
        Optional<Int>.none.doIfNone(on:queue, work: {_ in
            doCalled = true
            XCTAssertEqual(currentQueueName(), "TestQ")
            self.exp.fulfill()
        })
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue(doCalled)
        }
 
    }
    
    func test_skipIfNone_perform_work() {
        var doCalled = false
        Optional<Int>.none.doIfNone(work: {_ in
            doCalled = true
        })
        XCTAssertTrue(doCalled)
    }
}
