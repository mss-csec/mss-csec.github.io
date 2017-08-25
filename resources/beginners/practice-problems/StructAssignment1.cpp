#include <iostream>
#include <string>
using namespace std;

/*
    In the ever so popular DarkValle Secondary School, there are only three courses that students are able to take: Math, English, and Computer Science.
    The School Board wants to keep track of its many courses and record the performance of all students in their school.
    Thus, they want to store the course name, code, and a list of all the students in each course with their respective mark.

    Your task is divided up into 4 parts. Scroll down to the Main Function to find them.
    You are allowed to create your own functions; however, it should not be necessary for you to change any code already in this file.
    In order to make your code a lot less spaghetti, USE STRUCTS and have students and courses be their own data type.

    I suggest you first run this program before coding to see what everything does.
*/

// draws the Main Menu
void drawMenu(){
    cout<<"-----------------------------------"<<endl;
    cout<<"Choose One of the Following Actions"<<endl;
    cout<<"1. Add a Student to a Course"<<endl;
    cout<<"2. Remove a Student from a Course"<<endl;
    cout<<"3. List all Students in a Course"<<endl;
    cout<<"4. Calculate Course Average"<<endl;
}

// gets user's input on which course to work on. RETURNS AN INT.
int courseSelection(){
    cout<<"Select the Course:"<<endl;
    cout<<"1. Math"<<endl;
    cout<<"2. English"<<endl;
    cout<<"3. Computer Science"<<endl;
    char n;
    cin >> n;
    while(n<'0'||n>'3'){
        cout << "Invalid Input. Try Again:"<<endl;
        cin >> n;
    }
    return n-'0';
}

// gets the name of the student. Returns a string.
string getStudent(){
    cout << "Name a Student:" << endl;
    string s;
    cin >> s;
    return s;
}

int main(){
    int choice,courseChosen;
    string studentName;
    while(true){
        drawMenu();
        cin >> choice;
        switch(choice){
        case 1:
            courseChosen=courseSelection();
            studentName=getStudent();
            int studentMark;
            cout << "What mark did " << studentName << " get?" << endl;
            cin >> studentMark;
            /*
            PART I
            Have the program add a student to a course. Ensure that it keeps track of all the students that are taking a course.
            The program should store the name and mark of the new student.

            ENTER CODE BELOW
            */
            break;
        case 2:
            courseChosen=courseSelection();
            studentName=getStudent();
            /*
            PART II
            Have a student removed from a course. The program will search through all the students in a list and remove a student with a given student name.
            If no such student exists, output a message stating that the student was not found in the course.

            ENTER CODE BELOW
            */
            break;
        case 3:
            courseChosen=courseSelection();
            /*
            PART III
            Output the number of students in the course, first.
            Then, have the program output all the students in a specific course with their marks.
            Make it so that students with higher marks are listed before those with lower marks.

            ENTER CODE BELOW
            */
            break;
        case 4:
            courseChosen=courseSelection();
            /*
            PART IV
            Have the program output the average mark of a specific course.
            Have the average mark be a double rounded to the nearest two decimal places.
            If no students are in the course, output zero.

            ENTER CODE BELOW
            */
            break;
        default:
            cout<<"Invalid Input"<<endl;
        }
        cout<<"Enter anything to continue"<<endl;
        string garbage;
        cin >> garbage;
    }

    return 0;
}
