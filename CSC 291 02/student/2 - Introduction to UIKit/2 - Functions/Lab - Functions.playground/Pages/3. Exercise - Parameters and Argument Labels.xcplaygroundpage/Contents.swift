/*:
## Exercise - Parameters and Argument Labels
 
 Write a new introduction function called `introduction`. It should take two `String` parameters, `name` and `home`, and one `Int` parameter, `age`. The function should print a brief introduction. I.e. if "Mary," "California," and 32 were passed into the function, it might print "Mary, 32, is from California." Call the function and observe the printout.
 */
func introduction(name: String, home: String, age: Int) {
    print("\(name), age \(age), is from \(home).")
}

introduction(name: "Michael", home: "Virginia", age: 20) //it already printed it out because you are basically still doing introduction()


/*
 
 Think of Java's way of doing it
 
 
 public Square(int aSide, String aColor) {
 System.out.println(aSide + "is your side");
 System.out.println(aColor + "is your color");
 }
 
 public Square(28, "Yellow");
 
 */
//:  Write a function called `almostAddition` that takes two `Int` arguments. The first argument should not require an argument label. The function should add the two arguments together, subtract 2, then print the result. Call the function and observe the printout.
func almostAddition(_ x: Int, y: Int) { //the underscore is needed to make use of no arguments
    print("\((x + y) - 2) is your answer using \"almostAddition\" ")
}

almostAddition(2 ,y: 5) //No argument label
//:  Write a function called `multiply` that takes two `Double` arguments. The function should multiply the two arguments and print the result. The first argument should not require a label, and the second argument should have an external label, `by`, that differs from the internal label. Call the function and observe the printout.
func multiply(_ a: Double, times b: Double) { //times can be anytinhg, it's mainly to help read what the params do
    
    print("\((a * b)) is your answer using \"multiply\" ")
    
    
}

multiply(2.3, times: 5.7)
/*:
[Previous](@previous)  |  page 3 of 6  |  [Next: App Exercise - Progress Updates](@next)
 */
