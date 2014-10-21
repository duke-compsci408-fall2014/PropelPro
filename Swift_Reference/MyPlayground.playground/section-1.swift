// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var highscore :Int = 100
var firstname = "Chip"
var isActive = false
var floatingPoint :Float

let daysInWeek = 7 //let is to make a constant

println("This is my high score: \(highscore)")

if (isActive){
    println("hello World")
}else{
    println("goodbye world")
}

for i in 1..<5 {
    println(i)
}

func greeting(name:String, var number:Int)->String{
    println("Hi \(name) you are number \(number)")
    return "Done"
}

greeting("Jeff", 9) //the input parameter in swift is a constant by default

//dictionary declaration
var state :[String:String] = ["CA":"California"]

//optional variables
var temperature : Int? // if there is no value assign to it, this is how swift able to assign a nil value to a variable

temperature = 73

if temperature != nil {
    println("The temperature is \(temperature) degrees")
    //when this print it will print "The temperature is optional(73) degrees" where as
    println("The temperature is \(temperature!) degrees")
    //will print "The temperature is 73 degrees" this method is force unwrapping. This will error if the variable is nil
}
//a variable pull from a dictionary is a optional variable as it can contain a nil


//Enumerations in Swift

enum SeatPreference{
    case Middle
    case Aisle  // each case is regarded as a member of the enumeration of SeatPreference
    case Window
    case NoPreference
}

var jenPrefers : SeatPreference
jenPrefers = .NoPreference //since jenPrefer is of type SeatPreference you only need to just access the member of the type seat preference

//jenPrefers = SeatPreference.NoPreference // same thing as above

//switch case for enum
switch jenPrefers {
case .Middle:
    println("book me on middle")
case .Aisle:
    println("book me on aisle")
case .Window:
    println("book me on window")
case .NoPreference:
    println("suprise me")
}

//closure (function without a function name
//standard function 
func standardFunct (){
    println("This is a simple function")
}

var num = 10
//standard closure
let myClosure = {()->() in
    println("This is a simple closure.")
}

// closures are written so that they can be passed around 
//below is a function that uses a closure
                      //here closure is accepted as a parameter
func performFiveTime( closure:()->() ){
    for i in 1...5{
        closure()
    }
}
performFiveTime(myClosure)


// closures with parameter and values
//sorted is a built-in function in Swift
//sorted(arrayToSort, closureToCompare)

let unsortedArray = [2,6,2,6,7,8]

let comparisonClosure = { (first:Int, second:Int)->Bool in
        return first<second
}
sorted(unsortedArray,comparisonClosure)

//Defining clases

class Player{
    //properties
    var name : String = "John Doe"
    var score : Int = 0
    
    //methods 
    func description(){
        println("Player \(name) has a score of \(score)")
    }
}

var jake = Player() // instantiating a new player object
jake.name = "Jake"
jake.score = 23
jake.description()

// using constructors

class PlayerTwo{
    //properties
    var name : String
    var score : Int
    
    //default initializer
    init() {
        name = "John"
        score = 0
    }
    //initalizaer that takes in a parameter
    init(name:String){
        self.name = name
        self.score = 0 //self. is the same as this.
    }
    
    //methods
    func description(){
        println("Player \(name) has a score of \(score)")
    }
}

var john = PlayerTwo()
john.description()

//using constructor by passing in parameters
var jack = PlayerTwo(name:"Jack")
jack.description()


//inheritance in swift
//subclass : superclass
class GoldPlayer : Player {
    func newMethod(){
        //...
    }
    
    //to override a method defined in a superclass
    override func description() {
        println("****GOLD STATUS****")
        super.description() // call method in superclass
        println("****GOLD STATUS****")
    }
    
}

//calling methods in another class
//it is similar - instanciate an object, then call it like normal using a .Method()
//if the method has paramters, one must name the paramters 
//example:

class Example{
    func multipleParams(first:Int, second: Int){
        println("first time second is \(first*second)")
    }
}

var exampleObj = Example()
//exampleObj.multipleParams(112,122) // wont compile ...error
exampleObj.multipleParams(111, second: 234) //correct way

//Keywords - public, private , internal (aka protected)
//use these keyword like in java


//swift use TUPLES!!!









