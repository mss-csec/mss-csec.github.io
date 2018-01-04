---
---

# Footnotes

module.exports = () ->
  # Change title attr to footnote content
  # $('a.footnote').each () ->
  #   content = $($(this).attr('href')).text().trim()
  #   $(this).attr 'title', content
  #   $(this).parent().attr 'title', content

  #   content = content.replace /^\d+\.\s+/, ''

  # Reveal footnote tip on click
  $('a.footnote, .footnote-ref a').on 'click', (e) ->
    e.preventDefault()

    $ftnote = $('.footnote-tip')
    $ftnotesrc = $($(this).attr('href'))

    content = $ftnotesrc.html()
      .trim()
      .replace /^<p>([\s\S]+) <a[^>]+>.<\/a><\/p>/, '$1' # Markdown-style
      .replace /^<a.+?>\d+<\/a>\.\s+/, ''                # AsciiDoc-style
      .replace /^[a-z]/, (c) -> c.toUpperCase()

    if $ftnote.html() == content and $ftnote[0].offsetParent?
      $ftnote.hide()
      $ftnotesrc.removeClass 'targeted'
    else
      # Only show tooltip when actual footnote is not visible in viewport
      unless window.pageYOffset + window.innerHeight >
        $ftnotesrc.offset().top + $ftnotesrc.outerHeight() and
      window.pageYOffset < $ftnotesrc.offset().top
        # Fill in content and display
        $ftnote.show()
          .html content

        # Now that we have the tooltip's dimensions, determine positioning
        offset = $(this).offset()
        top = offset.top - $ftnote.outerHeight() - 5
        left = offset.left - ($ftnote.outerWidth() - $(this).width()) / 2

        # Clamp values so that tooltips don't overflow screen horizontally
        if left + $ftnote.outerWidth() > window.innerWidth
          left = window.innerWidth - $ftnote.outerWidth() - 5
        else if left < $(this).closest('p').offset().left
          left = $(this).closest('p').offset().left

        # Position tooltip
        $ftnote.css
          top: UTILS.numToPx top
          left: UTILS.numToPx left

        # Scroll if tooltip is outside viewport
        if $ftnote.offset().top <
            window.pageYOffset + $('.site-header').outerHeight()
          window.scroll 0, $ftnote.offset().top -
            $('.site-header').outerHeight() - 5

      $ftnotesrc.addClass 'targeted'

  # Hide footnote on blur
  $('a.footnote, .footnote-ref a').on 'blur', (e) ->
    $this = $(this)
    # https://stackoverflow.com/a/11544685/3472393
    setTimeout () ->
      unless document.activeElement != document.body and
      $(document.activeElement).closest('.footnote-tip').length
        $('.footnote-tip').hide()
        $($this.attr('href')).removeClass 'targeted'
      else
        $this.trigger 'focus'
    , 1
