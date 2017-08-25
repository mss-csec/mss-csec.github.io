#include <iostream>     // cout, cin
using namespace std;

int main(){
    int exponent=0;     // stores the exponent of a power of 2
    /*
        Make sure that the exponent first starts at 0.
        2^0 happens to be 1.
    */
    int power=1;        // stores the value of the power

    int n;              // variable to store positive integer
    cin >> n;           // asks for input

    while(power<n){     // continues raising the exponent of the power until the power is greater/equal to n
        power*=2;
        exponent++;
    }
    cout<<exponent;     // outputs the exponent

    return 0;
}
