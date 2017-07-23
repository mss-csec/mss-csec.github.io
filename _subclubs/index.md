---
layout: landing
title: Subclubs
permalink: /subclubs/
category: subclub-landing
---

## List of subclubs

<ul>
  {% assign subclubs = site.subclubs | group_by: "category" | order_by: "category" %}
  {% for subclub in subclubs %}
    {% assign subclub_name = subclub.name %}
    {% if subclub_name != "subclub-landing" %}
      {% assign subclub_index = subclub.items[0] %}
  <li><a href="{{ site.baseurl}}/{{ subclub_name }}/">{{ subclub_index.title }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
