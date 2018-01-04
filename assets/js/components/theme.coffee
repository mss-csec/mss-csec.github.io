---
---

# Theming

module.exports = (APP) ->
  # Cross-browser way to dispatch a custom event
  __dispatchCustomEvent = (obj, name, detail = null) ->
    if typeof CustomEvent.constructor.name != 'undefined'
      obj.dispatchEvent new CustomEvent(name, { detail })
    else
      event = document.createEvent 'CustomEvent'
      event.initCustomEvent name, false, false, detail
      obj.dispatchEvent event

  # Changes the sitewide theme
  #
  # theme: A string, either 'light' or 'dark', corresponding to the desired theme
  APP.changeTheme = (theme) ->
    $('.toggled-theme').each (e, i) ->
      e.href = window.STYLESHEETS[theme][i]

    if theme == 'dark'
      $('body').removeClass 'theme-light'
      $('body').addClass 'theme-dark'
      $('.toggle-theme').attr 'title', 'Use light theme'

      APP.currentTheme = 'dark'
      document.documentElement.style.backgroundColor = '#1a1f2a'
    else
      $('body').removeClass 'theme-dark'
      $('body').addClass 'theme-light'
      $('.toggle-theme').attr 'title', 'Use dark theme'

      APP.currentTheme = 'light'
      document.documentElement.style.backgroundColor = '#fff'

    __dispatchCustomEvent window, 'changetheme'
