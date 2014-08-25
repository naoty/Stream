//
//  Stream.swift
//  Stream
//
//  Created by naoty on 2014/08/25.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

public class Stream<T> {
    private var subscribers: [(T) -> Void]
    
    public init() {
        subscribers = []
    }
    
    public func subscribe(subscriber: (T) -> Void) {
        subscribers.append(subscriber)
    }
    
    public func publish(message: T) {
        for subscriber in subscribers {
            subscriber(message)
        }
    }
}