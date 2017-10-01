---
---

###
Main coffeescript file
###

APP = {}
UTILS = {}

CONSTS =
  animDuration: 230
  cookieCollapseSidebar: 'collapseSidebar'
  cookieStickyPrefix: 'sticky-'
  cookieTheme: 'theme'

UTILS.intSort = (a, b) -> a - b
UTILS.reverseIntSort = (a, b) -> b - a

UTILS.spaceship = (a, b) ->
  a < b ? -1 : (a > b ? 1 : 0)

UTILS.setIndefiniteCookie = (key, value) ->
  Cookies.set key, value, expires: 365

# Truncate a string of text to at most <length> characters, without severing
# words
UTILS.fuzzyTruncate = (text, length = 250, clipper = '...') ->
  if text.length <= length then return text

  lastDelim = text.lastIndexOf " ", length

  return text.slice(0, if lastDelim > -1 then lastDelim else Infinity) + clipper

APP.SUBCLUB_END_HOUR = 17;

# Returns the most recent and the next up lesson given a complete schedule
# in hash form
#
# data: A hash where the keys are the lesson id, and the values either a date
#       in a JavaScript-parsable format, or a hash containing such a date field.
#       Cloned inside the method to prevent side effects.
APP.loadSubclubSchedule = (data) ->
  clonedData = $.extend true, {}, data
  today = (new Date()).getTime()

  for k, v of clonedData
    v = (new Date v.date ? v).setHours(APP.SUBCLUB_END_HOUR)
    clonedData[k] = v

    # Should only be true on initialization
    if not mostRecent? and not nextUp?
      mostRecent = k
      nextUp = k

    if v < today and
    (v > clonedData[mostRecent] or clonedData[mostRecent] > today)
       mostRecent = k

    if v > today and
    (v < clonedData[nextUp] or clonedData[nextUp] < today)
      nextUp = k

  if clonedData[mostRecent] < today
    dateMostRecent = new Date clonedData[mostRecent]

  if clonedData[nextUp] >= today
    dateNextUp = new Date clonedData[nextUp]

  mostRecent:
    id: if dateMostRecent? then mostRecent else null
    date: dateMostRecent
  nextUp:
    id: if dateNextUp? then nextUp else null
    date: dateNextUp

# Loads a schedule from a URL
#
# @private
__loadSubclubScheduleFromUrl = (url) ->
  $.ajax url: url
  .then (resp) ->
    JSON.parse resp
  .then (data) ->
    [data, APP.loadSubclubSchedule data]

# Renders the most recent and next up lesson titles and dates in a valid HTML
# element
#
# $el: The element to render within. Must contain elements with class
#      '.lesson-last' and/or elements with class '.lesson-last'
# data: A hash where the keys are the lesson id, and the values a hash
#       containing the lesson URL, the lesson date, and the lesson title.
APP.renderSubclubSchedule = ($el, data) ->
  scheduleData = {}

  if JSON.stringify(data)[0] == '{'
    scheduleData = APP.loadSubclubSchedule data
  else
    __loadSubclubScheduleFromUrl data
    .then (d) ->
      [data, scheduleData] = d
    .then null, (err) ->
      console.log "Couldn't load or parse schedule data at #{data}"

  # Store elements
  $lesson_last = $el.find '.lesson-last'
  $lesson_next = $el.find '.lesson-next'

  if scheduleData.mostRecent.id != null
    $lesson_last.each () ->
      _this = $(this)
      lesson = data[scheduleData.mostRecent.id]
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link'
        _this.attr 'href', lesson.url
        _this.attr 'title', lesson.date
        _this.html lesson.title
      else
        _this.html "<a href='#{lesson.url}'
          class='lesson-link' title='#{lesson.date}'>#{lesson.title}</a>"
  else
    $lesson_last.each () ->
      _this = $(this)
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link', 'disabled'
        _this.html "null"
      else
        _this.html "<a class='lesson-link disabled'>null</a>"

  if scheduleData.nextUp.id != null
    $lesson_next.each () ->
      _this = $(this)
      lesson = data[scheduleData.nextUp.id]
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link'
        _this.attr 'href', lesson.url
        _this.attr 'title', lesson.title
        _this.html lesson.date
      else
        _this.html "<a href='#{lesson.url}'
          class='lesson-link' title='#{lesson.title}'>#{lesson.date}</a>"
  else
    $lesson_next.each () ->
      _this = $(this)
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link', 'disabled'
        _this.html "null"
      else
        _this.html "<a class='lesson-link disabled'>null</a>"

  true

