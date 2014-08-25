//
//  Stream.swift
//  Stream
//
//  Created by naoty on 2014/08/25.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

public class Stream<T> {
    private var subscriptions: [(T) -> Void]
    
    public init() {
        subscriptions = []
    }
    
    public func subscribe(subscription: (T) -> Void) {
        subscriptions.append(subscription)
    }
    
    public func publish(message: T) {
        for subscription in subscriptions {
            subscription(message)
        }
    }
    
    public func map(function: (T) -> T) -> Stream<T> {
        let mappedStream = Stream<T>()
        subscribe { message in mappedStream.publish(function(message)) }
        return mappedStream
    }
    
    public func filter(function: (T) -> Bool) -> Stream<T> {
        let filteredStream = Stream<T>()
        subscribe { message in if function(message) { filteredStream.publish(message) } }
        return filteredStream
    }
    
    public func scan(seed: T, _ function: (T, T) -> T) -> Stream<T> {
        let accumulatorStream = Stream<T>()
        var previousMessage = seed
        subscribe { message in
            previousMessage = function(previousMessage, message)
            accumulatorStream.publish(previousMessage)
        }
        return accumulatorStream
    }
    
    public func flatMap(function: (T) -> Stream<T>) -> Stream<T> {
        let flatMappedStream = Stream<T>()
        subscribe { message in
            function(message).subscribe { submessage in
                flatMappedStream.publish(submessage)
            }
        }
        return flatMappedStream
    }
}