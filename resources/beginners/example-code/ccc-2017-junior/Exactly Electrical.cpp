/* Problem: J3 Exactly Electrical

The minimum distance between 2 points can be found by adding the x distance and the y distance together.
The problem can be thought out as two number lines.
When the car passes the destination by n streets, it takes another n electrical units for the car to go back to the destination.
Therefore, the remaining electrical energy in the car after reaching its destination must be even.
*/

#include <iostream>             // cout, cin
#include <stdlib.h>             // abs
using namespace std;

int main(){
    int a,b,c,d,t;
    cin >> a >> b >> c >> d >> t;
    // mininum stores the minimum amount of energy needed to reach the destination
    int minimum=abs(c-a)+abs(d-b);
    // checks if the car can reach its destination and has an even number of energy left
    if(t<minimum||(t-minimum)%2==1){
        cout<<'N';
    }
    else{
        cout<<'Y';
    }

    return 0;
}
