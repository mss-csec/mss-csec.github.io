---
---

# Schedule

module.exports = (APP) ->

  # Returns the most recent and the next up lesson given a complete schedule
  # in hash form
  #
  # sched: A hash where the keys are the lesson id, and the values either a date
  #        in a JavaScript-parsable format, or a hash containing such a date
  #        field. Cloned inside the method to prevent side effects.
  APP.loadSubclubSchedule = (sched) ->
    clonedSched = JSON.parse JSON.stringify sched
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

  # Renders the most recent and next up lesson titles and dates in a valid HTML
  # element
  #
  # $el: The element to render within. Must contain elements with class
  #      '.lesson-last' and/or elements with class '.lesson-last'
  # data: A hash where the keys are the lesson id, and the values a hash
  #       containing the lesson URL, the lesson date, and the lesson title.
  APP.renderSubclubSchedule = ($el, data) ->
    scheduleData = {}

    scheduleData = APP.loadSubclubSchedule data

    # Store elements
    $lessonLast = $el.find '.lesson-last'
    $lessonNext = $el.find '.lesson-next'

    # Get tooltip positioning data
    mostRecentBalloonPos = $el.attr('data-lesson-last-balloon-pos') or 'right'
    nextUpBalloonPos = $el.attr('data-lesson-next-balloon-pos') or 'left'

    if scheduleData.mostRecent.id != null
      $lessonLast.each () ->
        _this = $(this)
        lesson = data[scheduleData.mostRecent.id]
        lesson.title = lesson.title.replace /^.*?@/, ''
        if _this.is 'a'
          _this.addClass 'lesson-link'
            .attr 'href', lesson.url
            .attr 'data-balloon', lesson.title
            .attr 'data-balloon-pos', mostRecentBalloonPos
            .attr 'data-balloon-bluntish', true
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
          _this.addClass 'lesson-link'
            .addClass 'disabled'
            .html "null"
        else
          _this.html "<a class='lesson-link disabled'>null</a>"

    if scheduleData.nextUp.id != null
      $lessonNext.each () ->
        _this = $(this)
        lesson = data[scheduleData.nextUp.id]
        lesson.title = lesson.title.replace /^.*?@/, ''
        if _this.is 'a'
          _this.addClass 'lesson-link'
            .attr 'href', lesson.url
            .attr 'data-balloon', lesson.title
            .attr 'data-balloon-pos', nextUpBalloonPos
            .attr 'data-balloon-bluntish', true
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
          _this.addClass 'lesson-link'
            .addClass 'disabled'
            .html "null"
        else
          _this.html "<a class='lesson-link disabled'>null</a>"

    true
