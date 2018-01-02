(function() {
  var $target, scrollToSection, sectionObserver, tocObserver;

  scrollToSection = function($section) {
    window.location.hash = '#' + $section.attr('id');
    return $('html, body').scrollTop($section.offset().top - $('#toc').outerHeight() - .5 * CONSTS.ex);
  };

  $('.make-distraction-free').on('click', function(e) {
    e.preventDefault();
    return $('body').toggleClass('distraction-free');
  });

  $(window).on('keypress', function(e) {
    if (e.keyCode === 27) {
      return $('body').removeClass('distraction-free');
    }
  });

  $('#toc a').on('click', function(e) {
    e.preventDefault();
    return scrollToSection($($(this).attr('href')));
  });

  if (window.location.hash) {
    $target = $(window.location.hash);
    if ($target.length) {
      scrollToSection($target);
    }
  }

  if (window.IntersectionObserver && window.innerWidth >= CONSTS.bpTablet && !$('body').hasClass('landing')) {
    sectionObserver = new IntersectionObserver(function(entries, observer) {
      var entry, heading, i, len, ratio, results, target;
      results = [];
      for (i = 0, len = entries.length; i < len; i++) {
        entry = entries[i];
        ratio = entry.intersectionRatio;
        target = entry.target;
        heading = target.querySelector('h2[id]');
        if (ratio) {
          results.push($("#toc [href='#" + heading.id + "']").addClass('in-view'));
        } else {
          results.push($("#toc [href='#" + heading.id + "']").removeClass('in-view'));
        }
      }
      return results;
    }, {
      threshold: [0, 1]
    });
    $('.sect1').each(function(_, section) {
      return sectionObserver.observe(section);
    });
    tocObserver = new IntersectionObserver(function(entries, observer) {
      var entry, offset, toc;
      entry = entries[0];
      toc = $('#toc');
      offset = $('.content.container').offset().left;
      if ($('#main-content').is(':first-child')) {
        offset = $('#main-content').offset().left;
      }
      if (entry.intersectionRatio) {
        return toc.addClass('invisible');
      } else {
        toc.removeClass('invisible');
        toc.css({
          paddingLeft: offset,
          paddingRight: offset
        });
        return $('.sidebar-collapsible').css({
          top: toc.outerHeight() + CONSTS.ex
        });
      }
    }, {
      threshold: [0]
    });
    $('#toc').addClass('toc-fixed invisible').append("<a href='#' onclick='event.preventDefault();window.scroll(0,0)'>Scroll to top</a>");
    $('#toctitle').text($('.page-title')[0].firstChild.textContent);
    $('.sidebar-collapsible').css({
      paddingTop: 0,
      top: $('#toc').outerHeight() + CONSTS.ex
    });
    tocObserver.observe($('.page-header')[0]);
  }

}).call(this);
