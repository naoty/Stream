# Stream

Swift library to control streams on Functional Reactive Programming model

## Demo

```swift
let stream = Stream<String>()
let counterStream: Stream<Int> = stream.map({ message in
    return countElements(message)
}).scan(0, { previousMessage, message in
    return previousMessage + message
}).subscribe({ message in
    println(message)
})
stream.publish("Hello, ") //=> 7
stream.publish("wor")     //=> 10
stream.publish("ld!")     //=> 13
```

## Usage

TODO

## Installation

TODO

## Contribution

1. Fork
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

Stream is available under the MIT license. See the LICENSE file for more info.

## Author

[naoty](https://github.com/naoty)

