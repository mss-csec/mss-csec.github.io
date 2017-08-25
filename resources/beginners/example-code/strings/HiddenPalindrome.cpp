/*
    Question: Hidden Palindrome
    Link: http://wcipeg.com/problem/ccc16j3

    To check if a string/substring is a palindrome, the string must be processed from inside out.
    Starting with a centre character(s), the surrounding two characters must be the same.
    From there, the next two surrounding characters must be the same, and so on.

    For Example, in "QWEREWQ", R is surrounded by 2 E's, which are surrounded by 2 W's, which are surrounded by 2 Q's

    As long as each pair of surrounding characters matched each other, the string will still be considered a palindrome.

    This method can be used to find the longest palindrome in a word.
    An integer variable is used to store the size of longest palindrome known so far.
    A for loop will go through every character in a string. Each time, it will assume that character will be the centre of a palindrome.
    The program determines how long the palindrome can be, by continuously  checking if pairs of surrounding characters are the same.
    Once the palindrome ends, the program checks if the size of the palindrome is greater than the size of the longest palindrome known so far.
    If the palindrome just found is longer than the previous longest palindrome, the size of the longest palindrome known so far is updated.

    There are 2 types of palindromes that should be checked:
        -palindromes that have an odd number of characters; there will be an unpaired character at the centre of the palindrome (Ex:anana)
        -palindromes that have an even number of characters; all characters will be paired with another (Ex: abccba)
    The code must test for both types of palindromes
*/

#include <iostream> //cin, cout
#include <string>   //string

using namespace std;

int main(){

    string word;                        // string to store word to check
    cin>>word;

    int longest=0;                      // stores the size of the longest palindrome known so far

    //Case 1, when the palindrome has an odd number of characters
    for(int i = 0;i<word.length();i++){
        //pSize stores the size of the palindrome with its centre at index (i)
        int pSize=1;                    // a single character (Ex: "a") is still a palindrome, so pSize is set as 1 initially

        // logical operators (&&) can be placed in the condition statement of a for loop
        // j is a variable used to store the distance between the centre character and the pair of characters to be checked
        // j will continue to increase by one until i-j or i+j are out of bounds of the string (String do not have an element with an index of -1)
        for(int j = 1; i-j>=0 && i+j < word.length(); j++){
            // if the pair of surrounding characters match, the size of the palindrome increases by 2
            if(word[i-j] == word[i+j]){
                pSize += 2;
            }
            // if the pair of surrounding characters do not match, the palindrome ends and we exit this loop.
            else{
                break;
            }
        }
        // checks if the size of the palindrome just found is greater than the size of the longest palindrome known so far
        // if the palindrome is longer than the longest palindrome we've found so far, the size of the longest palindrome known so far is updated to be the size of the palindrome just found
        if(pSize > longest){
            longest = pSize;
        }
    }

    // Case 2: when the palindrome has an even number of characters in them
    // The loop works the same way, but treats the centre as two characters instead of one
    for(int i = 0; i < word.length()-1;i++){
        // We can't say for sure that a palindrome with an even number of characters even exist, thus pSize is first set as 0
        int pSize=0;
        // j starts at 0 so that the program could check if the centre-most 2 characters are the same or not
        // rest of the code is similar to the section above
        for(int j = 0; i-j>=0 && i+j<word.length();j++){
            if(word[i-j] == word[i+j+1]){
                pSize+=2;
            }
            else{
                break;
            }
        }
        if(pSize > longest){
            longest = pSize;
        }
    }

    cout << longest;                  // writes our answer
    return 0;
}
