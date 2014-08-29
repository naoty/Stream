//
//  IntStreamTestCase.swift
//  Stream
//
//  Created by Naoto Kaneko on 2014/08/25.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Stream
import XCTest

class IntStreamTestCase: XCTestCase {
    var stream: Stream<Int>!
    var counter: Int = 0
    var expectation: XCTestExpectation!
    
    override func setUp() {
        stream = Stream<Int>()
        counter = 0
    }
    
    func testPublish() {
        stream.subscribe { message in self.counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 6, "")
    }

    func testFail() {
        stream.subscribe({ message in self.counter += message }, onError: { error in self.counter = 0 })
        stream.publish(1)
        stream.fail(NSError(domain: NSCocoaErrorDomain, code: 1, userInfo: nil))
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 5, "")
    }
    
    func testComplete() {
        stream.subscribe({ message in self.counter += message}, onCompleted: { message in self.counter = message })
        stream.publish(1)
        stream.publish(2)
        stream.complete(-1)
        stream.publish(3)
        XCTAssertEqual(counter, -1, "")
    }
}

// MARK: - Create a stream from given function

extension IntStreamTestCase {
    func testMap() {
        let mappedStream: Stream<Int> = stream.map { message in return message * message }
        mappedStream.subscribe { message in self.counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 14, "")
    }
    
    func testFilter() {
        let filteredStream = stream.filter { message in return message % 2 == 0 }
        filteredStream.subscribe { message in self.counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 2, "")
    }
    
    func testScan() {
        var max = 0
        let accumulatorStream = stream.scan(max, { previousMessage, message in
            return previousMessage > message ? previousMessage : message
        })
        accumulatorStream.subscribe { message in max = message }
        stream.publish(3)
        stream.publish(2)
        stream.publish(1)
        XCTAssertEqual(max, 3, "")
    }
    
    func testFlatMap() {
        let expectation = expectationWithDescription("")
        
        var counter = 0
        let flatMappedStream: Stream<Int> = stream.flatMap { message in
            let metaStream = Stream<Int>()
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: NSBlockOperation(block: {
                metaStream.publish(message)
                expectation.fulfill()
            }), selector: Selector("main"), userInfo: nil, repeats: false)
            return metaStream
        }
        flatMappedStream.subscribe { message in counter += message }
        stream.publish(1)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(counter, 1, "")
    }
    
    func testFlatMapLatest() {
        let expectation = expectationWithDescription("")
        var fulfilled = false
        
        let flatMappedStream: Stream<Int> = stream.flatMapLatest { message in
            let metaStream = Stream<Int>()
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: NSBlockOperation(block: {
                metaStream.publish(message)
                if !fulfilled {
                    expectation.fulfill()
                    fulfilled = true
                }
            }), selector: Selector("main"), userInfo: nil, repeats: false)
            return metaStream
        }
        flatMappedStream.subscribe { message in self.counter += message }
        stream.publish(1)
        stream.publish(2)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(counter, 2, "")
    }
}

// MARK: - Create a stream from given time

extension IntStreamTestCase {
    func testThrottle() {
        var expectation = expectationWithDescription("")
        
        let throttledStream = stream.throttle(1).subscribe { message in self.counter += message }
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: NSBlockOperation(block: {
            self.stream.publish(1)
            self.stream.publish(2)
            self.stream.publish(3)
            expectation.fulfill()
        }), selector: Selector("main"), userInfo: nil, repeats: false)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(counter, 1, "")
    }
    
    func testDebounce() {
        let expectation = expectationWithDescription("")
        
        let debouncingStream = stream.debounce(0.1).subscribe { message in
            self.counter += message
            expectation.fulfill()
        }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(counter, 3, "")
    }
    
    func testBufferWithSeconds() {
        let expectation = expectationWithDescription("")
        
        stream.buffer(seconds: 0.3).map({ message in
            return countElements(message)
        }).subscribe { message in
            self.counter = message
        }
        
        self.stream.publish(1)
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: NSBlockOperation(block: { self.stream.publish(2) }), selector: Selector("main"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: NSBlockOperation(block: { self.stream.publish(3) }), selector: Selector("main"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.8, target: NSBlockOperation(block: { expectation.fulfill() }), selector: Selector("main"), userInfo: nil, repeats: false)
        
        waitForExpectationsWithTimeout(1, handler: nil)
        XCTAssertEqual(counter, 2, "")
    }
}
