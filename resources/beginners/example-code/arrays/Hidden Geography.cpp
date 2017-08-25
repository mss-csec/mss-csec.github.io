/*  Problem: Hidden Geography
    Link: http://wcipeg.com/problem/wc96p3

    str.find() is a method in the string library that can be used to check if a string is found inside another string
    The program will have a string that stores the line that needs to be checked.
    It will also have 2 string arrays that stores the names of each province.
        - 1 array is for checking if the province appears in a line of text
        - 1 array is for outputing the province name
    Since uppercase and lowercase letters can be used to form a word, It is best to change all upeercase letters to lowercase letters
    Ex: OnTARIO -> ontario
    Since each input line can have punctuation that should be ignored, all characters that are not letters should be ommitted from the string
    Ex: on tar i o ->  ontario

    After modifying the line of text, str.find() can be used to check if a province name is found in the string
*/

#include <iostream>                 // getline(), cin, cout
#include <string>                   // string container

using namespace std;

int main(){
    string line;                    // string that stores each line input
    string check[10];               // array of strings that stores the name of each province but with no spaces or UpperCase Letters
    string result[10];              // array of strings that stores the name of each province

    // assigns values to each element in the result array
    result[0]="British Columbia";
    result[1]="Alberta";
    result[2]="Saskatchewan";
    result[3]="Manitoba";
    result[4]="Ontario";
    result[5]="Quebec";
    result[6]="Nova Scotia";
    result[7]="Newfoundland";
    result[8]="New Brunswick";
    result[9]="PEI";

    // assigns values to each element in the check array
    check[0]="britishcolumbia";
    check[1]="alberta";
    check[2]="saskatchewan";
    check[3]="manitoba";
    check[4]="ontario";
    check[5]="quebec";
    check[6]="novascotia";
    check[7]="newfoundland";
    check[8]="newbrunswick";
    check[9]="pei";

    for(int p=0;p<5;p++){                   // the program will look at 5 lines of text in total
        bool isfound=false;                 // stores whether a province is found, assumed to be false to begin with
        getline(cin,line);                  // gets line input

        // takes the line input and removes the spaces and changes uppercase letters to lowercase letters
        for(int j=0;j<line.size();j++){     // loops through every character in the string
            // If a character is an uppercase letter, it gets replaced by a lowercase character
            if(line[j]<='Z' && line[j]>='A'){
                line[j]+='a'-'A';
            }
            // If a character is not a character, that character gets omitted
            if(line[j]<'A'||(line[j]>'Z' && line[j]'A')|| line[j]>'Z'){
                line.erase(j,1);
                j--;                // j decreases by one since a character is being removed from the string
            }
        }
        // after this process, line should only consist of lowercase letters

        // str.find(str2) is a function in the string library.
        // If str.find(str2) returns -1, then str2 is not found within str.
        for(int k=0;k<10;k++){                  // checks if each province is in the line
            // if a province is found in the line, the program will output that province name and change isFound to true.
            if (line.find(check[k])!=-1){
                cout << result[k] << endl;
                isfound=true;
                break;
            }
        }
        // if no province is found in the line, the program outputs the default message
        if(isfound==false){
            cout << "NO PROVINCE FOUND" << endl;
        }
    }
    return 0;
}
