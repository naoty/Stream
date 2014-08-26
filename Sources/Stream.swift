//
//  Stream.swift
//  Stream
//
//  Created by naoty on 2014/08/25.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

public class Stream<T>: NSObject {
    private var subscriptions: [(T) -> Void]
    
    public override init() {
        subscriptions = []
    }
    
    public func subscribe(subscription: (T) -> Void) -> Stream<T> {
        subscriptions.append(subscription)
        return self
    }
    
    public func publish(message: T) {
        for subscription in subscriptions {
            subscription(message)
        }
    }
    
    public func map<U>(function: (T) -> U) -> Stream<U> {
        let mappedStream = Stream<U>()
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
    
    public func flatMap<U>(function: (T) -> Stream<U>) -> Stream<U> {
        let flatMappedStream = Stream<U>()
        subscribe { message in
            function(message).subscribe { submessage in
                flatMappedStream.publish(submessage)
            }
            return
        }
        return flatMappedStream
    }
    
    public func flatMapLatest<U>(function: (T) -> Stream<U>) -> Stream<U> {
        let flatMappedStream = Stream<U>()
        var latestStream = Stream<U>()
        subscribe { message in
            let currentStream = function(message)
            latestStream = currentStream
            latestStream.subscribe { submessage in
                if latestStream == currentStream {
                    flatMappedStream.publish(submessage)
                }
            }
        }
        return flatMappedStream
    }
    
    public func throttle(seconds: NSTimeInterval) -> Stream<T> {
        let throttledStream = Stream<T>()
        var locked = false
        subscribe { message in
            if !locked {
                locked = true
                throttledStream.publish(message)
                NSTimer.scheduledTimerWithTimeInterval(seconds, target: NSBlockOperation(block: {
                    locked = false
                }), selector: Selector("main"), userInfo: nil, repeats: false)
            }
        }
        return throttledStream
    }
    
    public func debounce(seconds: NSTimeInterval) -> Stream<T> {
        return flatMapLatest { message in
            let metaStream = Stream<T>()
            NSTimer.scheduledTimerWithTimeInterval(seconds, target: NSBlockOperation(block: {
                metaStream.publish(message)
            }), selector: Selector("main"), userInfo: nil, repeats: false)
            return metaStream
        }
    }
}