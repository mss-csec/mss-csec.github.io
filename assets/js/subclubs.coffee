---
---

# Scroll to section
scrollToSection = ($section) ->
  window.location.hash = '#' + $section.attr 'id'
  $('html, body').scrollTop $section.offset().top - $('#toc').outerHeight()

# Distraction-free
$('.make-distraction-free').on 'click', (e) ->
  e.preventDefault()
  $('body').toggleClass 'distraction-free'

# Jumping through sections
$('#toc a').on 'click', (e) ->
  e.preventDefault()

  scrollToSection $($(this).attr('href'))

# Same --- scroll to section on page load
if window.location.hash
  $target = $(window.location.hash)

  scrollToSection $target if $target.length

# IntersectionObserver
if window.IntersectionObserver
  tocObserver = new IntersectionObserver (entries, observer) ->
    for entry in entries
      ratio = entry.intersectionRatio
      target = entry.target
      heading = target.querySelector 'h2[id]'

      if ratio
        $("#toc [href='##{heading.id}']").addClass 'in-view'
      else
        $("#toc [href='##{heading.id}']").removeClass 'in-view'

  , threshold: [0, 1]

  $('.sect1').each (_, section) -> tocObserver.observe section
