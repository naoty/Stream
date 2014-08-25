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
    
    override func setUp() {
        stream = Stream<Int>()
    }
    
    func testPublish() {
        var counter = 0
        stream.subscribe { message in counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 6, "")
    }
    
    func testMap() {
        var counter = 0
        let mappedStream = stream.map { message in return message * message }
        mappedStream.subscribe { message in counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 14, "")
    }
    
    func testFilter() {
        var counter = 0
        let filteredStream = stream.filter { message in return message % 2 == 0 }
        filteredStream.subscribe { message in counter += message }
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
}
