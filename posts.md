---
layout: page
title: News & Announcements
permalink: /posts/
---
{% for post in site.posts %}
<article>
  <header>
    <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
    <h6>Posted on <time datetime="{{ post.date | date: site.mdatefmt }}">{{ post.date | date: site.datefmt }}</time></h6>
  </header>
  {{ post.content | markdownify }}
  <footer>
    {% if post.tags.size > 0%}
    <div class="tags">Tags:
      {% for tag in post.tags %}
      <span class="tag">{{ tag }}</span>
      {% endfor %}
    </div>
    {% endif %}
  </footer>
</article>
{% endfor %}
