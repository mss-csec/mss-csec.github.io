
/*
Main coffeescript file
 */

(function() {
  var APP, CONSTS, UTILS, __collapseSidebar, __dispatchCustomEvent, __loadSubclubScheduleFromUrl, __openSidebar;

  APP = {};

  UTILS = {};

  CONSTS = {
    ex: 20,
    bpMobile: 400,
    bpPhablet: 550,
    bpTablet: 768,
    bpDesktop: 1024,
    bpDesktopHd: 1440,
    animDuration: 230,
    cookieCollapseSidebar: 'collapseSidebar',
    cookieStickyPrefix: 'sticky-',
    cookieTheme: 'theme',
    easterEgg: 'pascha'
  };

  Object.freeze(CONSTS);

  UTILS.intSort = function(a, b) {
    return a - b;
  };

  UTILS.reverseIntSort = function(a, b) {
    return b - a;
  };

  UTILS.spaceship = function(a, b) {
    var ref, ref1;
    return (ref = a < b) != null ? ref : -{
      1: (ref1 = a > b) != null ? ref1 : {
        1: 0
      }
    };
  };

  UTILS.setIndefiniteCookie = function(key, value) {
    return Cookies.set(key, value, {
      expires: 365
    });
  };

  UTILS.fuzzyTruncate = function(text, length, clipper) {
    var lastDelim;
    if (length == null) {
      length = 250;
    }
    if (clipper == null) {
      clipper = '...';
    }
    if (text.length <= length) {
      return text;
    }
    lastDelim = text.lastIndexOf(" ", length);
    return text.slice(0, lastDelim > -1 ? lastDelim : 2e308) + clipper;
  };

  APP.SUBCLUB_END_HOUR = 17;

  APP.loadSubclubSchedule = function(sched) {
    var clonedSched, data, dateMostRecent, dateNextUp, id, mostRecent, nextUp, ref, today;
    clonedSched = $.extend(true, {}, sched);
    today = (new Date()).getTime();
    for (id in clonedSched) {
      data = clonedSched[id];
      data = {
        t: (new Date((ref = data.date) != null ? ref : data)).setHours(APP.SUBCLUB_END_HOUR),
        l: parseInt(data.lesson)
      };
      clonedSched[id] = data;
      if ((typeof mostRecent === "undefined" || mostRecent === null) && (typeof nextUp === "undefined" || nextUp === null)) {
        mostRecent = id;
        nextUp = id;
      }
      if (data.t <= today && (data.t >= clonedSched[mostRecent].t || clonedSched[mostRecent].t > today)) {
        if (data.t === clonedSched[mostRecent].t && data.l < clonedSched[mostRecent].l) {
          continue;
        }
        mostRecent = id;
      }
      if (data.t > today && (data.t <= clonedSched[nextUp].t || clonedSched[nextUp].t < today)) {
        if (data.t === clonedSched[nextUp].t && data.l > clonedSched[nextUp].l) {
          continue;
        }
        nextUp = id;
      }
    }
    if (clonedSched[mostRecent].t < today) {
      dateMostRecent = new Date(clonedSched[mostRecent].t);
    }
    if (clonedSched[nextUp].t >= today) {
      dateNextUp = new Date(clonedSched[nextUp].t);
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
    var $lessonLast, $lessonNext, mostRecentBalloonPos, nextUpBalloonPos, scheduleData;
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
    $lessonLast = $el.find('.lesson-last');
    $lessonNext = $el.find('.lesson-next');
    mostRecentBalloonPos = $el.data('lesson-last-balloon-pos') || 'right';
    nextUpBalloonPos = $el.data('lesson-next-balloon-pos') || 'left';
    if (scheduleData.mostRecent.id !== null) {
      $lessonLast.each(function() {
        var _this, lesson;
        _this = $(this);
        lesson = data[scheduleData.mostRecent.id];
        lesson.title = lesson.title.replace(/^.*?@/, '');
        if (_this.prop('tagName' === 'A')) {
          return _this.addClass('lesson-link').attr('href', lesson.url).attr('data-balloon', lesson.title).attr('data-balloon-pos', mostRecentBalloonPos).attr('data-ballon-bluntish', true).html(lesson.title);
        } else {
          return _this.html("<a href='" + lesson.url + "' class='lesson-link' data-balloon='" + lesson.date + "' data-balloon-pos='" + mostRecentBalloonPos + "' data-balloon-bluntish> " + lesson.title + "</a>");
        }
      });
    } else {
      $lessonLast.each(function() {
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
      $lessonNext.each(function() {
        var _this, lesson;
        _this = $(this);
        lesson = data[scheduleData.nextUp.id];
        lesson.title = lesson.title.replace(/^.*?@/, '');
        if (_this.prop('tagName' === 'A')) {
          return _this.addClass('lesson-link').attr('href', lesson.url).attr('data-balloon', lesson.title).attr('data-balloon-pos', nextUpBalloonPos).attr('data-ballon-bluntish', true).html(lesson.date);
        } else {
          return _this.html("<a href='" + lesson.url + "' class='lesson-link' data-balloon='" + lesson.title + "' data-balloon-pos='" + nextUpBalloonPos + "' data-balloon-bluntish> " + lesson.date + "</a>");
        }
      });
    } else {
      $lessonNext.each(function() {
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

  __openSidebar = function($sidebar) {
    $sidebar.removeClass('closed');
    $sidebar.find('.collapse-el').removeClass('closed').attr('title', 'Collapse sidebar').html('&laquo;');
    return UTILS.setIndefiniteCookie(CONSTS.cookieCollapseSidebar, '0');
  };

  __collapseSidebar = function($sidebar) {
    $sidebar.addClass('closed');
    $sidebar.find('.collapse-el').addClass('closed').attr('title', 'Open sidebar').html('&raquo;');
    return UTILS.setIndefiniteCookie(CONSTS.cookieCollapseSidebar, '1');
  };

  APP.toggleSidebar = function(e) {
    var $sidebar, $target, isClosed;
    e.preventDefault();
    $target = $(e.target);
    $sidebar = $target.closest('.sidebar-collapsible');
    isClosed = $target.hasClass('closed');
    if (isClosed) {
      __openSidebar($sidebar);
    } else {
      __collapseSidebar($sidebar);
    }
    return true;
  };

  APP.currentTheme = 'light';

  __dispatchCustomEvent = function(obj, name, detail) {
    var event;
    if (detail == null) {
      detail = null;
    }
    if (typeof CustomEvent.constructor.name !== 'undefined') {
      return obj.dispatchEvent(new CustomEvent(name, {
        detail: detail
      }));
    } else {
      event = document.createEvent('CustomEvent');
      event.initCustomEvent(name, false, false, detail);
      return obj.dispatchEvent(event);
    }
  };

  APP.changeTheme = function(theme) {
    var $t;
    $t = $('.toggled-theme');
    $t.each(function() {
      var $e, altKey, altProp, newKey, newVal, oldVal;
      $e = $(this);
      altProp = $e.attr('data-alt-prop');
      altKey = theme === 'dark' ? 'data-alt-dark' : 'data-alt-light';
      newKey = theme === 'dark' ? 'data-alt-light' : 'data-alt-dark';
      oldVal = $e.attr(altProp);
      newVal = $e.attr(altKey);
      $e.attr(altProp, newVal);
      return $e.attr(newKey, oldVal);
    });
    if (theme === 'dark') {
      $('body').removeClass('theme-light');
      $('body').addClass('theme-dark');
      APP.currentTheme = 'dark';
      $('.toggle-theme').attr('title', 'Use light theme');
    } else {
      $('body').removeClass('theme-dark');
      $('body').addClass('theme-light');
      APP.currentTheme = 'light';
      $('.toggle-theme').attr('title', 'Use dark theme');
    }
    return __dispatchCustomEvent(window, 'changetheme');
  };

  APP.revealEmail = function() {
    var email;
    email = [[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],(![]+[])[+!+[]],(!![]+[])[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],([![]]+[][[]])[+!+[]+[+[]]],(![]+[])[!+[]+!+[]],(![]+[])[!+[]+!+[]],(!![]+[])[!+[]+!+[]+!+[]],(+(+!+[]+[+!+[]]+(!![]+[])[!+[]+!+[]+!+[]]+[!+[]+!+[]]+[+[]])+[])[+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[!+[]+!+[]],(![]+[])[!+[]+!+[]+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],([![]]+[][[]])[+!+[]+[+[]]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],(![]+[])[+!+[]],([![]]+[][[]])[+!+[]+[+[]]],(![]+[])[!+[]+!+[]],(+(+!+[]+[+!+[]]+(!![]+[])[!+[]+!+[]+!+[]]+[!+[]+!+[]]+[+[]])+[])[+!+[]],[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]],[+!+[]]+[+!+[]]+[+!+[]],[+!+[]]+[+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]+!+[]]].map(function(a){return a|0?String[atob('ZnJvbUNoYXJDb2Rl')](a):a}).join('');
    return alert(email);
  };

  APP.onload = function() {
    var __DOMRemoveSticky, __easterEgg, __easterEggTrigger, __katexFail, __renderKatex, __useMathJax;
    console.log("Loaded on " + ((new Date()).toLocaleString()));
    if ('dark' === Cookies.get(CONSTS.cookieTheme)) {
      APP.changeTheme('dark');
    }
    __easterEgg = function() {
      $('body').toggleClass('easter-egg');
      if ('false' === Cookies.get(CONSTS.easterEgg)) {
        return Cookies.set(CONSTS.easterEgg, 'true');
      } else {
        return Cookies.set(CONSTS.easterEgg, 'false');
      }
    };
    __easterEggTrigger = function() {
      var ind, map, to;
      map = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
      ind = 0;
      to = null;
      return function(e) {
        clearTimeout(to);
        if (e.altKey || e.ctrlKey || e.metaKey || e.shiftKey) {
          return;
        }
        if (map[ind] === e.keyCode) {
          ind++;
        } else {
          return ind = 0;
        }
        if (ind === map.length) {
          ind = 0;
          return __easterEgg();
        }
        return to = setTimeout(function() {
          return ind = 0;
        }, 200);
      };
    };
    if ('true' === Cookies.get(CONSTS.easterEgg)) {
      $('body').addClass('easter-egg');
    }
    $(window).on('keydown', __easterEggTrigger());
    $('.toggle-theme').on('click', function(e) {
      var theme;
      theme = Cookies.get(CONSTS.cookieTheme);
      e.preventDefault();
      if (theme === 'dark') {
        Cookies.set(CONSTS.cookieTheme, 'light');
        return APP.changeTheme('light');
      } else {
        Cookies.set(CONSTS.cookieTheme, 'dark');
        return APP.changeTheme('dark');
      }
    });
    $('.announcement-sticky').on('click', 'a', function(e) {
      var $sticky;
      $sticky = $(this).closest('.announcement-sticky');
      e.preventDefault();
      $sticky.remove();
      Cookies.set("" + CONSTS.cookieStickyPrefix + ($sticky.data('id')), '1');
      if ($(this).attr('href') !== '#') {
        return window.location = $(this).attr('href');
      }
    });
    if (!$('body').hasClass('no-hero') && !$('body').hasClass('landing') && !$('body').hasClass('lesson') && !$('body').hasClass('post') && !$('body').hasClass('resource') && window.innerWidth > CONSTS.bpTablet) {
      $(window).on('scroll', function(e) {
        if (window.scrollY > 100) {
          return $('body .site-header').removeClass('at-top');
        } else {
          return $('body .site-header').addClass('at-top');
        }
      });
      $('body .site-header').addClass('at-top');
    }
    __DOMRemoveSticky = function() {
      var sticky;
      sticky = $('.announcement-sticky');
      if (Cookies.get("" + CONSTS.cookieStickyPrefix + (sticky.data('id'))) === '1' || (sticky.length && (new Date()).getTime() > (new Date(sticky.data('displayUntil'))).getTime())) {
        return sticky.remove();
      }
    };
    __DOMRemoveSticky();
    $('.collapse-el').html('&laquo;');
    $('.collapse-el.closed').html('&raquo;');
    if ('1' === Cookies.get(CONSTS.cookieCollapseSidebar)) {
      __collapseSidebar($('.sidebar-collapsible'));
    }
    $('a.footnote, .footnote-ref a').on('click', function(e) {
      var $ftnote, $ftnotesrc, content, left, offset, top;
      e.preventDefault();
      $ftnote = $('.footnote-tip');
      $ftnotesrc = $($(this).attr('href'));
      content = $ftnotesrc.html().trim().replace(/^<p>([\s\S]+) <a[^>]+>.<\/a><\/p>/, '$1').replace(/^<a.+?>\d+<\/a>\.\s+/, '').replace(/^[a-z]/, function(c) {
        return c.toUpperCase();
      });
      if ($ftnote.html() === content && $ftnote.is(':visible')) {
        $ftnote.hide();
        return $ftnotesrc.removeClass('targeted');
      } else {
        if (!($(window).scrollTop() + $(window).height() > $ftnotesrc.offset().top + $ftnotesrc.outerHeight() && $(window).scrollTop() < $ftnotesrc.offset().top)) {
          $ftnote.html(content).show();
          offset = $(this).offset();
          top = offset.top - $ftnote.outerHeight() - 5;
          left = offset.left - ($ftnote.outerWidth() - $(this).width()) / 2;
          if (left + $ftnote.outerWidth() > $(window).width()) {
            left = $(window).width() - $ftnote.outerWidth() - 5;
          } else if (left < $(this).closest('p').offset().left) {
            left = $(this).closest('p').offset().left;
          }
          $ftnote.css({
            top: top,
            left: left
          });
          if ($ftnote.offset().top < $(window).scrollTop() + $('.site-header').outerHeight()) {
            $('html, body').scrollTop($ftnote.offset().top - $('.site-header').outerHeight() - 5);
          }
        }
        return $ftnotesrc.addClass('targeted');
      }
    });
    $('a.footnote, .footnote-ref a').on('blur', function(e) {
      var $this;
      $this = $(this);
      return setTimeout(function() {
        if (!$(document.activeElement).closest('.footnote-tip').length) {
          $('.footnote-tip').hide();
          return $($this.attr('href')).removeClass('targeted');
        } else {
          return $this.focus();
        }
      }, 1);
    });
    $('body').removeClass('no-js');
    __katexFail = false;
    __renderKatex = function(isDisplay) {
      return function() {
        try {
          return katex.renderToString($(this).text().replace(/%.*/g, ''), {
            throwOnError: true,
            displayMode: isDisplay
          });
        } catch (error) {
          __katexFail = true;
          return $(this);
        }
      };
    };
    __useMathJax = function() {
      var mjSRI, mjSrc, script;
      mjSrc = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js';
      mjSRI = 'sha384-Ra6zh6uYMmH5ydwCqqMoykyf1T/+ZcnOQfFPhDrp2kI4OIxadnhsvvA2vv9A7xYv';
      script = document.createElement('script');
      script.src = mjSrc;
      script.integrity = mjSRI;
      script.crossOrigin = 'anonymous';
      return document.querySelector('head').appendChild(script);
    };
    $('script[type="math/tex"]').replaceWith(__renderKatex(false));
    $('script[type="math/tex; mode=display"]').replaceWith(__renderKatex(true));
    window.renderMathInElement(document.body, {
      delimiters: [
        {
          left: "\\[",
          right: "\\]",
          display: true
        }, {
          left: "\\(",
          right: "\\)",
          display: false
        }
      ],
      throwOnError: true,
      errorCallback: function() {
        console.log('KaTeX rendering failed! Loading MathJax');
        return __useMathJax();
      }
    });
    if (__katexFail) {
      console.log('KaTeX rendering failed! Loading MathJax');
      __useMathJax();
    }
    anchors.options = {
      visible: 'touch',
      icon: '§'
    };
    anchors.add('#main-content h2, #main-content h3');
    return SCRIPTS.run();
  };

  window.CONSTS = CONSTS;

  window.APP = APP;

  window.UTILS = UTILS;

  $(APP.onload);

}).call(this);
