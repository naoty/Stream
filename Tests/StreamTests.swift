//
//  StreamTests.swift
//  Stream
//
//  Created by naoty on 2014/08/25.
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
}

class StringStreamTestCase: XCTestCase {
    var stream: Stream<String>!
    
    override func setUp() {
        stream = Stream<String>()
    }
    
    func testPublish() {
        var sentence = ""
        stream.subscribe { message in sentence += message }
        stream.publish("Hello, ")
        stream.publish("wor")
        stream.publish("ld!")
        XCTAssertEqual(sentence, "Hello, world!", "")
    }
    
    func testMap() {
        var sentence = ""
        let mappedStream = stream.map { message in return message.uppercaseString }
        mappedStream.subscribe { message in sentence += message }
        stream.publish("Hello, ")
        stream.publish("wor")
        stream.publish("ld!")
        XCTAssertEqual(sentence, "HELLO, WORLD!", "")
    }
    
    func testFilter() {
        var sentence = ""
        let filteredStream = stream.filter { message in return message.rangeOfString(" ") == nil }
        filteredStream.subscribe { message in sentence += message }
        stream.publish("Hello, ")
        stream.publish("wor")
        stream.publish("ld!")
        XCTAssertEqual(sentence, "world!", "")
    }
}