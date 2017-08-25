/*
    Question: Happy or Sad
    Link: http://wcipeg.com/problem/ccc15j2

    The program must check the number of occurrences of sad and happy faces in a given line of text
    Two integer variables must be used to store the number of instances a happy/sad face appears
    Every 3 adjacent characters must be checked to see if a face can be made.
    A for loop is used to check every 3 adjacent characters
    After looking through the string, the number of happy faces and the number of sad faces are compared
*/

#include <iostream>     // getline(),cout
#include <string>       // string

using namespace std;

int main(){
    string line;            // stores the inputted text

    getline(cin,line);      // reads the line

    // two variables used to count the number of happy and sad faces
    int numHappy=0;
    int numSad=0;

    // Since happy and sad faces are composed of 3 characters, a two character string cannot be an entire face.
    // this for loop will check every 3 adjacent characters.
    // Index 'i' only needs to go up to the last index where a happy/sad face can begin
    for(int i=0;i<line.length()-2;i++){
        // checks the character at index i, as well as the two characters after it.
        if(line[i]==':'&&line[i+1]=='-'&&line[i+2]==')'){
            numHappy++;
        }
        else if(line[i]==':'&&line[i+1]=='-'&&line[i+2]=='('){
            numSad++;
        }
    }

    // Print, depending on the number of sad/happy faces
    if (numHappy == 0 && numSad == 0){
        cout << "none";
    }
    else if(numHappy==numSad){
        cout << "unsure";
    }
    else if(numHappy>numSad){
        cout << "happy";
    }
    else{
        cout << "sad";
    }
    return 0;
}
