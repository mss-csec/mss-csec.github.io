/*  Problem: Assigning Partners
    Link: http://wcipeg.com/problem/ccc14s2

    If the number of students in the test case is odd, then there will always be one person without a pair.
    A map is used to link each student with its partner.
    An array is used to store all the students inputted in order

    For two students to be a pair, both students must have each other as partners.
    If a student is found to be partners with himself, the pairings do not work.
    If it is found that a student has a partner that does not have him as his partner, then the pairings do not work.

    When recieving the name of a student's partner, the map is used to check if the student's partner has someone else as his partner.
    If he doesn't have someone else, then the map is updated to store the name of the student's partner.
    If he does, then the pairings do not work and the checking process ends.
*/

#include <map>              // map
#include <iostream>         // cin, cout
#include <string>           // string

using namespace std;

int main(){
    int numPeople;          // stores the number of students
    cin >> numPeople;
    // checks if the number of students is odd
    if(numPeople%2==1){
        cout<<"bad";
    }
    else{
        // map that links each student with its partner
        map<string,string> partners;
        string person;                      // string for input
        string players[numPeople];          // arrya that stores the names of all students

        // gets the name of every student
        for(int i=0;i<numPeople;i++){
            cin>>person;
            // the partner of each student is originally set to "", this means that the name of the partner has yet to be recieved
            partners[person]="";
            players[i]=person;
        }

        bool works=true;                    // stores whether the pairings work or not, assumes it does for now.
        for(int i=0;i<numPeople;i++){
            // gets the name of a student's partner
            cin>>person;
            partners[players[i]]=person;
            // checks if the student's partner has someone else as his partner, and if the student has himself as his partner
            if((partners[person]!=""&&partners[partners[person]]!=person)||partners[person]==person){
                works=false;
                break;
            }
        }

        // outputs message based on whether pairings work or not.
        if(works){
            cout<<"good";
        }
        else{
            cout<<"bad";
        }
    }

    return 0;
}
