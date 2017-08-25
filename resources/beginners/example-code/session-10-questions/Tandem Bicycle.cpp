/*  Problem: J5/S2 Tandem Bicycle
    Link: http://wcipeg.com/problem/ccc16s2

    In order to find the minimum total speed in a test case, the fastest biker in Dmojistan should be paired with the fastest biker in Pegland
    The second fastest biker in Dmokistan should be paired with the second fastest biker in Pegland and so on.
    In order to find the maximum total speed in a test case, the fastest biker in Dmojistan should be paired with the slowest biker in Pegland
    Similarily, the next fastest biker in Dmokistan should be paired with the next slowest biker in Pegland and so on.
    Two arrays are used to store the speeds of bikers in each country
    In order to find the fastest and slowest bikers in each group of bikers, both arrays must be sorted.
    When finding the Minimum speed, both arrays are sorted from least to greatest.
    When finding the Maximum speed, one array is sorted from least to greatest while another is sorted from greatest to least.
    An integer variable stores the collective speeds of all bikes.
    Biker i in the array storing Dmojistan speeds will be on the same bike as biker i in the array storing Pegland speeds.
    The speed of each bike is determined by taking the maximum of the two speeds of the two players on the bike
    The speed of all the bikes is calculated, then outputted.
*/

#include <iostream>         // cin, cout
#include <algorithm>        // max, sort

using namespace std;

int main(){
    int question,numPlayers;        // stores question number, stores number of bikers in each country
    cin >> question >> numPlayers;  // gets inputs
    int dSpeeds[numPlayers];        // array that stores the speeds of all bikers in Dmojistan
    int pSpeeds[numPlayers];        // array that stores the speeeds of all bikers in Pegland

    // gets speeds for each biker in both countries
    for(int i=0;i<numPlayers;i++){
        cin >> dSpeeds[i];
    }
    for(int i=0;i<numPlayers;i++){
        cin >> pSpeeds[i];
    }

    // sorts both arrays from least to greatest
    sort(dSpeeds,dSpeeds+numPlayers);
    sort(pSpeeds,pSpeeds+numPlayers);

    // if the questions asks for the maximum total speed, the pSpeed array is reversed so that its speeds go from greatest to least
    if(question==2){
       for(int i=0,j=numPlayers-1;i<j;i++,j--){     // reverses array by swapping outer elements with each other
            int temp=pSpeeds[i];
            pSpeeds[i]=pSpeeds[j];
            pSpeeds[j]=temp;
       }
    }

    int totalSpeed=0;                           // stores the collective speed of all bikes
    // goes through each pair of bikers
    for(int i=0;i<numPlayers;i++){
        // adds the speed of each bike to totalSpeed, the speed of the bike is the greater of the two biker speeds
        totalSpeed+=max(pSpeeds[i],dSpeeds[i]);
    }

    cout << totalSpeed;                         // outputs message
    return 0;
}
