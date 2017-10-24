(function() {
  var contentLength, executeSearch, extractQuery, idx, initSearch, queryKey, renderResults, sanitizeQuery, storageKey, store,
    hasProp = {}.hasOwnProperty;

  queryKey = 'q';

  storageKey = 'search_idx';

  contentLength = 300;

  idx = null;

  store = {};

  sanitizeQuery = function(query) {
    return encodeURIComponent(query).replace(/%20/g, '+');
  };

  extractQuery = function(query) {
    var index, searchString;
    searchString = window.location.search.slice(1);
    index = searchString.indexOf(query + '=');
    query = searchString.slice(index + query.length + 1, searchString.indexOf('&', index) + 1 || searchString.length);
    return decodeURIComponent(query.replace(/\+/g, '%20'));
  };

  renderResults = function(results) {
    var builder, i, item, len, result, searchResults;
    searchResults = $('#search-results');
    if (results.length > 0) {
      builder = [];
      for (i = 0, len = results.length; i < len; i++) {
        result = results[i];
        item = store[result.ref];
        builder.push("<article> <header> <h3><a href='" + item.url + "'>" + item.title + "</a></h3> </header> <p>" + (UTILS.fuzzyTruncate(item.content, contentLength)) + "</p> </article>");
      }
      return searchResults.html(builder.join(''));
    } else {
      return searchResults.html('<h3>No search results found.</h3>');
    }
  };

  initSearch = function(rawStore) {
    var commit, savedStore;
    commit = "a45342e";
    if (null !== localStorage.getItem(storageKey)) {
      try {
        savedStore = JSON.parse(localStorage.getItem(storageKey));
      } catch (error) {}
      if (commit === savedStore.commit) {
        store = savedStore.store;
        return idx = lunr.Index.load(savedStore.idx);
      }
    }
    idx = lunr(function() {
      var content, key, ref, ref1, ref2, ref3, results1, subclub, title, url;
      this.ref('id');
      this.field('title');
      this.field('subclub');
      this.field('content');
      this.field('type');
      ref = rawStore.subclubs;
      for (key in ref) {
        if (!hasProp.call(ref, key)) continue;
        ref1 = rawStore.subclubs[key], title = ref1.title, subclub = ref1.subclub, content = ref1.content, url = ref1.url;
        store[key] = {
          type: 'subclub',
          title: title,
          content: content,
          url: url
        };
        this.add({
          id: key,
          type: 'subclub',
          title: title,
          subclub: subclub,
          content: content
        });
      }
      ref2 = rawStore.posts;
      results1 = [];
      for (key in ref2) {
        if (!hasProp.call(ref2, key)) continue;
        ref3 = rawStore.posts[key], title = ref3.title, content = ref3.content, url = ref3.url;
        store[key] = {
          type: 'post',
          title: title,
          content: content,
          url: url
        };
        results1.push(this.add({
          id: key,
          type: 'post',
          title: title,
          content: content
        }));
      }
      return results1;
    });
    localStorage.setItem(storageKey, JSON.stringify({
      commit: commit,
      store: store,
      idx: idx
    }));
    return idx;
  };

  executeSearch = function(query) {
    var results;
    results = idx.search(query);
    $('#search').val(query);
    $('#search-query').text(query);
    $('title').text("Search results for " + query + " | MSS CSEC • Markville's Computer Science Education Club");
    return renderResults(results);
  };

  $(function() {
    var query;
    query = extractQuery(queryKey);
    $('#search-form').on('submit', function(e) {
      var newQuery;
      newQuery = $('#search').val();
      e.preventDefault();
      history.pushState({
        newQuery: newQuery
      }, '', "?" + queryKey + "=" + (sanitizeQuery(newQuery)));
      return executeSearch(newQuery);
    });
    $(window).on('popstate', function(e) {
      return executeSearch(e.originalEvent.state.query);
    });
    history.replaceState({
      query: query
    }, '', "?" + queryKey + "=" + (sanitizeQuery(query)));
    initSearch(searchStore);
    return executeSearch(query);
  });

}).call(this);
