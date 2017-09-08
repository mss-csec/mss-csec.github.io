# The template to use for subclubs

Here, you'll find a master template to use for your subclub needs.
Simply follow the instructions below, and you'll be good to go!

You are currently looking at **v1.0.0** of this template.
The latest version is always located at [our GitHub repository](https://github.com/mss-csec/subclub-template).

## Instructions

Whoa, these are some long instructions!
Thankfully, 4 of these steps are one-time-only things --- once you've completed them, you won't need to do them anymore --- and the rest are much simpler than they seem, the documentation is just long and verbose.
In the meantime, here's quick links to the two steps that you'll probably be referencing a bit more frequently:

- [Making a new lesson](#making-a-new-lesson)
- [Setting up resources](#setting-up-resources)

Let's get started.

### Cloning/forking

There are two ways to clone this repository: a good ol' Git clone, or GitHub's fork functionality.
Since this is an organization, it's preferable to use the former method.
You may do this by opening Git Bash, navigating to a folder of your choice (preferably your Documents folder), and running the following commands:

    git clone https://github.com/mss-csec/subclub-template.git
    cd subclub-template

### Setup

Before you can use this template in production, there are a few things you will have to change in the various files scattered around this template:

1. _Change `<Your subclub title>` to the name of your subclub._  
    It should be a short, specific, and memorable name that follows proper English grammar and is in Title Case.

    **Dos:**
    - Beginners
    - Dancing: Advanced
    - Snooker for Walruses

    **Do nots:**
    - beginners _-- Not capitalized_
    - Dancing Club _-- Too general, and avoid the word "club"_
    - Learning How to Play Snooker for Walruses of All Ages and Sizes _-- Too long!_

2. _Change `<Your subclub category>` to a hyphenized, all-lowercase version of your title._  
    The only characters that should exist are alphanumeric ([a-z0-9]) and the hyphen.
    It is important that this _not_ contain spaces, because things will break if it does.

    **Dos:**
    - beginners
    - dancing-advanced
    - snooker-for-walruses

    **Do nots:**
    - bEgInNeRs _-- There should NEVER be a capital letter_
    - dancing:-advanced _-- What's that colon doing there? Take it out!_
    - snooker walruses _-- Spaces are NOT okay, nor is diverging from your title_

Next, go onto GitHub and navigate to the mss-csec organization.
Create a new repository with the green "New" button on the right, and under "Repository name", enter the subclub category you settled on in step 2 above.
You may enter a description if you want, but keep the repository Public and **make sure** the "Initialize this repository with a README" option is left unchecked.
Click "Create repository", and copy the URL under "Quick setup", making sure the HTTPS option is selected.[^1]

Go to your Git Bash window, and type

    git remote set-url origin <paste URL here>

Accordingly, paste the URL you just copied in place of the statement.
You should now see something like

    git remote set-url origin https://github.com/mss-csec/beginners-subclub.git

Double check that this is want.
When you're sure, press Enter, and now type

    git push --set-upstream origin master

Wait for the push to complete, crossing your fingers that it succeeds.[^2]
Go to your browser, refresh your GitHub repository, and confirm that all the files from the template repository are there.
Now you're all set!

[^1]: If you know you have an SSH key setup, (e.g. you're using GitHub for Windows or a similar client), it is advisable to select the SSH option instead.  
[^2]: If `git push` fails, it's likely because you either copied the incorrect repository URL.
In that case, rerun `git remote set-url origin <new URL>`, and try pushing again.

### Giving your subclub a description

Simply update `index.md` at the root of this repository with your desired description.

### Making a new lesson

First, let's take a look at the lessons folder:

    lessons/
      |-- _using-markdown/
        |-- index.md
      |-- _using-asciidoc/
        |-- index.adoc

You'll notice that each lesson is represented by a folder. 
The folder's name is the title of the lesson, and the lesson content is in a file called `index.md` or `index.adoc` (Markdown or AsciiDoc, it's your choice).
Now, think of a title for your lesson.
Just like the name of your subclub, it should be short, specific, memorable, and follow proper English grammar; however, we recommend that it be in sentence case. 
Think carefully --- _this title is permanent_ --- and write it down somewhere, as you'll need it for the next step.

Next, take the lesson title that you came up with in the last step, and use it to create a _lesson id_, which is pretty important as we're going to use it for a lot of things.
For now, however, our main purpose for creating the lesson id is to create a name for the lesson folder.

Making a lesson id is similar to how you turned your subclub title into a category name: hyphenize all punctuation and make everything lowercase.
As well, the same rules and restrictions apply: no spaces, only the characters [-a-z0-9].
So if the title you thought of was:

> A history of snooker

, then the proper lesson id would be:

> a-history-of-snooker

Yes, it's a lesson that would probably bore even Professor Binns, but its title follows all the proper conventions --- good job!

Your next step is to create the actual lesson.
If you're on a desktop, open Git Bash and copy the folder pertaining to your favourite markup language to a new folder:

    cp -r lessons/_using-<either markdown or asciidoc>/ \
            lessons/<your lesson id here>/

If you're using the GitHub web interface, first copy the raw contents of your preference of `_using-markdown/index.md` or `_using-asciidoc/index.adoc`.
You can view the raw contents by clicking the "Raw" button above the file preview.
Do _not_ simply copy the file without click "Raw" first --- that will not give you the necessary markup.
Navigate to the lessons folder, and click "Create new file" at the top right.
Then, in the "Name your file" field, type

    <your lesson id here>/index.md

If you're using AsciiDoc, use `.adoc` as the file extension.
Paste the copied template into the code editor under "Edit your file".

Take a look at the template; there is important information inside about setting up the lesson.
**Be sure to read it, or else consequences will follow** (and Jekyll is not nearly as merciful as I am).
Edit the template accordingly into your new lesson.
I know it sounds boring, but trust me, writing is funner than reading documentation.

Anyways, here's a tip if you're writing on GitHub: write out your lesson in a text editor (e.g. Notepad, Sublime Text, **never** Microsoft Word --- it'll f**k everything up), making sure to save frequently, so that your hard work is not at the mercy of the browser gods.
Also, you can preview what you're writing by switching to the "Preview" tab.
No more mistakes!

Once you're done writing your lesson, add it, commit, and push.
If you're not sure how to do that, or don't have a Git GUI client installed, type into Git Bash

    git add -A
    git commit -m "Your commit message here"
    git push

This will update the GitHub repository with your latest changes.

#### Linking to lessons

To link to a lesson, use the following URL format:

    /lessons/<subclub category>/<lesson id>

For example, if you wished to link to the lesson titled "A history of snooker" in the Snooker for Walruses subclub, you would write `/lessons/snooker-for-walruses/a-history-of-snooker` as your URL.

### Setting up resources

There are two different types of resources:

1. _Lesson-specific resources._ These are placed in the lesson folder
2. _Global resources._ These are placed in the root resources folder

Lesson-specific resources are things such as icons, input text files, and LoL ASCII fan art.
They are the sort of things that are either of no educational use, or would only be referenced with respect to the lesson.

Global resources would be for more important things like high-level example code, concept maps, and syntax reference.
In general, if you want a resource to be prominently visible and searchable, or you have a resource that is referenced frequently, it should be a global resource.

There are no special distinctions between lesson-specific resources and global resources; what separates them is where they're put: in a lesson folder or in the root resources folder.
Here's a handy table to help you figure out whether your resource is lesson-specific or global:

| Resource                 | Corresponding type |
|--------------------------|--------------------|
| Syntax reference         | global             |
| Concept maps             | global             |
| High-level code examples | global             |
| Specific code examples   | lesson-specific    |
| Input/output files       | lesson-specific    |
| Stock image              | lesson-specific    |
| PPT presentations        | lesson-specific    |

As always, use your own judgement with resources.
For example, if the PPT you're uploading is a very high-level overview of the language you're teaching in, that probably deserves to be a global resource, because it's something that people are likely to reference again and again.

#### Linking to resources

To link to a lesson-specific resource in the same lesson folder as the lesson  you are writing, simply use the resource file name as the URL.
So if your resource is named, `garganook.jpg`, simply write that as your URL.

To link to a lesson-specific resource in a different lesson folder, you'll have to write a relative path of the format

    ../<lesson id>/<resource file name>

Continuing our example, let's say that our artwork of this mythical Garganook is in the lesson with id `my-random-drawings`.
The appropriate URL would then be `../my-random-drawings/garganook.jpg`.

To link to a global resource, simply use this URL format:

    /resources/<subclub category>/<resource file name>

### Setting up a schedule

To set up your subclub's schedule, edit the `index.md` file at the root of your subclub folder.
You should see in the front matter, the following block:

    schedule:
      example-lesson: 31 Dec 1969

This is an example schedule for your subclub, featuring a nonexistent lesson with an absurd date.

In general, a valid schedule consists of an entry for each lesson, containing the lesson id and the date that the lesson is scheduled for.
For example, if you have a weekly series of lessons starting 4 May 2018, your schedule would look something like this:

    schedule:
      a-history-of-snooker: 4 May 2018
      playing-with-flippers: 11 May 2018
      outsmarting-your-opponent: 18 May 2018

Note that the entries are indented two spaces from the beginning of the line, and that the date is of the format `<day> <month name> <year>`.
Regarding dates, please use either the format shown above (three-letter abbreviations for months OK), or ISO-8601 (aka YYYY-MM-DD, aka https://xkcd.com/1179).
Also note that, when creating your schedule, be sure to delete the example entry --- you don't want to confuse any prospective readers!

### Publishing your subclub

Once you feel that your subclub is ready for inclusion into the main site, submit an issue on the main mss-csec.github.io repo. In the title, write

> [Subclub] Add subclub <your subclub name>

and provide the GitHub link to the subclub in the description.
A member of the Web Ops team will come by, review everything, and add your subclub to the main site.
Thanks to the magic of Git, you won't have to open any more new issues when you update your content --- just commit, push, and when the site is rebuilt every one in a while, it'll automatically pull in your latest changes.

Congratulations! You've finished the basic instructions.
Read on for some more advanced stuff.

### Additional front matter variables

We also support the following variables.

#### The `addons` variable

The addons variable consists of a hash.
All keys are optional.

    addons:
      scripts:
        - [...]
      styles:
        - [...]

##### `scripts`

A list of URLS to external scripts.
These scripts will be injected into the head element and executed in the order listed before the `DOMContentLoaded` page event, but are parsed asyncronously of the page.
Thus, any inline scripts that depend on these external scripts must be wrapped in an event listener for the `DOMContentLoaded` event, like so:

```javascript
window.addEventListener('DOMContentLoaded', function (e) {
  // your script-dependent code here
});
```

###### Example

    addons:
      scripts:
        - https://cdnjs.cloudflare.com/ajax/libs/codemirror/4.7.0/codemirror.min.js
        - https://cdnjs.cloudflare.com/ajax/libs/codemirror/4.7.0/mode/haskell/haskell.min.js
        - https://cdnjs.cloudflare.com/ajax/libs/mathjs/3.15.0/math.min.js

##### `styles`

A list of URLS to external styles.

###### Example

    addons:
      styles:
        - https://cdnjs.cloudflare.com/ajax/libs/codemirror/4.7.0/codemirror.min.css
        - https://cdnjs.cloudflare.com/ajax/libs/codemirror/4.7.0/theme/monokai.min.css
        - https://cdnjs.cloudflare.com/ajax/libs/cssgram/0.1.10/cssgram.min.css

### Real-life examples

Here's some example subclubs to look at:

- [Web Development](https://github.com/mss-csec/web-development-subclub)

## Contributing

Fork repo, new branch, make changes, pull request.
That's it.
There isn't really much.
This is a simple project after all.

## Maintainer

Contact @tyxchen for queries, issues, internet hugs and the like.

_Last modified: 2017-08-06_
