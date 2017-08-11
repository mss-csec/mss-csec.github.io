
/*
Main coffeescript file
 */

(function() {
  var APP, CONSTS, UTILS, __collapseSidebar, __loadSubclubScheduleFromUrl, __openSidebar;

  APP = {};

  UTILS = {};

  CONSTS = {
    cookieCollapseSidebar: 'collapseSidebar',
    cookieTheme: 'theme'
  };

  UTILS.intSort = function(a, b) {
    return a - b;
  };

  UTILS.reverseIntSort = function(a, b) {
    return b - a;
  };

  UTILS.setIndefiniteCookie = function(key, value) {
    return Cookies.set(key, value, {
      expires: 365
    });
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

  __openSidebar = function($sidebar, $target) {
    $sidebar.removeClass('closed');
    $target.removeClass('closed').attr('title', 'Collapse sidebar').html('&laquo;');
    return UTILS.setIndefiniteCookie(CONSTS.cookieCollapseSidebar, '0');
  };

  __collapseSidebar = function($sidebar, $target) {
    $sidebar.addClass('closed');
    $target.addClass('closed').attr('title', 'Open sidebar').html('&raquo;');
    return UTILS.setIndefiniteCookie(CONSTS.cookieCollapseSidebar, '1');
  };

  APP.toggleSidebar = function(e) {
    var $mainContent, $sidebar, $target, isClosed;
    e.preventDefault();
    $target = $(e.target);
    $sidebar = $target.closest('.sidebar-collapsible');
    $mainContent = $('#main-content');
    isClosed = $target.hasClass('closed');
    if (isClosed) {
      __openSidebar($sidebar, $target);
      $mainContent.removeClass('twelve').addClass('nine');
    } else {
      __collapseSidebar($sidebar, $target);
      $mainContent.removeClass('nine').addClass('twelve');
    }
    return true;
  };

  APP.changeTheme = function(theme) {
    var $t;
    if (theme == null) {
      theme = Cookies.get(CONSTS.cookieTheme);
    }
    $t = $('.toggled-theme');
    return $t.each(function() {
      var $e, altKey, altProp, newKey, newVal, oldVal;
      $e = $(this);
      altProp = $e.attr('data-alt-prop');
      altKey = theme === 'dark' ? 'data-alt-dark' : 'data-alt-light';
      newKey = theme === 'dark' ? 'data-alt-light' : 'data-alt-dark';
      oldVal = $e.attr(altProp);
      newVal = $e.attr(altKey);
      $e.attr(altProp, newVal);
      $e.attr(newKey, oldVal);
      if (theme === 'dark') {
        return $('body').addClass('theme-dark');
      } else {
        return $('body').removeClass('theme-dark');
      }
    });
  };

  APP.toggleDarkTheme = function() {
    var theme;
    theme = Cookies.get(CONSTS.cookieTheme);
    if (theme === 'dark') {
      Cookies.set(CONSTS.cookieTheme, 'light');
      return APP.changeTheme('light');
    } else {
      Cookies.set(CONSTS.cookieTheme, 'dark');
      return APP.changeTheme('dark');
    }
  };

  APP.onload = function() {
    var $sidebar, $target;
    console.log("Testing Coffeescript");
    if ('dark' === Cookies.get(CONSTS.cookieTheme)) {
      APP.changeTheme();
      $('#toggle-dark-theme').prop('checked', true);
    }
    $('body').prop('hidden', false);
    $('.collapse-el').html('&laquo;');
    $('.collapse-el.closed').html('&raquo;');
    if ('1' === Cookies.get(CONSTS.cookieCollapseSidebar)) {
      $sidebar = $('.sidebar-collapsible');
      $target = $sidebar.find('.collapse-el');
      __collapseSidebar($sidebar, $target);
    }
    return $('#toggle-dark-theme').bind('change', APP.toggleDarkTheme);
  };

  window.APP = APP;

  window.UTILS = UTILS;

  $(APP.onload);

}).call(this);
