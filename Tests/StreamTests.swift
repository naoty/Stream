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
    func testPublish() {
        var counter = 0
        let stream = Stream<Int>()
        stream.subscribe { message in counter += message }
        stream.publish(1)
        stream.publish(2)
        stream.publish(3)
        XCTAssertEqual(counter, 6, "")
    }
}

class StringStreamTestCase: XCTestCase {
    func testPublish() {
        var sentence = ""
        let stream = Stream<String>()
        stream.subscribe { message in sentence += message }
        stream.publish("Hello, ")
        stream.publish("wor")
        stream.publish("ld!")
        XCTAssertEqual(sentence, "Hello, world!", "")
    }
}