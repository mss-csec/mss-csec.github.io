/*  Problem: Aromatic Numbers
    Link: http://wcipeg.com/problem/ccc12s2

    The input will always be a string with an even number of characters.
    Each Roman Numeral Character corresponds to a specific integer value.
    A map can be used to map out characters to integers.
    The value of a pair is negative if the Roman Nummeral in the pair has a lower value than that of pair to its right.
    A for loop is used to read the string backwards. By reading the string in reverse, the value of the Roman Numeral in a pair can be stored to be compared with the next pair.
*/

#include <iostream>             // cout, cin
#include <map>                  // map
#include <string>               // string

using namespace std;

int main(){
    // creates a map, each character maps to a specific integer value
    map <char,int> numerals;
    // assigns values to the map
    numerals['I']=1;
    numerals['V']=5;
    numerals['X']=10;
    numerals['L']=50;
    numerals['C']=100;
    numerals['D']=500;
    numerals['M']=1000;

    string input;
    cin >> input;

    // sum stores the current value of the aromatic number
    int sum=0;
    // prevValue stores the roman numeral value of the pair last checked. Starts off as 0.
    int prevValue=0;
    // loops through each pair of characters in the sting starting with the last pair.
    for(int i=input.length()-1;i>0;i-=2){
        // if the value of the roman numeral in the current pair is less than the value of the previous roman numberal, the value of the pair is subtracted.
        if(numerals[input[i]]<prevValue){
            sum-=numerals[input[i]]*(input[i-1]-'0');
        }
        // otherwise, the value is added to the sum.
        else{
            sum+=numerals[input[i]]*(input[i-1]-'0');
        }
        // prevValue is updated to be the roman numeral of the pair currently looked at.
        prevValue=numerals[input[i]];
    }

    cout<<sum;                  // outputs the value of the aromatic number

    return 0;
}
