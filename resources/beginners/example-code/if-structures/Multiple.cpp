#include <iostream>             //cout, cin
using namespace std;

int main(){
    //initializes two variables to store 2 positive integers
    int x,y;
    //gets input for the 2 integers
    cin>>x>>y;

    /*
        for x to be a multiple of y, x has to be divisable by y
        That means the remainder when x is divided by y must be 0
        The modulus (%) operator can be used to find the remainder
    */

    // checks if the remainder of x/y is 0
    if (x%y == 0){
        cout << "yes";
    }
    // outputs "no" if x is not a multiple of y
    else{
        cout << "no";
    }
    return 0;
}
