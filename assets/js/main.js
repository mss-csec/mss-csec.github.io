
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

  APP.SUBCLUB_END_HOUR = 17;

  APP.loadSubclubSchedule = function(data) {
    var clonedData, dateMostRecent, dateNextUp, k, mostRecent, nextUp, ref, today, v;
    clonedData = $.extend(true, {}, data);
    today = (new Date()).getTime();
    for (k in clonedData) {
      v = clonedData[k];
      v = (new Date((ref = v.date) != null ? ref : v)).setHours(APP.SUBCLUB_END_HOUR);
      clonedData[k] = v;
      if ((typeof mostRecent === "undefined" || mostRecent === null) && (typeof nextUp === "undefined" || nextUp === null)) {
        mostRecent = k;
        nextUp = k;
      }
      if (v < today && (v > clonedData[mostRecent] || clonedData[mostRecent] > today)) {
        mostRecent = k;
      }
      if (v > today && (v < clonedData[nextUp] || clonedData[nextUp] < today)) {
        nextUp = k;
      }
    }
    if (clonedData[mostRecent] < today) {
      dateMostRecent = new Date(clonedData[mostRecent]);
    }
    if (clonedData[nextUp] >= today) {
      dateNextUp = new Date(clonedData[nextUp]);
    }
    return {
      mostRecent: {
        id: dateMostRecent != null ? mostRecent : null,
        date: dateMostRecent
      },
      nextUp: {
        id: dateNextUp != null ? nextUp : null,
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
    if (scheduleData.mostRecent.id !== null) {
      $lesson_last.each(function() {
        var _this, lesson;
        _this = $(this);
        lesson = data[scheduleData.mostRecent.id];
        if (_this.prop('tagName' === 'A')) {
          _this.addClass('lesson-link');
          _this.attr('href', lesson.url);
          _this.attr('title', lesson.date);
          return _this.html(lesson.title);
        } else {
          return _this.html("<a href='" + lesson.url + "' class='lesson-link' title='" + lesson.date + "'>" + lesson.title + "</a>");
        }
      });
    } else {
      $lesson_last.each(function() {
        var _this;
        _this = $(this);
        if (_this.prop('tagName' === 'A')) {
          _this.addClass('lesson-link', 'disabled');
          return _this.html("null");
        } else {
          return _this.html("<a class='lesson-link disabled'>null</a>");
        }
      });
    }
    if (scheduleData.nextUp.id !== null) {
      $lesson_next.each(function() {
        var _this, lesson;
        _this = $(this);
        lesson = data[scheduleData.nextUp.id];
        if (_this.prop('tagName' === 'A')) {
          _this.addClass('lesson-link');
          _this.attr('href', lesson.url);
          _this.attr('title', lesson.title);
          return _this.html(lesson.date);
        } else {
          return _this.html("<a href='" + lesson.url + "' class='lesson-link' title='" + lesson.title + "'>" + lesson.date + "</a>");
        }
      });
    } else {
      $lesson_next.each(function() {
        var _this;
        _this = $(this);
        if (_this.prop('tagName' === 'A')) {
          _this.addClass('lesson-link', 'disabled');
          return _this.html("null");
        } else {
          return _this.html("<a class='lesson-link disabled'>null</a>");
        }
      });
    }
    return true;
  };

  APP.onload = function() {
    return console.log("Testing Coffeescript");
  };

  window.APP = APP;

  window.UTILS = UTILS;

  $(APP.onload);

}).call(this);
