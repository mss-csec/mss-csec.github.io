---
---

# TOC

module.exports = () ->
  # Scroll area observers
  if window.IntersectionObserver and
  window.innerWidth >= CONSTS.bpTablet and
  !$('body').hasClass('landing') and
  !$('body').hasClass('post') and
  $('#toc').length
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

    $('.sect1').each (section) -> sectionObserver.observe section

    # Observer for fixed TOC
    tocObserver = new IntersectionObserver (entries, observer) ->
      # We'll only ever have one entry: the header
      entry = entries[0]
      toc = $('#toc')
      offset = $('.content.container').offset().left

      if $('#main-content').is(':first-child')
        offset = $('#main-content').offset().left

      if entry.intersectionRatio
        toc.addClass 'invisible'
      else
        toc.removeClass 'invisible'
        toc.css
          paddingLeft: UTILS.numToPx offset
          paddingRight: UTILS.numToPx offset
        $('.sidebar-collapsible').css
          top: UTILS.numToPx toc.outerHeight() + CONSTS.ex
          height: UTILS.numToPx window.innerHeight - $('#toc').outerHeight() - 2 * CONSTS.ex

    , threshold: [0]

    $('#toc')
      .addClass 'toc-fixed'
      .addClass 'invisible'
      .append "<a href='#'
        onclick='event.preventDefault();window.scroll(0,0)'
      >Scroll to top</a>"

    # The RHS is like this as we need to get the contents of a text node
    # This is something that cannot be done with Cash/jQ
    $('#toctitle').text $('.page-title')[0].firstChild.textContent

    tocObserver.observe $('.page-header')[0]

    $('.sidebar-collapsible').css
      paddingTop: UTILS.numToPx 0
      top: UTILS.numToPx $('#toc').outerHeight() + CONSTS.ex
      height: UTILS.numToPx window.innerHeight - $('#toc').outerHeight() - 2 * CONSTS.ex
