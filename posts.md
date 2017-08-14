---
layout: page
title: Posts
permalink: /posts/
---
{% for post in site.posts %}
<article>
  <header>
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <h6>Posted on {{ post.date | date: site.datefmt }}</h6>
  </header>
  {{ post.content | markdownify }}
  <footer>
    {% for tag in post.tags %}
     {{ tag }}
    {% endfor %}
  </footer>
</article>
{% endfor %}
