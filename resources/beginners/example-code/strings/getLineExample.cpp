#include <iostream>
#include <string>

using namespace std;

/*
    getline() must be used instead of cin when getting string inputs that have spaces in them
    cin.ignore() is usually used along with getline()
*/

int main(){
    string line;
    cout << "Input a Sentence!"<<endl;

    do{

        // so any inputs going into the console is stored in an "input buffer".
        // getline reads anything within the buffer
        // cin.ignore discards anything from the buffer
        cin.ignore(0);
        getline(cin,line);

        cout << "Your sentence is: " << line << endl;   // outputs line
        cout << "Add another sentence!" << endl;
    }while(1);

    return 0;
}
