/*  Problem: J2: Rope Unfolding
    Link: http://wcipeg.com/problem/mockccc14j2

Because of how cin ignores whitespace when getting an input, the location of each section of the string does not matter
Notice how the very last line of input always starts from left to right. The previous line input would then go from right to left.
All previous lines will alternate between going left to right and going right to left.
Therefore, if there is an odd number of line segments of the rope, the first segment will start from left to right, and if there is an even
number of line segments of the rope, the first segment will start from right to left.

A String Container is used to store the final string to be outputted. Another string is used to get the input for each line segment.
If the line segment input happens to go from right to left, the string is reversed.
The string that stores each line segment is then concatenated in front of the final string before proceeding to take the next line input.
After all segments of the rope have been concatenated, final string is outputted.

*/

#include <iostream>     // cin, cout
#include <string>       // string

using namespace std;

int main(){
    int numRows;                    // storea the number of sections in the rope
    string inputString;             // string to store the input of each segment of the rope
    string finalString="";          // string to store the final word, starts off as an empty string

    cin >> numRows;                 // gets input for the number of segments in the rope

    // collects each line segment and adds it to the finalString
    for(int i=numRows;i>0;i--){
        cin >> inputString;         // gets rope segment
        // reverses input String if i is odd. When i is odd, the current rop segment goes from right to left
        if(i%2==0){
            // reverses string by swapping the first and last characters with each other.
            for(int j=0;j<(inputString.length()/2);j++){
                char c=inputString[j];
                inputString[j]=inputString[inputString.length()-1-j];
                inputString[inputString.length()-1-j]=c;
            }
        }
        finalString=inputString+finalString;    // adds inputString to the front of finalString
    }

    cout << finalString;            // outputs the finalString

    return 0;
}
