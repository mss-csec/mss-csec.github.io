/*  Problem: J4 Time on Task
    Link: http://wcipeg.com/problem/ccc13j4

    In order to maximize the number of chores you are able to do, always start with chores that take the least amount of time.
    Have an array that stores the time it takes to do each chore.
    Sort the array so that the array goes from least to greatest.
    Have an integer variable (timeLeft) that stores the amount of time left to do chores.
    Go through the array from the beginning and continually subtract elements from timeLeft until timeLeft is negative.
    Keep track of how many chores you are able to do until timeleft is negative.
*/

#include <iostream>         // cin, cout
#include <algorithm>        // sort

using namespace std;

int main(){
    int timeLeft,numChores;         // the time left to do chores, the number of possible chores to do
    cin >> timeLeft >> numChores;   // gets inputs
    int chores[numChores];          // array that stores the time it takes to do each chore
    for(int i=0;i<numChores;i++){   // gets inputs for chores
        cin >> chores[i];
    }

    // sorts the array so that the chores that take the least amount of time are at the front of the array
    sort(chores,chores+numChores);

    int tasksDone=0;                    // counter used to count the number of chores completed
    for(tasksDone=0; tasksDone<numChores; tasksDone++){
        timeLeft-=chores[tasksDone];    // The time remaining is subtracted by the time it takes to do a chore
        if(timeLeft<0){                 // if timeleft is negative, the chore is not completed in time.
            break;                      // Leaves the loop, tasksDone will store the maximum possible chores you can do.
        }
    }
    cout << tasksDone;              // output message
    return 0;
}
