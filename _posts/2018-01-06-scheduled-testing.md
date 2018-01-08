---
layout: post
title:  "January 7: Scheduled testing"
date:   2018-01-06
categories: announcements
tags: announcement news sticky
summary: "The CSEC website will be offline January 7, 4-5pm EST."
display_until: 2018-01-07 16:00 -0500
---

Recently, we've been attempting to make the CSEC website really, really fast. So far, we've accomplished:

- Minifying our JavaScript so that they load faster. Sometimes, twice as fast.
- Reducing the size of our webfonts by 83%. _Eighty-three percent_. We didn't think it was possible, but apparently it is.
- Separating the styles that make our site colourful from the styles that make our site flow, so when you switch between themes it keeps the flow (unlike before).
- Loading all of our assets asyncronously so that they doesn't block the page content from loading. It might not actually be faster, but it sure feels a lot faster.
- Clandestinely installing rockets on the GitHub Pages servers. OK, that's a lie.

Our home page now ranks somewhere within the 97th percentile of all websites in terms of loading speed.
Given that that's better than I'll ever achieve on the Senior CCC, I think it's pretty impressive. But of course, we can do better.

Unfortunately, to do better, we need to do some live testing that might break the entire site and be super embarrassing.
That's why we're shutting the CSEC site down for an hour on January 7, 2018, from 4pm to 5pm EST.

We can guarantee, though, that if we succeed, we'll be faster than ever before. Maybe we'll even break into the 99th percentile. We'll see.

### What exactly are you doing?

We're testing using [rawgit.com](https://rawgit.com) to deliver all of our static assets (i.e. CSS, JS) and get around GitHub's 10 minute cache limit.
To do so, we're splitting up the build process, so that static assets go on a separate branch where they can be retrieved by rawgit.

### Why do you need to shut down the site to do this? Can't you just do it on the fly like the other changes you made?

It's good practice to test major changes to the build process or site structure before deployment, to root out bugs and other little nasties that may pop up.
However, while those changes could be (and were) rigorously tested on a local machine, these changes can only be tested live.
In effect, we don't have a chance to flush out whatever nasties might be in our code before deploying it, so we'd rather shut down the site for a bit to do the necessary post-deployment testing.

### Will this take more than one hour?

[Fingers crossed it won't.](https://en.wikipedia.org/wiki/Murphy's_law)

### Is this necessary?

In the grand scheme of things, perhaps not.
But in this age of webpages weighing megabytes and taking 15 seconds to load, we think it's a worthy cause to try and slim down as much as possible.

