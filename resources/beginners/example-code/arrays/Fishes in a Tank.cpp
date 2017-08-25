/*  Problem: Fishes in a Tank
    Link: http://wcipeg.com/problem/wc96p1

    An integer array will store the number of fish in each level
    A stack will contain a fish in every level from the top of the stack to the bottom of the stack.
    When receiving a stack, the program will add 1 to every level from the top level to the bottom level of the stack
    The x and y coordinates of the stack of fish are irrelevant to solving this question. All that is needed is the upper level and the bottom level of each stack
    After all stacks have been accounted for, the program goes through each level to see which level has the most fish.

    This process loops 4 more times
*/

#include <iostream>         // cout, cin

using namespace std;

int main(){
    for(int a=0;a<5;a++){                   // Looks at a total of 5 data sets
        int n;                              // number of levels in the fish tank
        cin >> n;
        int level[n];                       // integer array that stores the number of fish in each level
        for(int i=0;i<n;i++){               // sets the value 0 to each element of the array
            level[i]=0;
        }

        // to express how the x and y coordinates are not needed, they will be referred to as garbage inputs
        int garbage1,garbage2,top,bot;              // top stores the top-most level of a stack, and bot stores the bottom-most level of a stack
        while(true){
            cin >> garbage1 >> garbage2 >> top >> bot;          // stores the 4 inputs of each stack
            // leaves the loop if all 4 inputs are zeroes
            if(garbage1==0 && garbage2==0 && top==0 && bot==0){
                break;
            }
            // adds 1 to every level the stack is within
            for(int i=top;i<=bot;i++){
                level[i-1]++;
            }
        }

        int highestValue=0;             // the highest number of fish in a level known so far
        int highestLevel=1;             // the level that contains the highest number of fish so far
        for(int i=0;i<n;i++){           // finds the top-most level with the most fish
            if(level[i]>highestValue){  // if the program finds a level with more fish, highestValue & highestLevel are updated
                highestValue=level[i];
                highestLevel=i+1;
            }
        }
        cout << highestLevel << endl;   // outputs the level with the most fish
    }
    return 0;
}
