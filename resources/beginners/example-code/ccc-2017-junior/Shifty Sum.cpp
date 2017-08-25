/* Problem: J2 Shifty Sum

When a number is "shifted" it is simply multiplied by 10.
Therefore, every number that needs to be added is n times a power of 10.
The first number to be added is n*10^0, and the last number to be added is n*10^k.
A for loop is used to add up all the numbers to get a shifty sum.
*/

#include <iostream>         // cin, cout
using namespace std;

int main(){
    int n,k;
    cin >> n >> k;

    int sum=0;              // stores the current shifty sum, starts off as 0 because nothing has been added yet.

    // variable 'a' in this for loop stores the power of ten that multiplies with n.
    // variable 'i' simply counts up to k.
    for(int a=1,i=0; i<=k; a*=10,i++){
        // The shifted value of n is added to the shifty sum.
        sum += a*n;
    }

    cout << sum;            // outputs the shifty sum
    return 0;
}
