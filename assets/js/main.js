
/*
Main coffeescript file
 */

(function() {
  var APP, UTILS, __loadSubclubScheduleFromUrl;

  APP = {};

  UTILS = {};

  UTILS.intSort = function(a, b) {
    return a - b;
  };

  UTILS.reverseIntSort = function(a, b) {
    return b - a;
  };

  APP.loadSubclubSchedule = function(data) {
    var cloned_data, dateMostRecent, dateNextUp, k, mostRecent, nextUp, ref, today, v;
    cloned_data = $.extend(true, {}, data);
    today = (new Date()).getTime();
    for (k in cloned_data) {
      v = cloned_data[k];
      v = (new Date((ref = v.date) != null ? ref : v)).getTime();
      cloned_data[k] = v;
      if ((typeof mostRecent === "undefined" || mostRecent === null) && (typeof nextUp === "undefined" || nextUp === null)) {
        mostRecent = k;
        nextUp = k;
      }
      if (v < today && (v > cloned_data[mostRecent] || cloned_data[mostRecent] > today)) {
        mostRecent = k;
      }
      if (v > today && (v < cloned_data[nextUp] || cloned_data[nextUp] < today)) {
        nextUp = k;
      }
    }
    dateMostRecent = new Date(cloned_data[mostRecent]);
    dateNextUp = new Date(cloned_data[nextUp]);
    return {
      mostRecent: {
        id: mostRecent,
        date: dateMostRecent
      },
      nextUp: {
        id: nextUp,
        date: dateNextUp
      }
    };
  };

  __loadSubclubScheduleFromUrl = function(url) {
    return $.ajax({
      url: url
    }).then(function(resp) {
      return JSON.parse(resp);
    }).then(function(data) {
      return [data, APP.loadSubclubSchedule(data)];
    });
  };

  APP.renderSubclubSchedule = function($el, data) {
    var $lesson_last, $lesson_next, scheduleData;
    scheduleData = {};
    if (JSON.stringify(data)[0] === '{') {
      scheduleData = APP.loadSubclubSchedule(data);
    } else {
      __loadSubclubScheduleFromUrl(data).then(function(d) {
        return data = d[0], scheduleData = d[1], d;
      }).then(null, function(err) {
        return console.log("Couldn't load or parse schedule data at " + data);
      });
    }
    $lesson_last = $el.find('.lesson-last');
    $lesson_next = $el.find('.lesson-next');
    $lesson_last.each(function() {
      var _this, lesson;
      _this = $(this);
      lesson = data[scheduleData.mostRecent.id];
      if (_this.prop('tagName' === 'A')) {
        _this.attr('href', lesson.url);
        _this.attr('title', lesson.date);
        return _this.html(lesson.title);
      } else {
        return _this.html("<a href='" + lesson.url + "' title='" + lesson.date + "'>" + lesson.title + "</a>");
      }
    });
    $lesson_next.each(function() {
      var _this, lesson;
      _this = $(this);
      lesson = data[scheduleData.nextUp.id];
      if (_this.prop('tagName' === 'A')) {
        _this.attr('href', lesson.url);
        _this.attr('title', lesson.title);
        return _this.html(lesson.date);
      } else {
        return _this.html("<a href='" + lesson.url + "' title='" + lesson.title + "'>" + lesson.date + "</a>");
      }
    });
    return true;
  };

  APP.onload = function() {
    return console.log("Testing Coffeescript");
  };

  window.APP = APP;

  window.UTILS = UTILS;

  $(APP.onload);

}).call(this);
