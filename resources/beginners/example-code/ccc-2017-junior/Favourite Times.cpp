/*  Problem: J4 Favourite Times
    Wendy's favourite times will be the same no matter what the value of D is.
    Therefore, all the favourite times can be hardcoded in using an array.
    There are 31 favourite times in a 12 hour cycle.
    The number of 12 hour cycles is first calculated; for every 12 hour cycle, 31 favourite times have passed.
    The remaining time (D%720) is then compared with all the favourite times in the array.
*/

#include <iostream>     // cin, cout
using namespace std;

int numTimes=31;        // the number of favourite times in a 12 hour cycle
// all the favourite times in a 12 hour cycle are put into an array in ascending order.
// instead of 1234, 34 is used because 12 o'clock is the same as 0 o'clock.
// It is just easier to work with 0 than 12; 1:00 is supposed to be greater than 12:00
int fTimes[31]={34,111,123,135,147,159,210,222,234,246,258,321,333,345,357,420,432,444,456,531,543,555,630,642,654,741,753,840,852,951,1111};

int main(){
    int D;              // the number of minutes after 12:00
    cin >> D;
    // numFavourite counts the number of favourite times that passed
    int numFavourite=numTimes*(D/720);      // counts the number of 12 hour cycles.
    D%=720;
    // changes D to a time so that it can be compared with all the times in fTimes
    int time=D/60*100+D%60;
    // checks time with all elements in fTImes until time is less than a favourite time.
    for(int i=0;i<numTimes;i++){
        if(time>=fTimes[i]){
            numFavourite++;
        }
        else{
            break;
        }
    }
    cout << numFavourite;

    return 0;
}
