/* Problem: J1 Quadrant Selection

Use 3 if statements and an else statement.
If the x coordinate is positive and the y coordinate is positive, the point is in quadrant 1.
If the x coordinate is negative and the y coordinate is positive, the point is in quadrant 2.
If the x coordinate is negative and the y coordinate is negative, the point is in quadrant 3.
If the x coordinate is positive and the y coordinate is negative, the point is in quadrant 4.

*/

#include <iostream>         // cout, cin

using namespace std;

int main(){
    int x,y;                // x coordinate and y coordinate
    cin>>x>>y;

    // Set of if statements to determine the quadrant of the point
    if(x>0&&y>0){
        cout<<1;
    }
    else if(x<0&&y>0){
        cout<<2;
    }
    else if(x<0&&y<0){
        cout<<3;
    }
    else{
        cout<<4;
    }

    return 0;
}
