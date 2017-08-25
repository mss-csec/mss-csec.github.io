/*  Problem: Multiple Choice
    Link: http://wcipeg.com/problem/ccc11s2

    A character array stores the correct answer for each question
    The program then takes the student's response for each question one by one and compares it to the answer
    A counter variable stores how many times the student response and the answer are correct
*/

#include <iostream>     // cout, cin
using namespace std;

int main(){
    int numQuestions;                   // stores the number of questions in the test
    cin >> numQuestions;
    char answers[numQuestions];         // character array that stores the correct answer for each question
    for(int i=0;i<numQuestions;i++){    // stores the solution for each question in the array
        cin >> answers[i];
    }
    int numCorrect=0;                   // counts the number of times a student got a correct answer
    char response;                      // stores a students reponse to a question
    for(int i=0;i<numQuestions;i++){
        cin >> response;                // gets student's reponse
        if(response==answers[i]){       // checks if the student's answer is correct, if it is, then numCorrect increases by 1
            numCorrect++;
        }
    }
    cout << numCorrect;                 // outputs numCorrect
}
