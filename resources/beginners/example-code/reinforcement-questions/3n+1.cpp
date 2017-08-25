/*  Problem: 3n+1
    Link: http://wcipeg.com/problem/3nplus1

    The program will continuoulsy perform operations to n until n=1.
    The program will also count the number of operations done to n until n=1.
    A counter variable is used to store the number of times an operation is done to n.
    Once n=1, the program will output the value of the counter variable.
*/

#include <iostream>         // cin, cout

using namespace std;

int main(){
    int n;
    cin >> n;
    int counter=0;                  // counter variable, counts the number of operations done on n, starts off as 0
    // a for loop is used, before every loop, the program will check if n=1, after every loop, the counter variable increases by 1
    for(;n!=1;counter++){
        if(n%2==0){                 // divides n by 2 if n is even
            n=n/2;
        }
        else {                      // multiples n by 3 and adds 1 if n is odd
            n=3*n+1;
        }
    }
    // outputs the counter variable
    cout <<counter<< endl;

    return 0;
}
