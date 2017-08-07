---
layout: landing
title: Subclubs
permalink: /subclubs/
category: subclub-landing
---

## List of subclubs

<ul>
  {% assign subclubs = site.subclubs | group_by: "category" | sort: "category" %}
  {% for subclub in subclubs %}
    {% assign subclub_name = subclub.name %}
    {% if subclub_name != "subclub-landing" %}
      {% assign subclub_index = subclub.items | where: "layout", "landing" | first %}
  <li><a href="{{ site.baseurl }}/{{ subclub_name | uri_escape }}/">{{ subclub_index.title | xml_escape }}</a></li>
    {% endif %}
  {% endfor %}
</ul>
