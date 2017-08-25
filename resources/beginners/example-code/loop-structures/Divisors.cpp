#include <iostream>     // cout, cin
using namespace std;

/*
    The simplist way to find all the divisors of a number is to try all numbers from 1 to that number
    A for loop can be used since the number to check always increases by one
*/

int main(){
    int n;                      // variable "n" used to store the number
    cin >> n;                   // asks for input

    for(int i=1; i<=n; i++){    // tests all numbers from 1 to n
        if (n%i == 0){          // checks if n is divisble by i.
            cout << i << endl;
        }
    }
    return 0;
}
