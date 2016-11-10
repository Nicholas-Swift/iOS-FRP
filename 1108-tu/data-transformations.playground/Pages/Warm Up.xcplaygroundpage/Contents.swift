//: [Next](@next)
/*:
 
 ### Challenges
 
 Write the following functions: 
 
 1. `makeAllUppercase` that takes an array of `String`s and returns an array of `String`s; all the strings in the returned array should only contain uppercase characters
 2. `convertAllToString` that takes an array of `Int`s and returns an array of `String`s where every `Int` was transformed to a `String`
 3. `keepOnlyOdds` that takes an array of `Int`s and returns an array of `Int`s that only has odd numbers
 4. `startingWithA` that takes an array of `String`s and returns an array of `String`s that only contains `String`s that start with the (uppercase) letter `A`
 5. `computeProduct` that takes an array of `Int`s and returns a single `Int` that is the product of all the elements in the array
 6. `concatenateAll` that takes an array of `String`s and returns a `String` that is concatenates all the elements in the array
 
 */
// Challenge 1
func makeAllUppercase(strings: [String]) -> [String] {
    let uppercaseArray = strings.map{$0.uppercased()}
    return uppercaseArray
}
makeAllUppercase(strings: ["hello", "nick", "swift"])

// Challenge 2
func convertAllToString(ints: [Int]) -> [String] {
    let stringArray = ints.map{String($0)}
    return stringArray
}
convertAllToString(ints: [5, 6, 7, 8])

// Challenge 3
func keepOnlyOdds(ints: [Int]) -> [Int] {
    let oddArray = ints.filter{$0 % 2 != 0}
    return oddArray
}
keepOnlyOdds(ints: [1, 2, 3, 4, 5, 6])

// Challenge 4
func startingWithA(strings: [String]) -> [String] {
    let aArray = strings.filter{$0.hasPrefix("a")}
    return aArray
}
startingWithA(strings: ["hello", "apple", "angry", "red", "harty"])

// Challenge 5
func computeProduct(ints: [Int]) -> Int {
    let product = ints.reduce(1, *)
    return product
}
computeProduct(ints: [1, 2, 3, 2, 2, 4])

// Challenge 6
func concatenateAll(strings: [String]) -> String {
    let product = strings.reduce(""){$0 + $1}
    return product
}
concatenateAll(strings: ["Hello", "This", "Is", "Nick"])

