---
layout: landing
title: Subclubs
permalink: /subclubs/
---

There has to be a way to list subclubs...

<ul>
  {% assign subclubs = site.subclubs | group_by: "category" %}
  {% for subclub in subclubs %}
  {% if subclub and subclub != "" and subclub != nil %}
  <li>{{ subclub.name }}</li>
  {% endif %}
  {% endfor %}
</ul>
