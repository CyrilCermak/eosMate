//: A UIKit based Playground for presenting user interface
  
import UIKit
import Foundation
//
// let amount = 0.8755500000000001
//
//
//
// func formatAmount(string: String) -> String {
//    if string.contains(".") {
//        return addZeroesTo(amount: string)
//    }
//    return "\(string).0000"
// }
//
// func addZeroesTo(amount: String) -> String {
//    guard let dotPart = amount.split(separator: ".").last else { return "\(amount).0000" }
//    guard dotPart.count <= 4 else {
//        if dotPart.count == 4 { return amount }
//        let from = dotPart.startIndex
//        let to = dotPart.index(from, offsetBy: 4)
//        return "\(amount.split(separator: ".").first!).\(dotPart[from..<to])"
//    }
//    let zeroesToAdd = 4 - dotPart.count
//    var formattedAmount = amount
//    for _ in  0..<zeroesToAdd {
//        formattedAmount += "0"
//    }
//    return formattedAmount
// }
//
//
// var num = "0.0010"
// num = "11110.512"
// print(formatAmount(string: num))

//
// var nums = [9,9,9,8]
// var sum = 0
// nums.reversed().enumerated().forEach { offset, num in
//    sum += num * (pow(10, offset) as NSDecimalNumber).intValue
// }
// sum += 1
// let finalNums = String(describing: sum).map { return Int(String($0))! }

var num: Double = 0.00001
let addition = 0.00001
while num <= 0.0001 {
    num += addition
    print(String(format: "%.4f", arguments: [num]))
}
