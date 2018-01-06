---
---

# Easter egg

module.exports = () ->
  __easterEgg = () ->
    if 'false' == Cookies.get CONSTS.easterEgg
      $('body').addClass 'easter-egg'
      Cookies.set CONSTS.easterEgg, 'true'
    else
      $('body').removeClass 'easter-egg'
      Cookies.set CONSTS.easterEgg, 'false'
  __easterEggTrigger = () ->
    map = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]
    ind = 0
    to = null

    (e) ->
      return if e.altKey or e.ctrlKey or e.metaKey or e.shiftKey

      if map[ind] == e.keyCode
        ind++
      else
        return ind = 0

      if ind == map.length
        ind = 0
        clearTimeout to
        return __easterEgg()

      to = window.setTimeout () ->
        ind = 0
      , 1500
  if 'true' == Cookies.get CONSTS.easterEgg
    $('body').addClass 'easter-egg'
  $(window).on 'keydown', __easterEggTrigger()
