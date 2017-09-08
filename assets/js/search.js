(function() {
  var contentLength, extractQuery, idx, initSearch, queryKey, renderResults, searchStore, storageKey, store,
    hasProp = {}.hasOwnProperty;

  queryKey = 'q';

  storageKey = 'search_idx';

  contentLength = 300;

  idx = null;

  store = {};

  extractQuery = function(query) {
    var index, searchString;
    searchString = window.location.search.slice(1);
    index = searchString.indexOf(query + '=');
    query = searchString.slice(index + query.length + 1, searchString.indexOf('&', index) + 1 || 2e308);
    return decodeURIComponent(query.replace(/\+/g, '%20'));
  };

  renderResults = function(results) {
    var builder, i, item, len, result, searchResults;
    searchResults = $('#search-results');
    if (results.length > 0) {
      builder = [];
      for (i = 0, len = results.length; i < len; i++) {
        result = results[i];
        item = store[result.ref];
        builder.push("<article> <header> <h3><a href='" + item.url + "'>" + item.title + "</a></h3> </header> <p>" + (UTILS.fuzzyTruncate(item.content, contentLength)) + "</p> </article>");
      }
      return searchResults.html(builder.join(''));
    } else {
      return searchResults.html('<h3>No search results found.</h3>');
    }
  };

  initSearch = function(rawStore) {
    var commit;
    commit = "32c1f72";
    if (null !== localStorage.getItem(storageKey)) {
      idx = JSON.parse(localStorage.getItem(storageKey));
      if (commit === idx.commit) {
        return idx = lunr.Index.load(idx.store);
      }
    }
    idx = lunr(function() {
      var content, key, ref, ref1, ref2, ref3, results1, subclub, title, url;
      this.ref('id');
      this.field('title');
      this.field('subclub');
      this.field('content');
      this.field('type');
      ref = rawStore.subclubs;
      for (key in ref) {
        if (!hasProp.call(ref, key)) continue;
        ref1 = rawStore.subclubs[key], title = ref1.title, subclub = ref1.subclub, content = ref1.content, url = ref1.url;
        store[key] = {
          type: 'subclub',
          title: title,
          content: content,
          url: url
        };
        this.add({
          id: key,
          type: 'subclub',
          title: title,
          subclub: subclub,
          content: content
        });
      }
      ref2 = rawStore.posts;
      results1 = [];
      for (key in ref2) {
        if (!hasProp.call(ref2, key)) continue;
        ref3 = rawStore.posts[key], title = ref3.title, content = ref3.content, url = ref3.url;
        store[key] = {
          type: 'post',
          title: title,
          content: content,
          url: url
        };
        results1.push(this.add({
          id: key,
          type: 'post',
          title: title,
          content: content
        }));
      }
      return results1;
    });
    localStorage.setItem(storageKey, JSON.stringify({
      commit: commit,
      store: idx
    }));
    return idx;
  };

  window.search = function(query) {
    var results;
    results = idx.search(query);
    return renderResults(results);
  };


  /*
   */

  searchStore = {
    subclubs: {
      "": {
        url: "",
        title: "advanced",
        subclub: "advanced",
        content: advanced
      },
      "": {
        url: "",
        title: "advanced",
        subclub: "advanced",
        content: advanced
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "": {
        url: "",
        title: "beginners",
        subclub: "beginners",
        content: beginners
      },
      "resources-beginners-commonly-used-functions-in-cpp": {
        url: "/resources/beginners/commonly-used-functions-in-cpp",
        title: "Commonly Used Functions in C++",
        subclub: "beginners",
        content: "Make sure to add the libraries that these functions belong in.Function NameDescriptionstd::sortSorts an array/vector from least to greateststd::reverseReverses an array/vectorsqrtReturns thesquare root of a numberpowReturns the valueof an exponentroundRounds a floating number/double to the nearest integerceilRoundsup a numberfloorRounds down a numberrandReturns arandom integer"
      },
      "resources-beginners-debugging-common-errors": {
        url: "/resources/beginners/debugging-common-errors",
        title: "Debugging Common Errors in C++",
        subclub: "beginners",
        content: "When trying to find errors in code, a debugger is often used. A debuggerallows users to find problems in their code. If the code failed andcrashed when running or compiling, a message will be displayed on thedebugger showing where and what caused the code to crash.Code::Blocks is built with a debugger. It should naturally be located onthe bottom of the Code::Blocks window. There should be a bar with thename, *Logs &amp; Others* on it. If there is no debugger shown onCode::Blocks, press F2 or go to View &gt; Logs.Figure 1. An error being displayed in the Build messages tab. Here, we are told that the error is due to a missing semicolon on line 6.In the debugger, the *Build messages* tab will display any messageswhen the computer is building/running a code file. If an error occurs,it will display a message and the line number the error is found in. Incase you have trouble understanding what the message means, below are afew errors beginners to that would output a build message,Error: redeclaration of '_'Did you initialize a variable twice? Two variables should not have thesame names.Error: expected ';' before &#8230;&#8203;..You simply missed a semicolon on the line right before the line thaterrored.Error: '__' was not declared in this scope&#8230;&#8203;&#8230;&#8203;.This message is a little vagueIs the word that is not declared supposed to be a variable?Is that variable initialized (Check spelling)?Did you initialize a variable inside a loop/if structure and tried toaccess that variable outside of the loop?Is the word that is not declared supposed to be a command?Did you include both the standard library as well as the library thecommand is in.Does your file have a “using namespace std;” and an include statementat the beginning of your file?Is the word that is not declared supposed to be a function?Is there a part in your code where a function is used before thefunction is declared?If a function is placed after the main function, your code cannot callthe function inside the main function.Is the word that is not declared supposed to be text?Put quotation marks around themFatal error: &lt;name of library&gt;: No such file or directory; &#8230;&#8203;..Most likely, your file is saved as a C file and not a C++ file. In a Cfile, many libraries such as string, iostream, and vectors, cannot beused.Did you spell the name of the library correctly?Error: no match for 'operator&gt;&gt;'&#8230;&#8203;&#8230;&#8203;. or Error: no match for 'operator\\&lt;&lt;'&#8230;&#8203;..Did you mix up &gt;&gt; and &lt;&lt;? (&lt;&lt; are for cout statements and &gt;&gt; are forinput statements)Error: invalid operands of types 'const char[ ]' and 'const char[ ]' tobinary&#8230;&#8203;&#8230;&#8203;.* Did you try to add two string literals? (text that are surrounded byquotation marks)* Avoid doing that altogether, but if you really need to add them, justomit the *+ sign.Error: no match for 'operator\\&lt;'This applies to every operatorWhat happened was likely an error due to the order the computer performsoperations. For example, &lt;&lt; is usually executed before a relationaloperator in an output statementJust add parenthesis and see if it worksError: invalid operands of types '_' and '_' to 'binary operator%'&#8230;&#8203;&#8230;&#8203;..Did you try to perform a modulus operation when one of the values is notan integer/character?If you are trying to mod a floating number, put (int) right in frontof the variable to change the floating number into an integer. However,this will cut off any decimals stored in the float.If your code does not crash, but it is not outputting the values thatyou expect it should output, check the following:Did you use any assignment variables(=) in an if/loop condition whenyou should have used a relational operator (==)Do not mix = and == upWhen you initialize a counter variable for your for loop, did you giveyour counter a value?If not, then the value of the counter will be some garbage number.Are the variables that are sent into a function as parameters theintended variable type?These are only a few errors that could come up when coding a C++ file.If you are still left with an error with a build message, read throughyour code once more to see if all of your code makes sense."
      },
      "resources-beginners-faq": {
        url: "/resources/beginners/faq",
        title: "Frequently Asked Questions",
        subclub: "beginners",
        content: "Will adding comments, having whitespace, or using longer variable names make my code run slower?No. The program will not run slower. Before the computer runs a codefile, the compiler first works with the code. Its job is to take thecode and translate it into a set of instructions that a computer canread and follow. A compiler will skip through any whitespace andcomments in the code file and create an exe.file. Since, comments andwhitespace are omitted in a .exe file, it does not affect theperformance of the actual program. Technically, it will take a longertime for the compiler to translate a code file with whitespace andcomments, but compilation time is not as important. Therefore, it isbest for a code file to be well documented with whitespace and comments.My cursor is being weird and appears below the characters.Press kbd:[Insert] on your keyboard.How do I change a floating number into an integer?(int) will take the data value of a variable and convert it into aninteger in order to be evaluated. It will not change the type of thevariable nor will it overwrite what is stored in the variable. Whenconverting from a floating number to an integer, the computer willignore all decimals in the floating number. (Ex: 4.9 will change to 4)In general, putting (&lt;Datatype&gt;) in front of a variable will changethe type of a data value. This can be used when some functions onlyaccept certain variable types as inputs.Why does Code::Blocks not ask me to save my files?Whenever you build your code, your code file will be saved and an .exefile will be created. Therefore, as long as you continuously build andrun your files, you would be saving them in the process. That beingsaid, if you want to try something risky in your code file (such asreplacing a lot of lines), make a copy of your code file so that youwill always have a backup.How do I add graphics in C++?Graphics for C++ is beyond the scope of the beginner course. Graphicsin C++ is complicated. If you are very motivated, I would suggestlearning SDL, Here is an online tutorial onSDL!Why is it int main() and not void main()?"
      },
      "resources-beginners-practice-problems-functions-questions": {
        url: "/resources/beginners/practice-problems/functions-questions",
        title: "Functions Questions",
        subclub: "beginners",
        content: "Part IWrite a function, drawBox, that draws a box out of X’s with agiven width and height. This function will have no return value.For example, a 3 by 4 box will look like the following:XXXXX  XXXXXWrite a function that returns if a year is a leap year. Thisfunction will return a boolean value: true or false.Any year divisible by 4 is a leap year. However, if the year isdivisible by 100 and not divisible by 400, the year is not a leapyear.Below is the formula used to convert a temperature from Celcius toFarenheit.\\[F = (9*C)/5 + 32\\]Write a function that converts a temperature from Celcius to Farenheit.Round the final temperature to the nearest integer.Write a function that finds the area of a circle with a givenradius. The function will return a double with a precision of 2 decimalplaces.Write a function that accepts three side lengths. It will returnwhether the three sides can form a triangle.Modify the function so that it returns whether the three sidelengths form a right-angle triangle.Write a function that accepts a positive integer and returns if thevalue is prime.Write a function that accepts two strings, str1 and str2, asarguments. Your function will search for the first occurrence of str2within str1 and return where it is found. If str2 is not found anywherein str1, your function should return -1. You are basically coding thefind()function in the string library; do not use that function.Modify your function so that the search is case insensitive.Create your ownreplace()function. This function takes two strings str1, str2 and str3. Anytimestr2 is found in str1, it is replaced with str3. Return the finalstring. The search is case sensitive.Table 1. Sample Testcase:str1str2str3Return Value\"Aayyy%lmao\"\"a\"\"Woah\"\"AWoahyyy%lmWoaho\"Part IIWrite a function that passes two integer values,a and b, byreference. Have the function swap the values if the two variables if a&gt; b.Write a function that takes a string as an argument and returns astring that is in all caps.Modify your function so that the string argument is changeddirectly. Change the return type of the function from string to void.Write a function that sorts an integer array from least to greatest.Do not use sort(). Choose one of the following sorts:Bubble SortSelection SortInsertion SortRead the following piece of code and determine the following:The outputThe return values and parameters of each function call. Only use an IDE to check your answer.Code A12345678910111213141516171819202122232425262728293031#include &lt;iostream&gt;using namespace std;int china(int a,int b){    cout &lt;&lt; a+b &lt;&lt; endl;    return a-b;}int germany(int a){    return a*2-1;}int canada(int x, int y, int z){    int a=germany(z)+germany(y);    return a+x;}int france(int y, int x){    int a=x-y;    return canada(x,y,a);}int main(){    int x=1,y=3,z=5;    cout &lt;&lt; x &lt;&lt; \" \" &lt;&lt; y &lt;&lt; \" \" &lt;&lt; z &lt;&lt; endl;    china(x,y);    cout &lt;&lt; china(z,y) &lt;&lt; endl;    cout &lt;&lt; canada(x,y,z) &lt;&lt; endl;    cout &lt;&lt; germany(france(x,z)) &lt;&lt; endl;    return 0;}+Code B123456789101112131415161718192021222324252627282930#include &lt;iostream&gt;using namespace std;int kazakhstan(int b,int a){    return a-b;}int kyrgyzstan(int a,int b){    int c=a*b;    cout &lt;&lt; c &lt;&lt; \" \";    return c+b+a;}int azerbaijan(int&amp; a,int&amp; b){    int c=kazakhstan(b,a);    a=c*a;    b=c*b;    return c;}int main(){    int a=5,b=10;    cout &lt;&lt; a &lt;&lt; \" \" &lt;&lt; b &lt;&lt; endl;    cout &lt;&lt; kazakhstan(a,b) &lt;&lt; endl;    cout &lt;&lt; kyrgyzstan(kazakhstan(a,b),a+b) &lt;&lt; endl;    cout &lt;&lt; azerbaijan(b,a) &lt;&lt; endl;    cout &lt;&lt; a &lt;&lt; \" \" &lt;&lt; b;    return 0;}+Code C123456789101112131415161718192021222324252627282930#include &lt;iostream&gt;using namespace std;int brazil(int&amp; a){    a=a*2-1;    return a-1;}int chile(int&amp; y,int&amp; x){    y+=3;    x+=2;    return y+x;}int peru(int&amp; x,int&amp; y){    x--;    chile(x,y);    return x*(x-y);}int main(){    int x=2,y=5;    brazil(y);    cout &lt;&lt; brazil(x)+y &lt;&lt; endl;    cout &lt;&lt; chile(x,y) &lt;&lt; endl;    cout &lt;&lt; x &lt;&lt; \" \" &lt;&lt; y &lt;&lt; endl;    x=peru(y,x);    cout &lt;&lt; x &lt;&lt; \" \" &lt;&lt; y &lt;&lt; endl;    return 0;}Part IIIWrite a recursive function that takes an integer n and returns nfactorial.Write a recursive function that takes an integer n and returns thenthtriangularnumber. Do not use a loop or \\(\\dfrac{n (n + 1)}{2}\\).Write a recursive function that takes a string argument and reversesthe string.Write a recursive function that finds the nth term of theFibonacciSequence. This is also known as &#8220;the worst Fibonacci function&#8221; but doit anyways.Write a recursive function that finds the GCF of two integers usingtheEuclidianmethod.Write a recursive function that returns a value fromPascal&#8217;s Trianglegiven its row and column. The row and column numbers in Pascal’sTriangle start at 0.Challenge: Solve the J5 problem forthe 2015 CCC. This problem will use recursion.PART IVA formula for the area of a triangleis \\(A = \\frac{b*h}{2}\\) . Have a function named areaT returnthe area of a triangle given its base and height. The parameters andreturn type will be integers.One can also use Heron&#8217;s Formula to find the area of a triangle withside lengths a, b, and c.\\[A = \\sqrt{s(s - a)(s - b)(s - c)}\\]The value of s is the semiperimeter of the triangle:\\(\\dfrac{a + b + c}{2}\\)Create another function named areaT that takes three integer sidelengths and returns the area using Heron&#8217;s Formula.Create another function named areaT that takes the side length of anequilateral triangle and returns the area of that triangle.Sample CallsCallOutputdrawBox(4,5);drawBox(10,1);XXXXXXXXXXdrawBox(5,0);Sample CallCallReturn ValueisLeapYear(1992);trueisLeapYear(1900);falseisLeapYear(2000);true"
      },
      "resources-beginners-practice-problems-reinforcement-questions": {
        url: "/resources/beginners/practice-problems/reinforcement-questions",
        title: "Reinforcement Questions",
        subclub: "beginners",
        content: "These questions are here to test and reinforce your understanding of keyconcepts so that you can ease into doing contest questions.LoopsWrite a program that outputs a smiley face, :), an n number oftimes.Input: n (integer)Output: \":)\" written n timesSample Runs:InputOutput2:):)7:):):):):):):)Write a program that outputs the first 5 multiples of n.Input: n (integer)Output: the first 5 multiples of n, starting with nSample Runs:InputOutput11 2 3 4 51717 34 51 68 85-8-8 -16 -24 -32 -40Write a program that takes integers n and i. Your program willperform i calculations on n. The calculations done on n willalternate between the following:\\(n_{\\text{next}} = 2(n + 4)\\)\\(n_{\\text{next}} = \\dfrac{n + 2}{2}\\)The program will output the final value of n.Input: n iOutput: resulting number after performing i calculations to nSample Input: \\(\\color{red}3\\) +\\(5\\)Sample Output: 34Explanation:\\[\\begin{aligned}2(\\textcolor{red}{3}+4) &= \\textcolor{blue}{14} \\\\\\frac{\\textcolor{blue}{14}+2}{2} &= \\textcolor{orange}{8} \\\\2(\\textcolor{orange}{8}+4) &= \\textcolor{green}{24} \\\\\\frac{\\textcolor{green}{24}+2}{2} &= \\textcolor{purple}{13} \\\\2(\\textcolor{purple}{13}+4) &= \\boxed{34}\\end{aligned}\\]Sample RunsInputOutput9 419-12 92435 16751071 1378971090Suppose a number of dots were used to form an equilateral triangle.The number of dots required to make the triangle increases as the numberof rows increases. Notice how the number of dots in each row increasesby one each time. [[4(a)]]Given an n number of rows, determine the number of dots needed to makean equilateral triangle.Input: n, n&gt;0Output: the number of dots required to make the triangleSample RunInputOutput621127825632896The number of dots that form an equilateral triangle are calledtriangular numbers.In a sequence of all triangular numbers, t(n), t(n) would be the sumof all natural numbers up to and including n; that is, t(n) = 12 + 3 + … + nThere is a formula that calculates the nth term in a sequence oftriangle numbers:\\[t(n) = \\frac{n(n + 1)}{2}\\]Rewrite your program so that it now uses this formula to calculate thenumber of dots in an equilateral triangle. If you have originally usedthis method, then rewrite your program so that it uses loops instead.Use the same test data as [4(a)].The Fibonacci sequence is a list of numbers where each term is thesum of the previous two terms.\\[F_{n} = F_{n - 1} + F_{n - 2}\\]Let the zeroth and first term of the Fibonacci sequence be 0 and 1,respectively. Write a program that outputs the nth term of thefibonacci sequence.Input: nOutput: nth term of the Fibonacci sequenceSample Run:InputOutput5513233333524578Hint (Highlight to see): To find the nth term in the sequence, you will start with the zeroth and first term and find all succeeding terms until you get to the nth term.The 3n+1 problem. The wcipegpage explains this nicely.Hint (Highlight to see): The number of times 3n+1 and n/2 will be calculated is unknown. A while loop would suit this question.== StringsWrite a program that takes a word and outputs the reverse of aword.Sample Run:InputOutputabbccbbaqwertyuioppoiuytrewqA palindrome is a string that can be read the same backward andforward. Write a program that takes a word and determines if it is apalindrome. If it is a palindrome, output “YES”. If it is not apalindrome, output “NO”.Sample Run:InputOutputabcddcbaYESaYESqwertyqwertyNOWrite a program that takes a word. Going through the index (i) ofevery character, output the ith character in the word i+1 times.Sample RunInputOutputabcabbcccqwertyqwweeerrrrtttttyyyyyyboooboooooooooWrite a program that takes a word, then a character c. Yourprogram will determine the number of times the character is found in theword.Sample Run:InputOutputmississippi s4lolloooolooolasdoo o10kappa o0Modify the program so that it will remove all instances where cappears in the word.You may want to usestring::erasefrom the string library.Sample Run:InputOutputmississippi smiiippilolloooolooolasdoo olllllasdkappa okappaModify your program again so that it accepts two characters thistime, c1 and c2. Each time c1 is found in the string, thecharacter is replaced with c2 instead. Each time c2 is found in thestring, the character is replaced with c1.Sample Run:InputOutputmississippi i smsiisiisppslolloooolooolasdoo o loloollllollloasdllkappa p pkappaWrite a program that will take a character. If the character isan uppercase letter, output &#8220;U&#8221;. If the character is a lowercase letter,output &#8220;L&#8221;. If the character is not a letter, output &#8220;N&#8221;.Sample RunInputOutputSUtL@NWrite a program that will take a word, and output the word in allcaps. I suggest you refer to an ASCIItable instead of 26 if statements.Sample Run:InputOutputHelloHELLOl33tL33THoWiSLife??3HOWISLIFE??3Write a program that takes an entire line of characters. You willneed to use the getline() function. After receiving an entire sentence,output the sentence with all the words reversed. Assume no punctuationwill be given in the input.Sample Run:InputOutputThe cake is a lielie a is cake TheWhotypeswithspacesanywaysWhotypeswithspacesanywaysAll the words in the sentence must be reversedreversed be mustsentence the in words the AllHint (Highlight to see): All words are surrounded by spaces, and spaces are also characters. The length of each word in a sentence can be found be locating all the spaces in the sentence.Hidden Palindrome is a goodcontest question that you can find on WCIPEG. (Ex: In the string abcba,bcb is a palindrome surrounded by two a’s)Hint 1 (Highlight to see): A palindrome is made up of a smaller palindrome surrounded by two of the same characters.Hint 2 (Highlight to see): A way to check if a string is a palindrome is to start at the centre of the string and work outwards. For example, suppose i is the index of the centre of the string. For the string to be a palindrome, str[i-n] and str[i+n] must be the same. This idea should be used when finding hidden palindromes.The solution to Hidden Palindrome can be found in the here.== ArraysWrite a program that takes in an n number of integer inputs. Thisprogram will store those integers in an array and determine the greatestnumber (h) and least number (l) of all the given integers.Input: *n*, the number of integers which follow n integers, k1 to knOutput: h lSample Run:InputOutput71 2 0 3 8 4 99 01611 2 93 82 78 54 1 82 -90 2 8 3 4 5 1 -393 -90Write a program that takes an n number of integers. Store all theintegers into an array. Reorder the elements in the array so that allthe values in the array are reversed. Do not make a copy of the arraywhile reversing. After reversing, output the ith element of thereversed array. ‘i’ will always be less than n.Input: *n*, the number of integers which follow n integers, k0 to kn-1*i*, 0 ≤ i &lt; nOutput: The value of the element in the reversed array at index i.Sample Run:InputOutput102 4 6 8 10 12 14 16 18 206851 2 3 4 514Write a program that takes n integers from 0 to 9. Determinethe number of times i appears in the array.Input: *n*, the number of integers which follow n integers, k0 to kn-1*i*, the integer to countOutput: The number of times i appeared as an input.Sample Run:InputOutput65 9 8 3 3 2 333201 0 1 1 1 1 1 0 1 1 1 0 1 1 1 0 1 1 0 1115Write a program that will continually accept integer inputs from 0-9until it receives a -1. Determine the number of times i appears in thearray.Input: An unknown amount of integers from 0-9 , terminated by -1*i*, the integer to countOutput: The number of times i appeared as an input.Sample Run:InputOutput1 6 3 2 4 1 1 2 3 5 1 5 3 7 2 4 3 7 1 3 2 -1157 4 9 8 4 5 2 6 7 4 3 4 -144Hint (Highlight to see): Instead of having an array that stores all integer inputs, have an array that stores the number of times each number has been inputted so far.An anagram is a rearrangement of the letters of a word/phrase toform another word/phrase. Write a program that will determines if twophrases are anagrams. You will need to use getline() for this question.If the two phrases are anagrams, output &#8220;Y&#8221;. If the two phrases are notanagrams, output &#8220;N&#8221;.Sample Run:InputOutputdormitorydirty roomYeleven plus twotwelve plus oneYabracadabracabra darabNHint (Highlight to see): have a 26 element array that stores how many times each character appears in a string.Ragaman is a variation of the problem above. This question can befound on the WCIPEG website.Hint (Highlight to show): Since the first word will never have any asterisks, if the second word has more of one character than the first word, the two words are not ragamans.Eliminanagram is another problem that involves anagrams. This canalso be found on the WCIPEG site.Hint (Highlight to show): For two words to be eliminanagrams, the total number of each character found in the two words must be even."
      },
      "resources-beginners-syntax-references-list-of-operators": {
        url: "/resources/beginners/syntax-references/list-of-operators",
        title: "List of Operators",
        subclub: "beginners",
        content: "Arithmetic OperatorsNameSyntaxDescriptionExampleOutputAddition+Adds two numbers together8 + 311Subtraction-Subtracts two numbers together8 - 35Multiplication*Multiplies two numbers together8 * 324Division/Divides the first number by second number.(Will drop the remainder when dividing an integer)8 / 38.0 / 322.66667Modulo%Finds the remainder when first number is divided by thesecond number. Only use Modulo on integer values.8 % 32Parenthesis()Dictates the order in which operations are done.Prioritizes all operators inside parenthesis.2 * (8 - 3)10Assignment OperatorsNameSyntaxDescriptionExampleEquivalent OperationAddition Assignment+=Adds the current data value with anotherx += 3x = x + 3Subtraction Assignment-=Subtracts the current data value with anotherx -= 4x = x - 4Multiplication Assignment*=Multiplies the current data value with anotherx *= 2x = x * 2Division Assignment/=Divides the current data value with anotherx /= 5x = x / 5Modulo Assignment%=Takes the remainder when the current data value is divided by another valuex %= 3x = x % 3Increment++Increases the current data value by 1x++x += 1Decrement--Decreases the current data value by 1x--x -= 1Relational OperatorsNameSymbolDescriptionExamplesResultEqual to==Checks if two values are the same3 == 34 == 3truefalseNot equal to!=Checks it two values are different3 != 45 != 5truefalseGreater than&gt;Checks if the first value is greater than the second5 &gt; 06 &gt; 6truefalseLess than\\&lt;Checks if the first value is less than the second3 &lt; 45 &lt; 3truefalseGreater than or equal to&gt;=Checks if the first value is greater than or equal to the second value5 &gt;= 44 &#8656; 4truetrueLess than or equal to&lt;=Checks it the first value is less than or equal to the second value3 &#8656; 34 &#8656; 3truefalseLogical OperatorsNameSymbolDescriptionExamplesResultAND&amp;&amp;Returns true only if both sides are truetrue &amp;&amp; truefalse &amp;&amp; truetruefalseOR||Returns true when either side is truetrue || false`falsefalse`truefalseNOT!Returns true if false and returns false if trueOther OperatorsNameSymbolDescriptionExampleResultXOR\\^This is a bitwise operator. It can be used as a logicaloperator. It compares 2 boolean values and results true if only one ofthem are true.false \\^ falsetrue ^ falsefalse ^ truetrue ^ truefalsetruetruefalse"
      },
      "resources-beginners-syntax-references-overview-of-cpp-syntax": {
        url: "/resources/beginners/syntax-references/overview-of-cpp-syntax",
        title: "C++ Syntax",
        subclub: "beginners",
        content: "Variable declarationif ([condition]){    //code}else if ([condition]); //terminates chain if trueelse    //one statement will fall in an if, else,    //else if, or loop if there are no braces.Ternary statement[conditional expression] ? [evaluates on true] : [evaluates on false]Switchswitch ([basic type variable]){case [constant]:    //code here    //multiple lines work    break;case [constant]:    //codecase [constant]:    //without a break, the previous case falls into this    //case and will also do the code under this case.default:    //if before is satisfied, code here runs.    //previous two cases will fall here as they lack a break.}Loopswhile ([condition]){    //code here that will run when condition is true    //while (1) gives infinite loop    //strongly suggested that something changes in the condition here    if ([condition]) break; //exits the loop (works with all loops)    if ([condition]) continue; //skips all code below,                               //returning to the top                               //(works with all loops)    //code}do{    //code here is done once, then loops if the below condition is true} while ([condition]); //you need the semicolon herefor ([initializer]; [condition]; [counter]){    //code    //special loop:    /* allows creation of counter variable which     * is checked by the condition and automatically     * updated by the counter at the end of an iteration.     * code order is as follows:     * initializer -&gt; condition -&gt; code -&gt; counter     *                      ^                |     *                      \\----------------/     */    //you can use a for(;;) for an infinite loop    //general usage is for (int i = 0; i &lt; times; i++)}Functions[return type] [scope]::[function name]([params]){    // code    // all branches must terminate by returning a value that is of    // the return type    // return type of void does not require return    // return exits function immediately}// prototype - when referencing a function that's written later in the code,// first put up a prototype so that it won't tantrum with \"I haven't seen this // yet, it must be nonexistent!\"[return type] [function name]([param types]);Structs, classes, and namespacesstruct [struct name]{    // variables or function prototypes};class [class name] : [inherits from]{    public:  // denotes that everything following allows public access    [class name](void);  // constructor, called on create    ~[class name](void); // destructor, called on delete    // variables or function prototypes};namespace [nsp name]{    // variables or function prototypes};[return type] [struct/class/nsp name]::[function name]([params]){    // code    // prototypes not within scope require a special header    // for their functions using the namespace resolution operator.}Enumsenum [enumeration name] : [type] // default type is int{    //list of terms. ex:    ENUM_1,                   // = 0     = 0    ENUM_2,                   // = 0 + 1 = 1    ENUM_3,                   // = 1 + 1 = 2    MUNE_0 = 0,               // = 0     = 0    MUNE_1,                   // = 0 + 1 = 1    MUNE_2,                   // = 1 + 1 = 2    MUNE_3 = MUNE_2 + ENUM_3, // = 2 + 2 = 4    MUNE_END                  // = 4 + 1 = 5    // enum terms are replaced by their values during compilation.    // allows for optimized readability - for example, directions can be    // enum'ed into integral values instead of a string};Arrays[type] [name][[size]] = {[list]}; // declaration and initialization[name][[index]]                   // references the index of the array[type] [name][[size1]][[size2]][[size3]]; // you can have multi-dimensional                                          // arrays, like this one with threePointers[type] * [name] = &amp;[reference];       // decl. and init. of a reference pointer[type] * [name] = new [type][[size]]; //decl. and init. of an array pointer*[name]                               // dereference pointer[name] + [offset]                     // pointer arithmetic - \"point [offset] more [type]s later\"[name][[index]]                       // dereference of pointer array at index*([name] + [index])                   // above(*[name]).[property]                  // access property of dereferenced pointer[name]-&gt;[property]                    // shortcut for above&amp;[reference]                          // take address of reference - returns a pointer[type] ***** [name]; // pointers can be nested!                     // this has the potential to become a fifth-dimensional                     // jagged array.Main functionint main (int argc, char* argv[]){    //begin code here    return 0;}"
      },
      "resources-beginners-syntax-references-variable-types-and-containers": {
        url: "/resources/beginners/syntax-references/variable-types-and-containers",
        title: "Variable Types and Containers",
        subclub: "beginners",
        content: "Variable TypesTypeSize(bytes)DescriptionRangeint4Used when the data are all integersEx: 1, 2, -8, 0, -350-2 147 483 648 to2 147 483 847unsigned int4Used when the data are all positive integers and zero.0 to4 294 967 295float4Includes all real numbers.Ex: 1.0, 3.14, 1.2345char1Characters part of ASCII. Each character is stored as a numerical representation.Ex: ‘a’,’b’,’@’Irrelevant if only used for ASCIIboolean1Stores either true (1) or false (0)long long8Used when the data are very large integers that go beyond the range of an integer type-9 quintillion to9 quintillionunsigned long long8Used when the data are all very large integers that never go below 00 to 18 quintillionshort2Smaller range of integers, uses less memory-32 768 to32 767unsigned short2Used when the data are all small positive integers and zero0 to 65 535double8Used when more memory is needed for a floatC++ containersNameLibraryDescriptionArraysVector&lt;vector&gt;Stack&lt;stack&gt;Queue&lt;queue&gt;Pair&lt;utility&gt;Map&lt;map&gt;"
      },
      "resources-beginners-terms-and-definitions": {
        url: "/resources/beginners/terms-and-definitions",
        title: "Common Terms and Definitions",
        subclub: "beginners",
        content: "TermDefinitionArrayA container that stores a series of data values of the sametypeBoolean ValuesData that can be one of two values, true (1) or false(0)CompilerA program that takes a code file and translates it into aset of instructions that a computer could understand and follow.ConsoleAn interface that can receive input values and display outputvalues.ContainerA collection of variables stored under a given identifier.Control FlowThe order in which a computer executes code.DebuggerA program that is used to help test and debug code files.DocumentationStructure of a code file. This includes whitespacingand commenting.ElementA variable inside of a container.FunctionA command for a computer. Typically, functions will includeinputs and result one output.Global VariablesVariables that are initialized outside of afunction, they are able to be used throughout the entire C++ file.Hard CodingGiving values to variables directly in the code file.IdentifierA name that a computer uses to refer to a specificlocation in memory.IndexA data value that indicates which variable is being referred toin a containerIntegrated development Environment (IDE)A program that is designedfor programmers to write code.LibraryA file that contains a list of functions that a computershould know.Local VariablesVariables that are initialized in a function. Thesevariables can only be used in the function they are declared in.Operatora symbol that manipulates or compares data values (Ex:+, =, &gt;, !)ParameterData Values that are sent to a function when that functionis calledMemoryA part in a computer that is used to store/retrieve dataRecursionThe process of having a function call itselfScalar Data ValuesData values that take up little memory. They arenormally passed to a function by value.ScopeA range/area in a code file that limits where variables can beused in.SpaghettiA type of code that is convoluted and unnecessarily hard to read.It is difficult to edit spaghetti code as it is prone to bugs.Therefore, creating spaghetti code is frowned upon.StringA container that stores a series of charactersString LiteralA sequence of characters enclosed by quotation marks.(Ex: \"hello\")SyntaxGuidelines on how specific functions can be used.VariableAn identifier used in a code file that refers to a specific location in memory.WhitespaceAny part of the code that is left blank. This includesspaces, indents, and empty lines."
      },
      "": {
        url: "",
        title: "test",
        subclub: "test",
        content: test
      },
      "": {
        url: "",
        title: "test",
        subclub: "test",
        content: test
      },
      "": {
        url: "",
        title: "test",
        subclub: "test",
        content: test
      },
      "": {
        url: "",
        title: "test",
        subclub: "test",
        content: test
      },
      "": {
        url: "",
        title: "test",
        subclub: "test",
        content: test
      },
      "": {
        url: "",
        title: "web-development",
        subclub: "web-development",
        content: web - development
      }
    },
    posts: {
      "announcements-2017-06-welcome-to-jekyll": {
        url: "/announcements/2017/06/welcome-to-jekyll/",
        title: "Welcome to this site!",
        content: "Hello, person! We see you discovered our top-secret website-in-construction.Unfortunately, we have no content to offer but the fact that we’ll probably be back in September with a swanking new website to suit all of your MSS CSEC needs.Until then, have a great summer!It is currently time to enable JavaScript, you dimwit. "
      }
    }
  };

  $(function() {
    var query;
    query = extractQuery(queryKey);
    $('#search-query').text(query);
    $('#search').val(query);
    $('#search-form').on('submit', function(e) {
      query = $('#search').val();
      e.preventDefault();
      $('#search-query').text(query);
      history.pushState({
        query: query
      }, '', "?" + queryKey + "=" + query);
      return window.search(query);
    });
    $(window).on('popstate', function(e) {
      var state;
      state = e.originalEvent.state;
      $('#search-query').text(state.query);
      $('#search').val(state.query);
      return window.search(state.query);
    });
    history.replaceState({
      query: query
    }, '', "?" + queryKey + "=" + query);
    initSearch(searchStore);
    return window.search(query);
  });

}).call(this);
