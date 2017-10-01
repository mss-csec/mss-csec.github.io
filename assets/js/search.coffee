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
    try
      savedStore = JSON.parse localStorage.getItem storageKey

    if commit == savedStore.commit
      store = savedStore.store
      return idx = lunr.Index.load savedStore.idx

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

  localStorage.setItem storageKey, JSON.stringify { commit, store, idx }

  idx

# Search for a query
executeSearch = (query) ->
  results = idx.search query

  $('#search').val query
  $('#search-query').text query
  $('title')
    .text "Search results for #{query} | {{ site.title }} • {{ site.description }}"

  renderResults results

$(() ->
  query = extractQuery queryKey

  $('#search-form').on 'submit', (e) ->
    newQuery = $('#search').val()
    e.preventDefault()

    history.pushState { newQuery }, '', "?#{queryKey}=#{newQuery}"
    executeSearch newQuery

  $(window).on 'popstate', (e) ->
    executeSearch e.originalEvent.state.query

  history.replaceState { query }, '', "?#{queryKey}=#{query}"

  initSearch searchStore
  executeSearch query
)
