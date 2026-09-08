/*:
## Exercise - Ternary Operator
 
 Refactor the code below so that `largest` is declared and assigned to in one line using the ternary operator.
 */
let number1 = 14
let number2 = 25

var largest: Int
/*
if number1 > number2 {
    largest = number1
    print(largest)
} else {
    largest = number2
    print(largest)
}
*/
largest = number1 > number2 ? number1 : number2 //The (?) is OTHERWISE. TRUE : FALSE. num1 if TRUE and num2 if FALSE.
//If num1 > num2, make num1 largest OTHERWISE make num2 largest
print(largest)
/*:
[Previous](@previous)  |  page 8 of 9  |  [Next: App Exercise - Ternary Messages](@next)
 */
