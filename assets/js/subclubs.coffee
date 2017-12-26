---
---

# Scroll to section
scrollToSection = ($section) ->
  window.location.hash = '#' + $section.attr 'id'
  $('html, body').scrollTop $section.offset().top - $('#toc').outerHeight() - .5 * CONSTS.ex

# Distraction-free mode
$('.make-distraction-free').on 'click', (e) ->
  e.preventDefault()

  $('body').toggleClass 'distraction-free'

$(window).on 'keypress', (e) ->
  if e.keyCode == 27 # escape
    $('body').removeClass 'distraction-free'

# Automatically adjust scroll pos when jumping through sections
$('#toc a').on 'click', (e) ->
  e.preventDefault()

  scrollToSection $($(this).attr('href'))

# Same --- scroll to section on page load
if window.location.hash
  $target = $(window.location.hash)

  scrollToSection $target if $target.length

# Scroll area observers
if window.IntersectionObserver and
window.innerWidth >= CONSTS.bpTablet and
!$('body').hasClass 'landing'
  # Observer for sections in the TOC
  sectionObserver = new IntersectionObserver (entries, observer) ->
    for entry in entries
      ratio = entry.intersectionRatio
      target = entry.target
      heading = target.querySelector 'h2[id]'

      if ratio
        $("#toc [href='##{heading.id}']").addClass 'in-view'
      else
        $("#toc [href='##{heading.id}']").removeClass 'in-view'

  , threshold: [0, 1]

  $('.sect1').each (_, section) -> sectionObserver.observe section

  # Observer for fixed TOC
  tocObserver = new IntersectionObserver (entries, observer) ->
    # We'll only ever have one entry: the header
    entry = entries[0]
    toc = $('#toc')
    offset = $('.content.container').offset().left

    if entry.intersectionRatio
      toc.addClass 'invisible'
    else
      toc.removeClass 'invisible'
      toc.css
        paddingLeft: offset
        paddingRight: offset
      $('#lesson-listing').css { top: toc.outerHeight() + CONSTS.ex }

  , threshold: [0]

  $('#toc')
    .addClass 'toc-fixed invisible'
    .append "<a href='#' onclick='event.preventDefault();window.scroll(0,0)'>Scroll to top</a>"
  $('#toctitle').text $('.page-title')[0].firstChild.textContent
  $('#lesson-listing').css
    paddingTop: 0
    top: $('#toc').outerHeight() + CONSTS.ex
  tocObserver.observe $('.page-header')[0]
