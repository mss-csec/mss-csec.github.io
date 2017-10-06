---
layout: default
addons:
  class: no-hero
  scripts:
    - /assets/lib/lunr.min.js
    - /assets/js/search.js
---
<div class="content container">
  <h4 style="margin-top:100px">Search results for <em id="search-query"></em> :</h4>

  <div id="search-results">
    <h3 class="disabled">Searching...</h3>
  </div>
</div>

<pre>
/* Source for minimized JS below

{% assign subclubs = site.subclubs | group_by: "category" | sort: "category" | where_exp: "item", "item.name != 'subclub-landing'" %}
searchStore = {
  # Iterate over subclubs
  subclubs: {
{% for subclub_obj in subclubs %}
  {% assign subclub_index = subclub_obj.items | where: "layout", "landing" | first %}
  {% assign subclub_schedule = subclub_index.schedule %}
  {% assign subclub = subclub_obj.name %}
  {% assign resources = site.resources | group_by: "category" | where: "name", subclub | first %}
  {% if site.production == true %}
    {% assign lessons = site.lessons | group_by: "category" %}
    {% assign subclub_obj = lessons | where: "name", subclub | first %}
  {% endif %}
    # Iterate over lessons
  {% for entry in subclub_schedule %}
    {% assign lesson_title = subclub | xml_escape %}
    {% assign lesson_url = subclub_index.url %}
    {% assign lesson_content = subclub | xml_escape %}
    {% for item in subclub_obj.items %}
      {% assign split_path = item.path | split: '/' %}
      {% if split_path contains entry[0] %}
        {% assign lesson_title = item.title | xml_escape %}
        {% assign lesson_url = item.url | split: '/' | pop | join: '/' | uri_escape %}
        {% assign lesson_content = item.content | asciidocify | strip_html | jsonify %}
        {% break %}
      {% endif %}
    {% endfor %}
    "{{ lesson_url | slugify }}": {
      url: "{{ lesson_url }}",
      title: "{{ lesson_title }}",
      subclub: "{{ subclub | xml_escape }}",
      content: {{ lesson_content }}
    },
  {% endfor %}
  # Iterate over resources
  {% if resources.items %}
    {% for resource in resources.items %}
    "{{ resource.url | slugify }}": {
      url: "{{ resource.url | uri_escape }}",
      title: "{{ resource.title | xml_escape }}",
      subclub: "{{ subclub | xml_escape }}",
      content: {{ resource.content | asciidocify | strip_html | jsonify }}
    },
    {% endfor %}
  {% endif %}
{% endfor %}
  },
  # Iterate over posts
  posts: {
{% for post in site.posts %}
    "{{ post.url | slugify }}": {
      url: "{{ post.url | uri_escape }}",
      title: "{{ post.title | xml_escape }}",
      content: {{ post.content | asciidocify | strip_html | jsonify }}
    },
{% endfor %}
  }
}; */
</pre>
<script>

{% assign subclubs = site.subclubs | group_by: "category" | sort: "category" | where_exp: "item", "item.name != 'subclub-landing'" %}searchStore = {subclubs:{ {% for subclub_obj in subclubs %}{% assign subclub_index = subclub_obj.items | where: "layout", "landing" | first %}{% assign subclub_schedule = subclub_index.schedule %}{% assign subclub = subclub_obj.name %}{% assign resources = site.resources | group_by: "category" | where: "name", subclub | first %}{% if site.production == false %}{% assign lessons = site.lessons | group_by: "category" %}{% assign subclub_obj = lessons | where: "name", subclub | first %}{% endif %}{% for entry in subclub_schedule %}{% assign lesson_title = subclub | xml_escape %}{% assign lesson_url = subclub_index.url %}{% assign lesson_content = subclub | sml_escape %}{% for item in subclub_obj.items %}{% assign split_path = item.path | split: '/' %}{% if split_path contains entry[0] %}{% assign lesson_title = item.title | xml_escape %}{% assign lesson_url = item.url | split: '/' | pop | join: '/' | uri_escape %}{% assign lesson_content = item.content | asciidocify | strip_html | jsonify %}{% break %}{% endif %}{% endfor %}"{{ lesson_url | slugify }}":{url:"{{ lesson_url }}",title:"{{ lesson_title }}",subclub:"{{ subclub | xml_escape }}",content:{{ lesson_content }}},{% endfor %}{% if resources.items %}{% for resource in resources.items %}"{{ resource.url | slugify }}":{url:"{{ resource.url | uri_escape }}",title:"{{ resource.title | xml_escape }}",subclub:"{{ subclub | xml_escape }}",content:{{ resource.content 
| asciidocify | strip_html | jsonify }}},{% endfor %}{% endif %}{% endfor %}},posts:{ {% for post in site.posts %}"{{ post.url | slugify }}":{url:"{{ post.url | uri_escape }}",title:"{{ post.title | xml_escape }}",content:{{ post.content 
    | asciidocify | strip_html | jsonify }}},{% endfor %}}};
</script>
