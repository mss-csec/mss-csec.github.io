/*  Problem: Maternity
    Link: http://wcipeg.com/problem/ccc06s1

    Two fruit flies can have a baby with a dominant allele expressed (A) as long as one of the of the parents have that gene
    Ex: Two flies with genes Aa & aa can have a baby with the dominant allele expressed. However, aa & aa cannot.
    Two fruit flies cna have a baby with a recessive allele expressed (a) as long as each parent has atleast one recessive gene
    Ex: Two flies with genes Aa & Aa can have a baby with the recessive allele expressed. However, AA & aa OR Aa & AA cannot.

    A 5 by 2 boolean array is used to store the traits that a baby can have based on the genes of the two parents.
    possibleTraits[i][0] stores whether the ith trait of a baby can be dominant (A)
    possibleTraits[i][1] stores whether the ith trait of a baby can be recessive (a)
    The program will fill out the boolean array before looking at the traits of any babies
    The program checks the traits of each baby
    If there is moment when a baby expresses a trait that it should not express, then the baby is not the parents'
    If all traits of the baby can come from the parents, then its is possible for the baby to be the parents'
*/

#include <string>           // string container
#include <iostream>         // cout, cin

using namespace std;

int main(){
    string gene1,gene2;             // stores the genes of the two parents
    bool possibleTraits[5][2];      // boolean array that stores which traits  ababy can have
    cin >> gene1 >> gene2;          // gets the two string inputs

    for(int i=0;i<gene1.length();i+=2){     // looks at every gene (2 characters) in the string
        // all capital letters have a ASCII code less than 'a'
        // checks a gene in both strings. If a capital letter shows up, then the baby can express a dominant trait
        if(gene1[i]<'a'||gene1[i+1]<'a'||gene2[i]<'a'||gene2[i+1]<'a'){
            possibleTraits[i/2][0]=true;
        }
        else{
            possibleTraits[i/2][0]=false;
        }
        // all lower-case letters have an ASCII code greater than 'Z'
        // if a lower-case letter appears atleast once in both strings, then the baby can express a recissive trait
        if((gene1[i]>'Z'||gene1[i+1]>'Z')&&((gene2[i]>'Z'||gene2[i+1]>'Z'))){
            possibleTraits[i/2][1]=true;
        }
        else{
            possibleTraits[i/2][1]=false;
        }
    }

    int numBabies;          // stores the number of babies to check
    cin >> numBabies;       // gets integer input

    for(int i=0;i<numBabies;i++){   // goes through each baby
        bool possibleBaby=true;     // stores whether the baby can be a possible offspring of the two parents. Assumes it is to begin with.
        string baby;                // stores the traits of the baby
        cin >> baby;
        for(int j=0;j<baby.length();j++){   // checks every trait of the baby (every character in the string)
            // if the baby expresses a trait that is shouldn't be able to express, possibleBaby is set to false
            if(!((baby[j]<'a' && possibleTraits[j][0])||(baby[j]>'Z' && possibleTraits[j][1]))){
                possibleBaby=false;
                break;
            }
        }
        // outputs message based on whether the baby can be a possible offspring of the two parents.
        if(possibleBaby){
            cout << "Possible baby." << endl;
        }
        else{
            cout << "Not their baby!" << endl;
        }
    }

    return 0;
}
