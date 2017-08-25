/*  Problem: Magic Squares
    Link; http://wcipeg.com/problem/ccc16j2

    For a grid to be a magic sqaure, all rows and coloumns must have the same sum.
    All the values in the grid is stored in a 4x4 multidimensional array
    In order to find the sum of a row or coloumn, an integer variable starts off as 0, and the value of each element in the row or coloumn is added to that variable.
    An integer variable stores the sum of the first coloumn
    The program then checks the sum of every other row and coloumn and compares it to the sum of the first coloumn
    If there is a time where the sums do not match, the square is not magic
*/

#include <iostream>             // cout, cin
using namespace std;

int main(){
    int grid[4][4];             // 4 by 4 multidimensional array to store grid values
    for(int i=0;i<4;i++){       // sets 0 to the value of every element in the array
        for(int j=0;j<4;j++){
            cin>>grid[i][j];
        }
    }
    bool isMagic=true;          // boolean variable that stores whether the square is magic. Assumes the square is magic to begin with.

    int total=0;                // stores the total sum of the first coloumn
    for(int i=0;i<4;i++){       // finds the sum of the first coloumn
        total+=grid[0][i];
    }

    // checks each coloumn to make sure that the sum of of all the elements in the coloumn matches with the total variable
    for(int j=1;j<4;j++){           // finds the sum of coloumn j
        int tempTotal=0;            // tempTotal stores the sum of the all elements in coloumn j
        for(int i=0;i<4;i++){       // adds every element in coloumn j to tempTotal
            tempTotal+=grid[j][i];
        }
        if(tempTotal!=total){       // if the two coloumns do not have ths same sum, then the grid is not a magic square
            isMagic=false;
            break;
        }
    }

    //checks each row to make sure that the sum of of all the elements in the row matches with the total variable
    for(int j=0;j<4;j++){           // finds the sum of row j
        int tempTotal=0;            // tempTotal stores the sum of the all elements in row j
        for(int i=0;i<4;i++){       // adds every element in row j to tempTotal
            tempTotal+=grid[i][j];
        }
        if(tempTotal!=total){       // tempTotal and total are not the same value, then the grid is not a magic square
            isMagic=false;
            break;
        }
    }

    // outputs message based on whether isMagic is true or not.
    if(isMagic){
        cout<<"magic";
    }
    else{
        cout<<"not magic";
    }

    return 0;
}
