---
---

# Schedule

module.exports = (APP) ->
  # Index of months
  MONTHS = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]

  # Format date in '%B %d, %Y' form
  fmtDate = (date) ->
    date = new Date(date) unless date instanceof Date

    "#{MONTHS[date.getMonth()]} #{date.getDate()}, #{date.getFullYear()}"

  # Loads a given JSON schedule, and optionally saves it into the global APP
  # object
  #
  # sched: A hash where the keys are the lesson id, and the values hashes
  #        containing:
  #         - the date of the lesson
  #         - the lesson #
  #         - the lesson's title
  #         - the lesson's URL
  #        Cloned inside the method to prevent side effects.
  # [save=true]: Whether to save the schedule into the global APP object.
  APP.loadSubclubSchedule = (sched, save = true) ->
    clonedSched = JSON.parse JSON.stringify sched
    schedKeys = Object.keys clonedSched

    for id, i in schedKeys
      origData = clonedSched[id]

      # Version 2: Dates can be blank, to represent a repeat of the last entry
      if origData.date == ''
        origData.date = '0'

      # Version 2: Dates can be represented either as absolute dates, or offsets
      # to the last given date
      if isFinite new Date origData.date
        # Date is absolute
        origData.date = (new Date origData.date).setHours APP.SUBCLUB_END_HOUR
      else
        # Date is offset
        # 1 day = 24 * 60 * 60 * 1000 = 86400000 milliseconds
        origData.date = new Date(parseInt(origData.date) * 86400000 +
          clonedSched[schedKeys[i-1]].date).getTime()

      origData.lesson = parseInt origData.lesson

    APP.schedule = clonedSched if save

    clonedSched


  # Returns the most recent and the next up lesson given a complete schedule
  # in hash form
  #
  # [data={}]: A hash where the keys are the lesson id, and the values either a
  #            date in a JavaScript-parsable format, or a hash containing such a
  #            date field.
  APP.getScheduleExtrema = (data = {}) ->
    sched = {}
    today = (new Date()).getTime()

    if Object.keys(data).length
      sched = APP.loadSubclubSchedule data, false
    else
      sched = APP.schedule

    for id, lesson of sched
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
      if lesson.date - today <= 0 and
      (lesson.date - sched[mostRecent].date >= 0 or
      sched[mostRecent].date - today >= 0)
        if lesson.date - sched[mostRecent].date == 0 and
        lesson.l - sched[mostRecent].l < 0
          continue

        mostRecent = id

      # ditto, but replace "before" with "after", "most recent" with "next up",
      # and "greater" with "lesser"
      if lesson.date - today > 0 and
      (lesson.date - sched[nextUp].date <= 0 or sched[nextUp].date - today < 0)
        if lesson.date - sched[nextUp].date == 0 and
        lesson.l - sched[nextUp].l > 0
          continue

        nextUp = id

    if sched[mostRecent].date - today < 0
      dateMostRecent = sched[mostRecent].date

    if sched[nextUp].date - today >= 0
      dateNextUp = sched[nextUp].date

    mostRecent: if dateMostRecent? then mostRecent else null
    nextUp: if dateNextUp? then nextUp else null

  # Renders the most recent and next up lesson titles and dates in a valid HTML
  # element
  #
  # $el: The element to render within. Must contain elements with class
  #      '.lesson-last' and/or elements with class '.lesson-last'
  # [data={}]: A hash where the keys are the lesson id, and the values a hash
  #            containing the lesson URL, the lesson date, and the lesson title.
  APP.renderSubclubSchedule = ($el, data = {}) ->
    parsedData = {}

    if Object.keys(data).length
      parsedData = APP.loadSubclubSchedule data, false
    else
      parsedData = APP.schedule

    scheduleData = APP.getScheduleExtrema parsedData

    # Store elements
    $lessonLast = $el.find '.lesson-last'
    $lessonNext = $el.find '.lesson-next'

    # Get tooltip positioning data
    mostRecentBalloonPos = $el.attr('data-lesson-last-balloon-pos') or 'right'
    nextUpBalloonPos = $el.attr('data-lesson-next-balloon-pos') or 'left'

    if scheduleData.mostRecent != null
      $lessonLast.each () ->
        _this = $(this)
        lesson = parsedData[scheduleData.mostRecent]
        lesson.title = lesson.title.replace /^.*?@/, ''
        if _this.is 'a'
          _this.addClass 'lesson-link'
            .attr 'href', lesson.url
            .attr 'data-balloon', fmtDate lesson.date
            .attr 'data-balloon-pos', mostRecentBalloonPos
            .attr 'data-balloon-bluntish', true
            .html lesson.title
        else
          _this.html "<a href='#{lesson.url}'
              class='lesson-link'
              data-balloon='#{fmtDate lesson.date}'
                data-balloon-pos='#{mostRecentBalloonPos}'
                data-balloon-bluntish>
            #{lesson.title}</a>"
    else
      $lessonLast.each () ->
        _this = $(this)
        if _this.prop 'tagName' == 'A'
          _this.addClass 'lesson-link'
            .addClass 'disabled'
            .html "null"
        else
          _this.html "<a class='lesson-link disabled'>null</a>"

    if scheduleData.nextUp != null
      $lessonNext.each () ->
        _this = $(this)
        lesson = parsedData[scheduleData.nextUp]
        lesson.title = lesson.title.replace /^.*?@/, ''
        if _this.is 'a'
          _this.addClass 'lesson-link'
            .attr 'href', lesson.url
            .attr 'data-balloon', lesson.title
            .attr 'data-balloon-pos', nextUpBalloonPos
            .attr 'data-balloon-bluntish', true
            .html fmtDate lesson.date
        else
          _this.html "<a href='#{lesson.url}'
              class='lesson-link'
              data-balloon='#{lesson.title}'
                data-balloon-pos='#{nextUpBalloonPos}'
                data-balloon-bluntish>
            #{fmtDate lesson.date}</a>"
    else
      $lessonNext.each () ->
        _this = $(this)
        if _this.prop 'tagName' == 'A'
          _this.addClass 'lesson-link'
            .addClass 'disabled'
            .html "null"
        else
          _this.html "<a class='lesson-link disabled'>null</a>"

    # Timeline link titles might be screwed up a bit, so we fix that here
    # TODO: possibly move to separate function w/ eventual reactification?
    $('.lesson-link[data-id]').each (e) ->
      e.setAttribute 'title', fmtDate parsedData[e.dataset.id].date

    true
