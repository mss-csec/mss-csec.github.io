---
liquid: true
---

queryKey = 'q'
storageKey = 'search_idx'

contentLength = 300

idx = null
store = {}

# Extract query from URL
extractQuery = (query) ->
  searchString = window.location.search.slice 1
  index = searchString.indexOf query + '='

  query = searchString.slice index + query.length + 1,
    searchString.indexOf('&', index) + 1 or Infinity
  return decodeURIComponent query.replace(/\+/g, '%20')

# Render list of results as HTML
renderResults = (results) ->
  searchResults = $('#search-results')

  if results.length > 0
    builder = []

    for result in results
      item = store[result.ref]
      builder.push "<article>
        <header>
          <h3><a href='#{item.url}'>#{item.title}</a></h3>
        </header>
        <p>#{UTILS.fuzzyTruncate(item.content, contentLength)}</p>
      </article>"

    searchResults.html builder.join('')
  else
    searchResults.html '<h3>No search results found.</h3>'

# Initialize search engine
initSearch = (rawStore) ->
  commit = "{% if site.production %}{{ site.build_version }}
  {% else %}#{Date.now()}
  {% endif %}"

  if null != localStorage.getItem storageKey
    idx = JSON.parse(localStorage.getItem(storageKey))

    if commit == idx.commit
      return idx = lunr.Index.load idx.store

  idx = lunr () ->
    this.ref 'id'
    this.field 'title'
    this.field 'subclub'
    this.field 'content'
    this.field 'type'

    for own key of rawStore.subclubs
      { title, subclub, content, url } = rawStore.subclubs[key]
      store[key] = { type: 'subclub', title, content, url }
      this.add { id: key, type: 'subclub', title, subclub, content }

    for own key of rawStore.posts
      { title, content, url } = rawStore.posts[key]
      store[key] = { type: 'post', title, content, url }
      this.add { id: key, type: 'post', title, content }

  localStorage.setItem storageKey, JSON.stringify { commit, store: idx }

  idx

# Search for a query
window.search = (query) ->
  results = idx.search query

  renderResults results

###
{% comment %} Source for minimized JS below

{% assign subclubs = site.subclubs | group_by: "category" | sort: "category" | where_exp: "item", "item.name != 'subclub-landing'" %}
searchStore = {
  # Iterate over subclubs
  subclubs: {
{% for subclub_obj in subclubs limit:row_size offset:row_offset %}
  {% assign subclub_index = subclub_obj.items | where: "layout", "landing" | first %}
  {% assign subclub_schedule = subclub_index.schedule %}
  {% assign subclub_title = subclub_index.title %}
  {% assign subclub = subclub_obj.name %}
  {% assign resources = site.resources | group_by: "category" | where: "name", subclub | first %}
  {% if site.production == true %}
    {% assign lessons = site.lessons | group_by: "category" %}
    {% assign subclub_obj = lessons | where: "name", subclub | first %}
  {% endif %}
    # Iterate over lessons
  {% for entry in subclub_schedule %}
    {% assign lesson_title = subclub | xml_escape %}
    {% assign lesson_url = subclub_url | uri_escape %}
    {% assign lesson_content = subclub | xml_escape %}
    {% for item in subclub_obj.items %}
      {% assign split_path = item.path | split: '/' %}
      {% if split_path contains entry[0] %}
        {% assign lesson_title = item.title | xml_escape %}
        {% assign lesson_url = item.url | split: '/' | pop | join: '/' | uri_escape %}
        {% assign lesson_content = item.content | strip_html | strip_newlines | jsonify %}
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
      content: {{ resource.content | strip_html | strip_newlines | jsonify }}
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
      content: {{ post.content | strip_html | strip_newlines | jsonify }}
    },
{% endfor %}
  }
};
{% endcomment %}
###
{% assign subclubs = site.subclubs | group_by: "category" | sort: "category" | where_exp: "item", "item.name != 'subclub-landing'" %}searchStore = {subclubs:{ {% for subclub_obj in subclubs %}{% assign subclub_index = subclub_obj.items | where: "layout", "landing" | first %}{% assign subclub_schedule = subclub_index.schedule %}{% assign subclub = subclub_obj.name %}{% assign resources = site.resources | group_by: "category" | where: "name", subclub | first %}{% if site.production == true %}{% assign lessons = site.lessons | group_by: "category" %}{% assign subclub_obj = lessons | where: "name", subclub | first %}{% endif %}{% for entry in subclub_schedule %}{% assign lesson_title = subclub | xml_escape %}{% assign lesson_url = subclub_url | uri_escape %}{% assign lesson_content = subclub | sml_escape %}{% for item in subclub_obj.items %}{% assign split_path = item.path | split: '/' %}{% if split_path contains entry[0] %}{% assign lesson_title = item.title | xml_escape %}{% assign lesson_url = item.url | split: '/' | pop | join: '/' | uri_escape %}{% assign lesson_content = item.content | strip_html | strip_newlines | jsonify %}{% break %}{% endif %}{% endfor %}"{{ lesson_url | slugify }}":{url:"{{ lesson_url }}",title:"{{ lesson_title }}",subclub:"{{ subclub | xml_escape }}",content:{{ lesson_content }}},{% endfor %}{% if resources.items %}{% for resource in resources.items %}"{{ resource.url | slugify }}":{url:"{{ resource.url | uri_escape }}",title:"{{ resource.title | xml_escape }}",subclub:"{{ subclub | xml_escape }}",content:{{ resource.content | strip_html | strip_newlines | jsonify }}},{% endfor %}{% endif %}{% endfor %}},posts:{ {% for post in site.posts %}"{{ post.url | slugify }}":{url:"{{ post.url | uri_escape }}",title:"{{ post.title | xml_escape }}",content:{{ post.content | strip_html | strip_newlines | jsonify }}},{% endfor %}}};
$(() ->
  query = extractQuery queryKey
  $('#search-query').text query
  $('#search').val query

  $('#search-form').on 'submit', (e) ->
    query = $('#search').val()
    e.preventDefault()

    $('#search-query').text query
    history.pushState { query }, '', "?#{queryKey}=#{query}"
    window.search query

  $(window).on 'popstate', (e) ->
    state = e.originalEvent.state
    $('#search-query').text state.query
    $('#search').val state.query
    window.search state.query

  history.replaceState { query }, '', "?#{queryKey}=#{query}"

  initSearch searchStore
  window.search query
)
