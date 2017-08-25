/*  Problem: Zero That Out
    Link: http://wcipeg.com/problem/ccc15s1

    A stack is used to store all the boss' statements
    If the boss says zero, the top of the stack is popped.
    After all the boss' statements, all the values left in the stack are added.

*/

#include <stack>            // stack
#include <iostream>         // cin, cout

using namespace std;

int main(){
    int numStatements;      // number of statements from the boss
    cin >> numStatements;
    int n;
    stack<int> numbers;     // stack that stores all the boss' statments

    // gets the input for each of the boss' statements
    for(int i=0;i<numStatements;i++){
        cin >> n;
        // if the boss' statement is 0, the top element in the stack is popped
        if(n!=0){
            numbers.push(n);
        }
        // otherwise, the boss' statement is added to the stack
        else{
            numbers.pop();
        }
    }
    int sum=0;  // the sum of all the boss's statements

    // continues adding elements to the sum until there are no more elements in the stack
    while(!numbers.empty()){
        sum+=numbers.top();
        numbers.pop();
    }
    cout<<sum;  // outputs the sum

    return 0;
}
