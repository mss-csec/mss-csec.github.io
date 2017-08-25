/*  Problem: J4/S2: Fraction Action
    Link: http://wcipeg.com/problem/ccc02s2

    Your solution consist of 3 parts, the whole number, the numerator, and the denomonator
    To change the improper fraction to a mixed fraction, divide the numerator by the denominator to get the whole number.
    After that, mod the numerator by the denominator to get a reduced numerator.
    For the fraction to be simplified, the numerator and the denominator must be relatively prime.
    That can be done by dividing the numerator and the denominator my their Greatest Common Factor.
    The GCF of two numbers can be found using Euclid's method, basically,
        -Have two variables x, and y. X is the greater of the two numbers, and y is the smaller of the two numbers.
        -Find the positive difference (d) between x and y.
        -If d>y, set x=d
        -If d<y, set x=y and y=d
        -If y=0, the GCF is x
        -Repeat the last 4 steps if the GCF is not yet found.
*/

#include <iostream>         // cout, cin
#include <algorithm>        // max, min

using namespace std;

int main(){
    int n,d,w;              // n is the numerator, d is the denominator, w stores the whole number
    cin >> n >> d;          // gets inputs

    // changes improper fraction to mixed fraction
    w = n/d;
    n = n%d;

    // finds the greatest common factor using Euclids method
    int a=n;
    int b=d;
    while(a!=0){         // if a=0, then the GCF of the numerator and the denominator is b
        int temp=b-a;    // finds the difference of b and a
        b=max(a,temp);   // have b be set to a if it larger or set to temp if ir is larger
        a=min(a,temp);   // have a be set to temp if it is smaller.
    }
    // divides both the numerator and the denominator by the GCF
    n/=b;
    d/=b;

    // outputs the whole number if the whole number is not zero of if the numerator is zero
    if(w!=0||n==0){
        cout << w << " ";
    }
    // outputs the fraction if the numerator is not zero.
    if(n!=0){
        cout << n << "/" << d;
    }

    return 0;
}
