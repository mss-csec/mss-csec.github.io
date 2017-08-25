/*  Question: S1 Ragaman
    Link: http://wcipeg.com/problem/ccc16s1

    We know that the 2 inputs will have no whitepsace in them, thus getLine will not be necessary.
    We know that the size of both strings will be the same.

    The solution to this problem will involve storing the number of times each character appears in a string.
    The first string is able to have fewer of one character than the second string, as an asterick can replace that missing character.
    The first string is NOT able to have more of one character than the second string as the first string has NO astericks.
    Thus, two words will be considered ragamans as long as a character does not occur more times in the second string than the first string (excluding the *)

    An 26-element array will be used to store the number of times a character appears in the first string, each element will start at 0.
    Then, the program will count the number of times each character appears in the first string.
    When going through each character in the second string, all astericks are ignored.
    In order for two words to be ragamans  the number of times a character is in string 1 must be greater than the number of times a character is in string 1
    That also means that the number of times a character is in string 1 MINUS the number of times a character is in string 2 CANNOT be less than 0
    If every element in the array is either 0 or positive, the two words are ragamans, otherise, they are not.

*/
#include <string>          // string container
#include <iostream>        // cout cin

using namespace std;

int main(){
    int numChar[26];        // stores the number of times a lowercase letter appears in string 1
    bool isRagaman=true;    // boolean to store whether the two words are ragamans, we assume they are ragamans to begin with
    for(int i=0;i<26;i++){  // Each element in the array starts off as 0.
        numChar[i]=0;
    }
    string str;             // string input

    // gets the first string input
    cin>>str;
    for(int i=0;i<str.length();i++){
        // All characters are given an ASCII int value
        // numChar[0] stores the number of times 'a' appears in the string. Likewise, numChar['a'-'a'] also stores the number of times 'a' appears in the string
        // Thus, numChar[str[i]-'a'] stores the number of times str[i] appears in the string
        numChar[str[i]-'a']++;
    }

    // gets the second string input
    cin>>str;
    for(int i=0;i<str.length();i++){
        if(str[i]!='*'){                    // ignores all astericks
            numChar[str[i]-'a']--;
            // if an element in numChar is less than 0, a character occurred in the second string more than the first string. That automatically makes the two words not ragamans
            if(numChar[str[i]-'a']<0){
                isRagaman=false;
                // stops checking if the words are ragamans
                break;
            }
        }
    }

    // outputs character based on whether isRagaman is true or false
    if(isRagaman){
        cout<<'A';
    }
    else{
        cout<<'N';
    }
    return 0;
}
