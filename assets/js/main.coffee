---
---

###
Main coffeescript file
###

APP = {}
UTILS = {}

UTILS.intSort = (a, b) -> a - b
UTILS.reverseIntSort = (a, b) -> b - a

APP.loadSubclubSchedule = (data) ->
  cloned_data = $.extend true, {}, data
  today = (new Date()).getTime()

  for k, v of cloned_data
    v = (new Date v.date ? v).getTime()
    cloned_data[k] = v

    # Should only be true on initialization
    if not mostRecent? and not nextUp?
      mostRecent = k
      nextUp = k

    if v < today and
    (v > cloned_data[mostRecent] or cloned_data[mostRecent] > today)
       mostRecent = k

    if v > today and
    (v < cloned_data[nextUp] or cloned_data[nextUp] < today)
      nextUp = k

  dateMostRecent = new Date cloned_data[mostRecent]
  dateNextUp = new Date cloned_data[nextUp]
  
  mostRecent:
    id: mostRecent
    date: dateMostRecent
  nextUp:
    id: nextUp
    date: dateNextUp

__loadSubclubScheduleFromUrl = (url) ->
  $.ajax url: url
  .then (resp) ->
    JSON.parse resp
  .then (data) ->
    [data, APP.loadSubclubSchedule data]

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

  $lesson_last.each () ->
    _this = $(this)
    lesson = data[scheduleData.mostRecent.id]
    if _this.prop 'tagName' == 'A'
      _this.attr 'href', lesson.url
      _this.attr 'title', lesson.date
      _this.html lesson.title
    else
      _this.html "<a href='#{lesson.url}' title='#{lesson.date}'>#{lesson.title}</a>"

  $lesson_next.each () ->
    _this = $(this)
    lesson = data[scheduleData.nextUp.id]
    if _this.prop 'tagName' == 'A'
      _this.attr 'href', lesson.url
      _this.attr 'title', lesson.title
      _this.html lesson.date
    else
      _this.html "<a href='#{lesson.url}' title='#{lesson.title}'>#{lesson.date}</a>"

  true

APP.onload = () ->
  console.log "Testing Coffeescript"

window.APP = APP
window.UTILS = UTILS

$(APP.onload)
