---
---

module.exports = () ->
  sticky = $('.announcement-sticky')

  if sticky.length and
    (Cookies.get("#{CONSTS.cookieStickyPrefix}#{sticky.attr 'data-id'}") == '1' or
      (new Date()).getTime() > (new Date sticky.attr 'data-displayUntil').getTime())
    sticky.remove()

  sticky.on 'click', 'a', (e) ->
    $sticky = $(this).closest '.announcement-sticky'

    e.preventDefault()

    $sticky.remove()

    Cookies.set "#{CONSTS.cookieStickyPrefix}#{$sticky.attr 'data-id'}", '1'

    if $(this).attr('href') != '#'
      window.location = $(this).attr 'href'
