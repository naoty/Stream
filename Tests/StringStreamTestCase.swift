//
//  StringStreamTestCase.swift
//  Stream
//
//  Created by Naoto Kaneko on 2014/08/25.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Stream
import XCTest

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
    
    func testScan() {
        var word = "a"
        let accumulatorStream = stream.scan(word, { previousMessage, message in
            return previousMessage > message ? previousMessage : message
        })
        accumulatorStream.subscribe { message in word = message }
        stream.publish("e")
        stream.publish("d")
        stream.publish("b")
        stream.publish("a")
        XCTAssertEqual(word, "e", "")
    }
}
