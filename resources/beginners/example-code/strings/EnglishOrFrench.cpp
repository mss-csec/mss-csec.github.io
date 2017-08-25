/*
    Question: English or French
    Link:http://wcipeg.com/problem/ccc11s1

    The program takes lines of text and determines the language of the text based on the number of S's and T's
    This means that we need to count the number of T's and S's in the text
    This solution uses two integer variables which store the number of S's and T's.
    In the beginning, the two counters are set to 0 as (so far) no S's or T's have been counted.
    The program will look through every single character in the text using a for loop and check for any T's or S's
    After checking all lines of text, the number of T's and S's found are compared
*/

#include <iostream>     // cout, cin, getline, ignore
#include <string>       // string

using namespace std;

/*
    General rules of thumb when using both getline() and cin in one program:
        place cin.ignore(0) before getline()
        place cin.ignore() after cin >> ___;
*/

int main(){
    // the first input given is the number of lines in the text
    int numLines;
    cin >> numLines;
    cin.ignore();               // ignores the whitespace

    string line;                // string that will store the input, line by line

    // counters for the number of T's and S's
    int numOfT=0;
    int numOfS=0;

    // for loop used to check each line of text given as an input.
    for(int l=0;l<numLines;l++){
        // gets a line of text and saves it into the string
        cin.ignore(0);
        getline(cin,line);

        // each character in the string container must be looked at. Use another for loop.
        for(int i=0;i<line.length();i++){
            // increases numOfT by one if a t or T is found
            if(line[i]=='t' || line[i]=='T'){
                numOfT++;
            }
            // increases numOfS by one if a s or S is found
            else if(line[i]=='s' || line[i]=='S'){
                numOfS++;
            }
        }
    }

    // now that we've finished counting, we just need to compare the number of S's and number of T's.
    if(numOfS>=numOfT){
        cout<<"French";
    }
    else{
        cout<<"English";
    }

    return 0;
}
