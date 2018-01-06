---
---

# Basically imports let's face it
require('./components/sidebar')(APP)
require('./components/footnotes')()
require('./components/toc')()

# Scroll to section
scrollToSection = ($section) ->
  window.location.hash = '#' + $section.attr 'id'
  window.scroll 0,
    $section.offset().top - $('#toc').outerHeight() - .5 * CONSTS.ex

# Distraction-free mode
$('.make-distraction-free').on 'click', (e) ->
  e.preventDefault()

  $('body').toggleClass 'distraction-free'

  $(window).one 'keypress', (e) ->
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
