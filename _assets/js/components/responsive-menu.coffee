---
---

module.exports = () ->
  $('.responsive-menu-toggler').on 'click', (e) ->
    e.preventDefault()

    $('body').toggleClass 'responsive-menu-open'
