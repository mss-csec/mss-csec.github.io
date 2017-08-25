#include <iostream>
#include <string>

using namespace std;


/*
    This is example code showing how loops can be used to access elements in a string
    Reverse string takes an input and outputs the reverse of that word
    This is done by adding characters from the last index of the string to the first character of the string
*/

int main(){

    // initializes a string
    string initialString;
    // A string could have no characters in it to start with. "" indicates an empty string
    string reverseString="";

    cout<<"Input a String:"<<endl;
    // gets string input
    cin >> initialString;

    // the program will start with the last character of string, then go all the way to the character iwth index 0
    // a for loop is used because the index of the string will decrease by 1 each loop
    for(int i=initialString.length()-1;i>=0;i--){
        // adding a string/char to another string is called concatenation. This could be done with the + operator
        reverseString+=initialString[i];    //adds the character from the initialstring into the reverse string
    }
    cout << "The reverse of " << initialString << " is " << reverseString;
}
