---
---

###
Main coffeescript file
###

APP = {}
UTILS = {}

CONSTS =
  cookieCollapseSidebar: 'collapseSidebar'
  cookieTheme: 'theme'

UTILS.intSort = (a, b) -> a - b
UTILS.reverseIntSort = (a, b) -> b - a

UTILS.setIndefiniteCookie = (key, value) ->
  Cookies.set key, value, expires: 365

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

__openSidebar = ($sidebar, $target) ->
  $sidebar.removeClass 'closed'
  $target.removeClass 'closed'
    .attr 'title', 'Collapse sidebar'
    .html '&laquo;'
  UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '0'

__collapseSidebar = ($sidebar, $target) ->
  $sidebar.addClass 'closed'
  $target.addClass 'closed'
    .attr 'title', 'Open sidebar'
    .html '&raquo;'
  UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '1'

APP.toggleSidebar = (e) ->
  e.preventDefault()

  $target = $(e.target)
  $sidebar = $target.closest '.sidebar-collapsible'
  $mainContent = $('#main-content')
  isClosed = $target.hasClass 'closed'

  if isClosed
    # Open sidebar
    __openSidebar $sidebar, $target
    $mainContent.removeClass 'twelve'
      .addClass 'nine'
  else
    # Collapse sidebar
    __collapseSidebar $sidebar, $target
    $mainContent.removeClass 'nine'
      .addClass 'twelve'

  true

APP.changeTheme = (theme = Cookies.get(CONSTS.cookieTheme)) ->
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
    else
      $('body').removeClass 'theme-dark'

APP.toggleDarkTheme = () ->
  theme = Cookies.get CONSTS.cookieTheme

  if theme == 'dark'
    Cookies.set CONSTS.cookieTheme, 'light'
    APP.changeTheme 'light'
  else
    Cookies.set CONSTS.cookieTheme, 'dark'
    APP.changeTheme 'dark'

APP.onload = () ->
  console.log "Testing Coffeescript"

  if 'dark' == Cookies.get CONSTS.cookieTheme
    APP.changeTheme()
    $('#toggle-dark-theme').prop 'checked', true

  $('body').prop 'hidden', false

  $('.collapse-el').html '&laquo;'
  $('.collapse-el.closed').html '&raquo;'

  if '1' == Cookies.get CONSTS.cookieCollapseSidebar
    $sidebar = $('.sidebar-collapsible')
    $target = $sidebar.find '.collapse-el'
    __collapseSidebar $sidebar, $target

  $('#toggle-dark-theme').bind 'change', APP.toggleDarkTheme

window.APP = APP
window.UTILS = UTILS

$(APP.onload)
