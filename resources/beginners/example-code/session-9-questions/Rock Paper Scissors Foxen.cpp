/*  Problem: Rock Paper Scissors Fox
    Link: http://wcipeg.com/problem/acmtryouts1a

    The program will collect each line input ONE BY ONE and does one of the following:
    -If the input is "Rock", output "Paper"
    -If the input is "Paper", output "Scissors"
    -If the input is "Scissors", output "Rock"
    -If the input is "Fox", output "Foxen"
    -If the input is "Foxen", end the program

    The first integer input lists the maximum amount of inputs in the test case.
*/

#include <iostream>         // cout, cin
#include <string>           // string container

using namespace std;

int main(){
    int n;                  // stores the number of string inputs
    cin >> n;

    string s;               // string that stores the opponent's choice for each round

    for(int i=0; i<n; i++){
        cin >> s;           // gets the opponent's choice
        if(s == "Rock"){
            cout << "Paper" << endl;        // outputs paper if the opponent chose rock
        }
        else if(s=="Scissors"){
            cout << "Rock" << endl;         // outputs rock if the opponent chose scissors
        }
        else if(s=="Paper"){
            cout << "Scissors" << endl;     // outputs scissors if the opponent chose paper
        }
        else if(s=="Fox"){
            cout << "Foxen" << endl;        // outputs foxen if the opponent chose fox
        }
        else if(s=="Foxen"){                // leaves the for loop if the oppoenent chose foxen
            break;
        }
    }
    return 0;
}
