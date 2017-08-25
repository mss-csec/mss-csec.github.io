/*  Problem: Problem-setting Pandemonium
    Link: http://wcipeg.com/problem/mockccc15s2

    If you have multiple problems with the same difficulty, an original problem must be used for each.
    An example, with the following 6 difficulties: 3,3,3,2,2,1
    Since there are three questions with difficulty 3, there must be minimum three original problems to accomodate for those problems
    There must minimum two original problems to accomodate for the questions with difficult 2, and 1 original problem for the quesiton with difficulty 1.
    By having three original problems, there are enough original problems to create all the problems needed.

    Therefore, the minimum number of original problems needed is the number of times the most frequent difficulty appears in the test case.

    A 100 000 element integer array is used to store the number of times a difficulty appears as an input. All elements are set to 0 initially.
    The number of times each difficulty appears as an input is counted with a loop.
    After counting all the problems, the code looks through every element in the array and searches for the highest number in the array.
*/

#include <iostream>                         // cin, cout
#include <algorithm>                        // max

using namespace std;

int main(){
    int numProblems;                        // the number of problems given
    int difficulties[100000];               // stores the number of times each difficulty appears
    for(int i=0;i<100000;i++){              // sets all elements in the array to 0 initially
        difficulties[i]=0;
    }
    cin >> numProblems;                     // gets input for number of problems
    // n is used for getting an integer input, top stores the number of original problems needed
    int n,top=0;
    // gets the difficulty of each problem
    for(int i=0;i<numProblems;i++){
        cin >> n;                           // gets difficulty of a problem
        difficulties[n-1]++;                // counter for that difficulty increases by one
        top=max(difficulties[n-1],top);     // top gets updated if difficulties[n-1] is a higher number
    }

    cout << top;                            // output message
    return 0;
}
