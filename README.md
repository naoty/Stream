# Stream

Swift library to control streams on Functional Reactive Programming model

## Demo

```swift
var counter = 0
let intStream = Stream<Int>()
intStream.subscribe { message in counter += message }
intStream.publish(1)
intStream.publish(2)
intStream.publish(3)
println(counter) //=> 6

var sentence = ""
let stringStream = Stream<String>()
stringStream.subscribe { message in sentence += message }
stringStream.publish("Hello, ")
stringStream.publish("wor")
stringStream.publish("ld!")
println(sentence) //=> "Hello, world!"
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

