/*  Problem: Eliminanagram
    Link: http://wcipeg.com/problem/smac081p1

    Each string input will only consist of lowercase letters.
    Each pair of the same characters are removed. If there are any remaining characters after removing every pair, the words are not eliminanagrams.
    If the total number of times a character appears in both strings is odd, then there will be one character left out when pairing.
    Therefore, for two words to be eliminanagrams, the number of times each character appears in both strings must be even.

    The program will count the number of times each character appears in both strings and store it into a 26-element array
    Each element in the array stores the number of times a letter appears in both strings. Every element starts off as 0 in the beginning.
    After counting the number of times each character appears in the array, the program checks if the value of each element is even.
    If every element in the array is even, the words are elmininagrams, otherwise, they are not.

*/

#include <iostream>         // cin, cout
#include <string>           // string container
using namespace std;

int main(){
    int numChar[26];            // stores the number of times a character appears in the strings
    for(int a=0;a<26;a++){      // sets each element in the array the value of 0.
        numChar[a]=0;
    }
    string str;                 // stores string input
    bool isElim=true;           // stores if the words are eliminanagrams (assumes they are at first)

    for(int i=0;i<2;i++){               // loops twice so that it takes two string inputs
        cin>>str;
        for(int s=0;s<str.size();s++){  // loops through every character in the string
            // numChar[0] stores the number of times 'a' occurs in the strings, so as numChar['a'-'a'].
            // Therefore, numChar[str[s]-'a'] stores the number of times str[s] occurs in the strings
            numChar[str[s]-'a']++;
        }
    }

    for(int a=0;a<26;a++){      // loops through every element in the array
        if(numChar[a]%2==1){    // checks if the value of each element is odd, if they are, the words are not eliminanagrams
            isElim=false;
            cout<<"No";
            break;              // stops checking if the words are eliminanagrams
        }
    }

    if (isElim){                // outputs "yes" if the words are eliminanagrams
        cout<<"Yes";
    }
    return 0;
}
