---
layout: lesson
title: "Using markdown"
category: test
lesson: 4
---

This would be a short summary of the lesson, or whatever you want it to be.
You don't even have to include this paragraph.

## An explanation of the front-matter

The front-matter is the stuff between the two triple-hyphens (`---`) at the top of this file.
They should always be at the top without any preceding whitespace, never at the bottom, and most definitely not in the middle.
The front-matter consists of four fields, of the format `key: value`:

1. A *layout* field, that states how this document will be rendered.
    It should be `lesson` and not anything else.
2. A *title* field, aka the formal title of this lesson.
    Name this the same as the title you defined.
3. A *category* field, which states the subclub that this lesson belongs to.
    See the instructions in the README for further details.
    It should go without saying that this field **must** remain constant across all lessons from the same subclub.
4. A *lesson* field.
    This states what number this lesson is.
    So if the field is set to 1, this lesson will be treated as the first lesson, if it is set to 2, it will treated as the 2nd, etc.

All four fields are mandatory. If any of them are missing or malformed, the site may not compile and chances are your lesson will not appear.

## A review of Markdown syntax

## This is a big heading. Use it for sections. *Don't* use one hash, ever, please.

### This is a smaller heading. Use it for subsections.

#### This is a much smaller heading. Use it for subsubsections.

##### You can use up to

###### six hashes. The more hashes, the less prominent the heading level.

This is a paragraph.
It is recommended to type in the *one sentence per line* style.
You don't have to use it, but it keeps things readable (and looks like poetry to boot).

Paragraphs are delimited by two linebreaks (`\n\n`).
However, you can force line breaks with two spaces (`  `)at the end of a line.  
You can also **bold**, _italicize_, **_bold and italicize_**, or ~~strikethrough~~.
You can also [link to stuff](https://www.google.ca),
![add an image](https://i.imgur.com/U1TnTl0.jpg),
and if you need inline code, `use backticks`.

- We
- also
- have
- lists.
    - Nest them with a four-space indent.

1. Ordered
2. lists
3. are
    1. supported
        1. too!

> And you can quote people here!
> - some random guy on the internet

```cpp
#include <stdio.h>

int main() {
    printf("This is highlighted C++ code\n");

    return 0;
}
```

{% highlight cpp linenos %}
#include <stdio.h>

// This is also C++, but with line numbers.
int main() {
    printf("This is highlighted C++ code\n");

    return 0;
}
{% endhighlight %}

***

Three asterisks form a horizontal rule.
Use it to delimit parts of a lesson.

Tables|have support
------|------------
and it's|awesome!

Did you know that printers used to catch on fire?
I have proof.[^1]

<details>
    <summary>And if you ever need raw HTML&hellip;</summary>
    <p>&#8230;just write it.</p>
</details>

For a complete guide, see [Mastering Markdown by GitHub](https://guides.github.com/features/mastering-markdown/).

[^1]: Citation needed.