# Opens a given sidebar
#
# $sidebar: The sidebar to open
#
# @private
__openSidebar = ($sidebar) ->
  $sidebar.removeClass 'closed'
  $sidebar.find('.collapse-el').removeClass 'closed'
    .attr 'title', 'Collapse sidebar'
    .html '&laquo;'
  UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '0'

# Collapses a given sidebar
#
# $sidebar: The sidebar to collapse
#
# @private
__collapseSidebar = ($sidebar) ->
  $sidebar.addClass 'closed'
  $sidebar.find('.collapse-el').addClass 'closed'
    .attr 'title', 'Open sidebar'
    .html '&raquo;'
  UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '1'

# Toggles the sidebar that is the ancestor of the element this function is
# bound to
#
# e: The event object passed to this handler
APP.toggleSidebar = (e) ->
  e.preventDefault()

  $target = $(e.target)
  $sidebar = $target.closest '.sidebar-collapsible'
  $mainContent = $('#main-content')
  isClosed = $target.hasClass 'closed'

  if isClosed
    # Open sidebar
    __openSidebar $sidebar
    $mainContent.removeClass 'twelve'
      .addClass 'nine'
  else
    # Collapse sidebar
    __collapseSidebar $sidebar
    $mainContent.removeClass 'nine'
      .addClass 'twelve'

  true

# The current sitewide theme
APP.currentTheme = 'light'

# Cross-browser way to dispatch a custom event
__dispatchCustomEvent = (obj, name, detail = null) ->
  if typeof CustomEvent.constructor.name != 'undefined'
    obj.dispatchEvent new CustomEvent(name, { detail })
  else
    event = document.createEvent 'CustomEvent'
    event.initCustomEvent name, false, false, detail
    obj.dispatchEvent event

# Changes the sitewide theme
#
# theme: A string, either 'light' or 'dark', corresponding to the desired theme
APP.changeTheme = (theme) ->
  $t = $('.toggled-theme');
  $t.each () ->
    $e = $(this)
    altProp = $e.attr 'data-alt-prop'
    altKey = if theme == 'dark' then 'data-alt-dark' else 'data-alt-light'
    newKey = if theme == 'dark' then 'data-alt-light' else 'data-alt-dark'
    oldVal = $e.attr altProp
    newVal = $e.attr altKey

    $e.attr altProp, newVal
    $e.attr newKey, oldVal

  if theme == 'dark'
    $('body').addClass 'theme-dark'
    APP.currentTheme = 'dark'
  else
    $('body').removeClass 'theme-dark'
    APP.currentTheme = 'light'

  __dispatchCustomEvent window, 'changetheme'

# Unobfuscates our club email
APP.revealEmail = () ->
  email = `[[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],(![]+[])[+!+[]],(!![]+[])[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],([![]]+[][[]])[+!+[]+[+[]]],(![]+[])[!+[]+!+[]],(![]+[])[!+[]+!+[]],(!![]+[])[!+[]+!+[]+!+[]],(+(+!+[]+[+!+[]]+(!![]+[])[!+[]+!+[]+!+[]]+[!+[]+!+[]]+[+[]])+[])[+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[!+[]+!+[]],(![]+[])[!+[]+!+[]+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],([![]]+[][[]])[+!+[]+[+[]]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],(![]+[])[+!+[]],([![]]+[][[]])[+!+[]+[+[]]],(![]+[])[!+[]+!+[]],(+(+!+[]+[+!+[]]+(!![]+[])[!+[]+!+[]+!+[]]+[!+[]+!+[]]+[+[]])+[])[+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]].map(function(a){return a|0?String[atob('ZnJvbUNoYXJDb2Rl')](a):a}).join('')`
  alert email

