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
}