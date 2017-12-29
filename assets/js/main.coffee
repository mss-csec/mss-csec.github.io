---
---

###
Main coffeescript file
###

APP = {}
UTILS = {}

CONSTS =
  ex: 20
  bpMobile: 400
  bpPhablet: 550
  bpTablet: 768
  bpDesktop: 1024
  bpDesktopHd: 1440
  animDuration: 230
  cookieCollapseSidebar: 'collapseSidebar'
  cookieStickyPrefix: 'sticky-'
  cookieTheme: 'theme'
  easterEgg: 'pascha'

Object.freeze CONSTS

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
# sched: A hash where the keys are the lesson id, and the values either a date
#        in a JavaScript-parsable format, or a hash containing such a date
#        field. Cloned inside the method to prevent side effects.
APP.loadSubclubSchedule = (sched) ->
  clonedSched = $.extend true, {}, sched
  today = (new Date()).getTime()

  for id, data of clonedSched
    # t: time of lesson, l: lesson no.
    data =
      t: (new Date data.date ? data).setHours(APP.SUBCLUB_END_HOUR),
      l: parseInt data.lesson
    clonedSched[id] = data

    # Should only be true on initialization
    if not mostRecent? and not nextUp?
      mostRecent = id
      nextUp = id

    # The lesson date is before now, and:
    #  1. the lesson date is before that of the lesson recognized as being the
    #     most recent, OR
    #  2. the lesson recognized as being the most recent is after today
    # If the lesson has the same date as the lesson recognized as being the most
    # recent, use the lesson attribute as tiebreaker (greater is recognized)
    if data.t <= today and
    (data.t >= clonedSched[mostRecent].t or clonedSched[mostRecent].t > today)
      if data.t == clonedSched[mostRecent].t and
      data.l < clonedSched[mostRecent].l
        continue

      mostRecent = id

    # ditto, but replace "before" with "after", "most recent" with "next up",
    # and "greater" with "lesser"
    if data.t > today and
    (data.t <= clonedSched[nextUp].t or clonedSched[nextUp].t < today)
      if data.t == clonedSched[nextUp].t and
      data.l > clonedSched[nextUp].l
        continue

      nextUp = id

  if clonedSched[mostRecent].t < today
    dateMostRecent = new Date clonedSched[mostRecent].t

  if clonedSched[nextUp].t >= today
    dateNextUp = new Date clonedSched[nextUp].t

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
  $lessonLast = $el.find '.lesson-last'
  $lessonNext = $el.find '.lesson-next'

  # Get tooltip positioning data
  mostRecentBalloonPos = $el.data('lesson-last-balloon-pos') or 'right'
  nextUpBalloonPos = $el.data('lesson-next-balloon-pos') or 'left'

  if scheduleData.mostRecent.id != null
    $lessonLast.each () ->
      _this = $(this)
      lesson = data[scheduleData.mostRecent.id]
      lesson.title = lesson.title.replace /^.*?@/, ''
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link'
          .attr 'href', lesson.url
          .attr 'data-balloon', lesson.title
          .attr 'data-balloon-pos', mostRecentBalloonPos
          .attr 'data-ballon-bluntish', true
          .html lesson.title
      else
        _this.html "<a href='#{lesson.url}'
            class='lesson-link'
            data-balloon='#{lesson.date}'
              data-balloon-pos='#{mostRecentBalloonPos}'
              data-balloon-bluntish>
          #{lesson.title}</a>"
  else
    $lessonLast.each () ->
      _this = $(this)
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link', 'disabled'
        _this.html "null"
      else
        _this.html "<a class='lesson-link disabled'>null</a>"

  if scheduleData.nextUp.id != null
    $lessonNext.each () ->
      _this = $(this)
      lesson = data[scheduleData.nextUp.id]
      lesson.title = lesson.title.replace /^.*?@/, ''
      if _this.prop 'tagName' == 'A'
        _this.addClass 'lesson-link'
          .attr 'href', lesson.url
          .attr 'data-balloon', lesson.title
          .attr 'data-balloon-pos', nextUpBalloonPos
          .attr 'data-ballon-bluntish', true
          .html lesson.date
      else
        _this.html "<a href='#{lesson.url}'
            class='lesson-link'
            data-balloon='#{lesson.title}'
              data-balloon-pos='#{nextUpBalloonPos}'
              data-balloon-bluntish>
          #{lesson.date}</a>"
  else
    $lessonNext.each () ->
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
  isClosed = $target.hasClass 'closed'

  if isClosed
    # Open sidebar
    __openSidebar $sidebar
  else
    # Collapse sidebar
    __collapseSidebar $sidebar

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
  $('.toggled-theme').each (i, e) ->
    e.href = window.STYLESHEETS[theme][i]

  if theme == 'dark'
    $('body').removeClass 'theme-light'
    $('body').addClass 'theme-dark'
    APP.currentTheme = 'dark'
    $('.toggle-theme').attr 'title', 'Use light theme'
  else
    $('body').removeClass 'theme-dark'
    $('body').addClass 'theme-light'
    APP.currentTheme = 'light'
    $('.toggle-theme').attr 'title', 'Use dark theme'

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

  # Easter egg
  __easterEgg = () ->
    $('body').toggleClass 'easter-egg'

    if 'false' == Cookies.get CONSTS.easterEgg
      Cookies.set CONSTS.easterEgg, 'true'
    else
      Cookies.set CONSTS.easterEgg, 'false'
  __easterEggTrigger = () ->
    map = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]
    ind = 0
    to = null

    (e) ->
      clearTimeout to

      return if e.altKey or e.ctrlKey or e.metaKey or e.shiftKey

      if map[ind] == e.keyCode
        ind++
      else
        return ind = 0

      if ind == map.length
        ind = 0
        return __easterEgg()

      to = setTimeout () ->
        ind = 0
      , 200
  if 'true' == Cookies.get CONSTS.easterEgg
    $('body').addClass 'easter-egg'
  $(window).on 'keydown', __easterEggTrigger()

  # Add event handlers
  $('.toggle-theme').on 'click', (e) ->
    theme = Cookies.get CONSTS.cookieTheme

    e.preventDefault()

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

  # Header
  if !$('body').hasClass('no-hero') and
  !$('body').hasClass('landing') and
  !$('body').hasClass('lesson') and
  !$('body').hasClass('post') and
  !$('body').hasClass('resource') and
  window.innerWidth > CONSTS.bpTablet
    $(window).on 'scroll', (e) ->
      if window.scrollY > 100
        $('body .site-header').removeClass 'at-top'
      else
        $('body .site-header').addClass 'at-top'
    $('body .site-header').addClass 'at-top'

  # DOM manipulation

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

  # Footnotes
  # Change title attr to footnote content
  # $('a.footnote').each () ->
  #   content = $($(this).attr('href')).text().trim()
  #   $(this).attr 'title', content
  #   $(this).parent().attr 'title', content

  #   content = content.replace /^\d+\.\s+/, ''

  # Reveal footnote tip on click
  $('a.footnote, .footnote-ref a').on 'click', (e) ->
    e.preventDefault()

    $ftnote = $('.footnote-tip')
    $ftnotesrc = $($(this).attr('href'))

    content = $ftnotesrc.html()
      .trim()
      .replace /^<p>([\s\S]+) <a[^>]+>.<\/a><\/p>/, '$1' # Markdown-style
      .replace /^<a.+?>\d+<\/a>\.\s+/, ''                # AsciiDoc-style
      .replace /^[a-z]/, (c) -> c.toUpperCase()

    if $ftnote.html() == content and $ftnote.is ':visible'
      $ftnote.hide()
      $ftnotesrc.removeClass 'targeted'
    else
      # Only show tooltip when actual footnote is not visible in viewport
      unless $(window).scrollTop() + $(window).height() >
        $ftnotesrc.offset().top + $ftnotesrc.outerHeight() and
      $(window).scrollTop() < $ftnotesrc.offset().top
        # Fill in content and display
        $ftnote.html content
          .show()

        # Now that we have the tooltip's dimensions, determine positioning
        offset = $(this).offset()
        top = offset.top - $ftnote.outerHeight() - 5
        left = offset.left - ($ftnote.outerWidth() - $(this).width()) / 2

        # Clamp values so that tooltips don't overflow screen horizontally
        if left + $ftnote.outerWidth() > $(window).width()
          left = $(window).width() - $ftnote.outerWidth() - 5
        else if left < $(this).closest('p').offset().left
          left = $(this).closest('p').offset().left

        # Position tooltip
        $ftnote.css { top, left }

        # Scroll if tooltip is outside viewport
        if $ftnote.offset().top <
            $(window).scrollTop() + $('.site-header').outerHeight()
          $('html, body').scrollTop $ftnote.offset().top -
            $('.site-header').outerHeight() - 5

      $ftnotesrc.addClass 'targeted'

  # Hide footnote on blur
  $('a.footnote, .footnote-ref a').on 'blur', (e) ->
    $this = $(this)
    # https://stackoverflow.com/a/11544685/3472393
    setTimeout () ->
      unless $(document.activeElement).closest('.footnote-tip').length
        $('.footnote-tip').hide()
        $($this.attr('href')).removeClass 'targeted'
      else
        $this.focus()
    , 1

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

window.CONSTS = CONSTS
window.APP = APP
window.UTILS = UTILS

$(APP.onload)