APP.onload = () ->
  console.log "Loaded on #{(new Date()).toLocaleString()}"

  # Parse theme changes
  if 'dark' == Cookies.get CONSTS.cookieTheme
    APP.changeTheme 'dark'
    $('#toggle-dark-theme').prop 'checked', true

  # Add event handlers
  $('#toggle-dark-theme').on 'change', () ->
    theme = Cookies.get CONSTS.cookieTheme

    if theme == 'dark'
      Cookies.set CONSTS.cookieTheme, 'light'
      APP.changeTheme 'light'
    else
      Cookies.set CONSTS.cookieTheme, 'dark'
      APP.changeTheme 'dark'

  $('.announcement-sticky').on 'click', 'a', (e) ->
    $sticky = $(this).closest '.announcement-sticky'

    e.preventDefault()

    $sticky.remove()

    Cookies.set "#{CONSTS.cookieStickyPrefix}#{$sticky.data 'id'}", '1'

    if $(this).attr('href') != '#'
      window.location = $(this).attr 'href'

  # Scrolling
  $(window).on 'scroll', (e) ->
    if window.scrollY > 100
      $('body:not(.no-hero) .site-header').removeClass 'at-top'
    else
      $('body:not(.no-hero) .site-header').addClass 'at-top'

  # DOM manipulation
  $('body:not(.no-hero) .site-header').addClass 'at-top'

  __DOMRemoveSticky = () ->
    sticky = $('.announcement-sticky')

    if Cookies.get("#{CONSTS.cookieStickyPrefix}#{sticky.data 'id'}") == '1' or
    (sticky.length and
    (new Date()).getTime() > (new Date(sticky.data 'displayUntil')).getTime())
      sticky.remove()

  __DOMRemoveSticky()

  $('.collapse-el').html '&laquo;'
  $('.collapse-el.closed').html '&raquo;'

  if '1' == Cookies.get CONSTS.cookieCollapseSidebar
    __collapseSidebar $('.sidebar-collapsible')
    $('#main-content').removeClass 'nine'
      .addClass 'twelve'

  # Unhide body
  $('body')
    .removeClass 'no-js'

  # KaTeX rendering
  __katexFail = false
  __renderKatex = (isDisplay) ->
    () ->
      try
        katex.renderToString $(this).text().replace(/%.*/g, ''),
          throwOnError: true
          displayMode: isDisplay
      catch
        # Set up loading MathJax
        __katexFail = true
        $(this)

  __useMathJax = () ->
    mjSrc = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js'
    mjSRI = 'sha384-Ra6zh6uYMmH5ydwCqqMoykyf1T/+ZcnOQfFPhDrp2kI4OIxadnhsvvA2vv9A7xYv'

    script = document.createElement 'script'
    script.src = mjSrc
    script.integrity = mjSRI
    script.crossOrigin = 'anonymous'
    document.querySelector('head').appendChild script

  $('script[type="math/tex"]').replaceWith __renderKatex false

  $('script[type="math/tex; mode=display"]').replaceWith __renderKatex true

  window.renderMathInElement document.body,
    delimiters: [
      { left: "\\[", right: "\\]", display: true }
      { left: "\\(", right: "\\)", display: false }
    ]
    throwOnError: true
    errorCallback: () ->
      console.log 'KaTeX rendering failed! Loading MathJax'
      __useMathJax()

  if __katexFail
    console.log 'KaTeX rendering failed! Loading MathJax'
    __useMathJax()

  # Anchor-js
  anchors.options =
    visible: 'touch',
    icon: '§'
  anchors.add '#main-content h2, #main-content h3'

  # Run page scripts
  SCRIPTS.run()

window.APP = APP
window.UTILS = UTILS

$(APP.onload)
