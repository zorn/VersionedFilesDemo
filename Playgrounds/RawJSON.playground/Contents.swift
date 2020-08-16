import UIKit

let values: [String : Any?] = ["a":1, "b":"hello", "c": nil, "d": true]

let valuesAsJSONData = try! JSONSerialization.data(withJSONObject: values, options: [.prettyPrinted, .sortedKeys])

let rawJSONString = String(data: valuesAsJSONData, encoding: .utf8)!

print(rawJSONString)
