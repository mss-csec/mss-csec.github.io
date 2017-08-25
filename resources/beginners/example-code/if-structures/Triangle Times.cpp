#include <iostream>     // cout, cin
using namespace std;

int main(){
    // initialzes varaibles to store all 3 angle values
    int a,b,c;
    // gets user input for all 3 variables
    cin >> a >> b >> c;
    // goes through an if statement

    // Best idea is to check if the angles form a triangle first
    if(a+b+c!=180){
        cout << "Error";
    }
    // Checks if the triangle is Equalateral
    else if(a==60 && b==60 && c==60){
        cout << "Equilateral";
    }
    // case where none of the angles are the same, the triangle is scalene
    else if(a!=b && a!=c && b!=c){
        cout << "Scalene";
    }
    // case where the triangle is Isosceles
    else{
        cout << "Isosceles";
    }

    return 0;
}
