/*:
##  CSC 291 - Exam 2 - Midterm Exam All about Swift

 - Able to define constant variable using let and assign value
 - Able to calcuate value and store in constant variable
 - Able to define String
 - Able to use String concatenation (+)  as well as String Interpolation
 - Able to write and call basic function
 - Able to write and manipulate collectin/array usig loop
 
 
You will have submit the playground file, as well as screenshot of each question, you may combined multiple questions on one screen
 

 */

// Type your full name in comment below
// Name: Michael Kwabena Amoo
// ID: 00549396


/*:
## Question 1 - Define Integer, String and using + for String Concatenation

 You will read the comments to declare/define a constant variable and assign value to it
 
 */

// Declare 3 integer constants - num1, num2, and num3
// then assign any integer values to them
let num1 = 1;
let num2 = 2;
let num3 = 3;


// Declare 1 integer constant for sum, and then assign the total of num1, num2, and num3 to sum
let sum = num1 + num2 + num3


// Declare 1 constant for average and find the average of num1, num2, and num3
let average = sum / 3

// Declare a firstName constant and assign your own first name
let firstName = "Michael"

// Declare a lastName constant and assign your own last name
let lastName = "Amoo"

// Declare a major constant and assign your own major

let major = "Cyber Security"
// Declare a age constant and assign your own age
let age = 20

// Combine the strings into a fullName constant - make sure that you put a space in between -- using String concatention
let fullName = firstName + " " + lastName

// Print fullName and major and age using String concatenation
print(fullName + " " + major + " " + String(age))

// Print fullName and major and age using String Interpolation

print("\(fullName) - \(major) - \(age)")
// Combine your full name with major -- should say full name is majoring in ...

print("\(fullName) is majoring in \(major)")
/*:
## Question 2 - Functions

  You will read the comments to declare/define a constant variable and assign value to it
  
 
 */
//:  Write a function call welcome that takes one `String` argument - name, nothing return. The function will print "Welcome, name, to the Department of Computer Science"
// start your function here
func welcome(name: String) {
    
    print("Welcome, \(name), to the Department of Computer Science")
    
}

// call welcome with your firstName as parameter
welcome(name: firstName)

// call welcome with your fullName as parameter
welcome(name: fullName)


//:  Write a function call tripleply that takes two `Int` arguments (num1 and num2), and returns an `Int`. The function should multiply the two arguments, add 3, then return the result. Use the function and print the result.
// start your function here
func tripleply(num1: Int, num2: Int) -> Int {
    
    return (num1 * num2) + 3
}

// call tripleply and print result  3 times -- you can give any values that you like

print(tripleply(num1: 2, num2: 4))
print(tripleply(num1: 9, num2: 9))
print(tripleply(num1: -1, num2: 7))

/*:
## Question 3: Collection and Loops
  
 
 */

// Define an array of String call shoppingList, and you will initialize 5 items in this shoppingList

var shoppingList: [String] = ["eggs", "bacon", "grits", "hot dog", "cheese"]
// replace the 3rd item with "Cantalop"
shoppingList[2] = "ham"

// remove the last item in the list

shoppingList[4] = ""

// add to more items usig +=


// using a for loop to print each items in the shopping list

var count: Int = 0
while (count < shoppingList.capacity) {
    
    print(shoppingList[count])
    count += 1
}


// :Dictionary
// Define a Dictionary [String: Int] called ageList where each person name, will have integer value representing thier age.  You will initialize 3 records (make up data) of 3 names and their age.


// add another person name Sara, with her age of 18


// using a loop to print each person and their again


// using a loop to find the average age (Hint: find sum and divide by count)


/*:

 ## Submission
 
  Make sure that you have all screenshots of code and output
  Submit .playground file - make sure to use chrome so it zip the entire package
   and all screenshots
  
 
 */
