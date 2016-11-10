//: [Previous](@previous)
/*:
 `map`, `filter` and `reduce` are the most important building blocks in functional programming. In essence, all of them are abstractions over common operations on collections (e.g. arrays):
 
 1. `map` will take each element of a collection and _transform_ it to something else
 2. `filter` will _remove_ certain elements from an array that don't adhere to a given condition
 3. `reduce` _combines_ all the elements of an array and outputs a single value
 
 On this playground page, we will implement our own versions of these functions.
 
 ### Challenges
 
 Write the following functions:
 
 1. `func mapIntsToInts(array: [Int], transform: (Int) -> Int) -> [Int]` that applies the `transform` closure on each element in the input `array`
 2. `func mapIntsToStrings(array: [Int], transform: (Int) -> String) -> [String]` that applies the `transform` closure on each element in the input `array`
 3. `func filterInts(array: [Int], isIncluded: (Int) -> Bool) -> [Int]` that only keeps those elements from the input `array` for which `isIncluded` is `true`
 4. `func filterStrings(array: [String], isIncluded: (String) -> Bool) -> [String]` that only keeps those elements from the input `array` for which `isIncluded` is `true`
 5. `func reduceIntsToInt(array: [Int], initial: Int, combine: (Int, Int) -> Int) -> Int` that reduces all the elements in the input `array` to one single output element of type `Int` by applying the `combine` function to each intermediate result and the current value in the input `array`
 6. `func reduceStringsToStrings(array: [String], initial: String, combine: (String, String) -> String) -> String` that reduces all the elements in the input `array` to one single output element of type `String` by applying the `combine` function to each intermediate result and the current value in the input `array`
 7. `func map<T, U>(array: [T], transform: (T) -> U) -> [U]` that applies the `transform` closure on each element in the input `array`
 8. `func filter<T>(array: [T], isIncluded: (T) -> Bool) -> [T]` that only keeps those elements from the input `array` for which `isIncluded` is `true`
 9. `func reduce<T, U>(array: [T], initial: U, combine: (U, T) -> U) -> U`
 10. recursive versions of `map`, `filter` and `reduce` 😏
 */
// Challenge 1
func mapIntsToInts(array: [Int], transform: (Int) -> (Int)) -> [Int] {
    let newArray = array.map{transform($0)}
    return newArray
}
mapIntsToInts(array: [1, 2, 3, 4, 5]) { (myInt) -> (Int) in
    return myInt * 2
}

// Challenge 2
func mapIntsToStrings(array: [Int], transform: (Int) -> String) -> [String] {
    let newArray = array.map{transform($0)}
    return newArray
}
mapIntsToStrings(array: [1, 2, 3, 4, 5]) { (myInt) -> String in
    return String(myInt)
}

// Challenge 3
func filterInts(array: [Int], isIncluded: (Int) -> Bool) -> [Int] {
    let newArray = array.filter{isIncluded($0)}
    return newArray
}
filterInts(array: [1, 2, 3, 4, 5, 6]) { (myInt) -> Bool in
    return myInt%2 != 0
}

// Challenge 4
func filterStrings(array: [String], isIncluded: (String) -> Bool) -> [String] {
    let newArray = array.filter{isIncluded($0)}
    return newArray
}
filterStrings(array: ["apple", "red", "join", "angry"]) { (myString) -> Bool in
    return myString.hasPrefix("a")
}

// Challenge 5
func reduceIntsToInt(array: [Int], initial: Int, combine: (Int, Int) -> Int) -> Int {
    let newArray = array.reduce(initial){combine($0, $1)}
    return newArray
}
reduceIntsToInt(array: [1, 2, 3, 4, 5], initial: 0) { (firstInt, secondInt) -> Int in
    return firstInt + secondInt
}

// Challenge 6
func reduceStringsToStrings(array: [String], initial: String, combine: (String, String) -> String) -> String {
    let newArray = array.reduce(initial){combine($0, $1)}
    return newArray
}
reduceStringsToStrings(array: ["wow", "yeah", "cool"], initial: "output: ") { (firstString, secondString) -> String in
    return firstString + secondString
}

// Challenge 7
func map<T, U>(array: [T], transform: (T) -> U) -> [U] {
    //return array.map{transform($0)}
    
    var newArray: [U] = []
    for i in array {
        newArray.append(transform(i))
    }
    return newArray
}

// Challenge 8
func filter<T>(array: [T], isIncluded: (T) -> Bool) -> [T] {
    //return array.filter{isIncluded($0)}
    
    var newArray: [T] = []
    for i in array {
        if isIncluded(i) {
            newArray.append(i)
        }
    }
    return newArray
}

// Challenge 9
func reduce<T, U>(array: [T], initial: U, combine: (U, T) -> U) -> U {
    //return array.reduce(initial){combine($0, $1)}
    
    for i in array {
        combine(initial, i)
    }
    return initial
}

// Challenge 10 - Recusrion!
func map<T, U>(array: [T], result: [U] = [], transform: (T) -> U) -> [U] {
    
}

func reduce<T, U>(array: [T], result: U, combine: (T, U) -> U) -> U {
    
}

func filter<T>(array: [T], result: [T] = [], predicate: (T) -> Bool) -> [T] {
    
}
