// AN INTRO TO STRUCTS
#include <iostream>     // cin, cout
#include <string>       // string
#include <algorithm>    // sort
using namespace std;

/*
Structs are used to create other datatypes. They are used so that data can be well organized and easier to manipulate and store.

SOME DEFINITIONS
object: Think of an object as a datatype that has other variables inside of it. They usually represent some item in real life that would have multiple pieces of data.
        Ex: cards, dice, records
member variables: Variables that are found in a struct.
                  Each instance of a struct will have its own copy of member variables (unless the variable is static)
                  Ex: In the struct below, every student will have his/her own name and mark.
constructor: Special function that is run immediately once a variable has been initialized.
              The purpose of a constructor is to set starting values to all memeber variables in a struct.
              Constructors are always defined within the struct. It is formatted like a function.
              The name of the constructor is also the name of the struct it is in.
              Constructors can have parameters, variables, and all that jazz.
null constructor: A constructor with no parameters.
                  Even if nothing is defined in the constructor, it is required for a struct to have a null constructor.
overloading functions: A function that has the same name as another already defined function, but it has a different set of parameters.
                       As long as two functions have different parameter lists, they can have the same name.
                       Constructors can be overloaded
operator overloading: An operator is overloaded and redefined. Operators are also techinically functions.
                      Operators are usually overloaded when two objects need to be compared,added,subtracted,etc.
                      You cannot redefine operators that work with basic data types. (int, char, bool, float, double)

Working with data that is stored into organized data types is called Object Oriented Programming. When using only one file, structs get the job done.
In large scale projects such as games, OOP is vital for making data easy to work with.
*/

// Defines a new data type called Student.
struct Student{
    // list of a member variables. Each instance of a Student will have their own set of the member variables below.
    string name="Jones";            // assigning a value to these member vairable gives them an initial value.
    int mark=-5;                    // When a Student instance initialized, the default mark of the student is set to -5

    // two constructors are initialized.
    Student(string n,int m){        // This constructor has two parameters. There parameters are used to assign starting values for the member variables.
        name=n;
        mark=m;
    }
    // null constructor: a constructor with no parameters.
    Student(){                      // your compiler will yell at you if you don't have one because it is afraid someone will initialize a Student without using a constructor.
    }                               // since the two constructors have different parameter lists, there is no ambiguity, and the compiler allows them to have the same name.
} ;

// The operator < is overloaded, redefined so that it knows how to compare two students.
// We need to tell the program what makes a student "less" than another student; in this case, it is mark of the student.
bool operator<(const Student& left,const Student& right){
    // const and & are added because that's how operator functions are formatted.
    return left.mark < right.mark;
}

int main(){
    Student students[10];                   // initializes a ten-element array of Students. Each student has their own mark and name.
    // Every student in the array is given a name and mark. A constructor was used so that the process would take less lines of code.
    students[0]=Student("Jane",23);
    students[1]=Student("Febby",58);
    students[2]=Student("March",8);
    students[3]=Student("April",35);
    students[4]=Student("May",89);
    students[5]=Student("Junie",93);
    students[6]=Student("Julia",39);
    students[7]=Student("Augustine",55);
    students[8]=Student("Sep",44);
    students[9]=Student("Octopus",77);

    // The sort function is called. The sort function uses the operator < to sort the elements. That is why < was overloaded earlier.
    // Without overloading the < operator, the program cannot use the sort function.
    sort(students,students+10);

    // outputs the names and marks of all the students.
    for(int i=0;i<10;i++){
        // in order to access a member variable in a struct, use the period(.)
        // Notice the location of the period and the []. This order specifically needed in this situation.
        // We are creating an ARRAY of STUDENTS; thus, the program needs to first know which student we are refering to before figuring out the member variable.
        // That is why the [] is placed before the period.
        cout<<students[i].name<<" has a "<<students[i].mark<<endl;
    }
    cout<< students[0].name <<" and "<< students[1].name <<" have been kicked.";

    return 0;
}
