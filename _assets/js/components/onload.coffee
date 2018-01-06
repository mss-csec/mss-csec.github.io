---
---

module.exports = () ->
  console.log "Loaded on #{(new Date()).toLocaleString()}"

  # Parse theme changes
  if 'dark' == Cookies.get CONSTS.cookieTheme
    APP.changeTheme 'dark'

  # Add event handlers
  $('.toggle-theme').on 'click', (e) ->
    theme = Cookies.get CONSTS.cookieTheme

    e.preventDefault()

    if theme == 'dark'
      Cookies.set CONSTS.cookieTheme, 'light'
      APP.changeTheme 'light'
    else
      Cookies.set CONSTS.cookieTheme, 'dark'
      APP.changeTheme 'dark'

  # Header
  if !$('body').hasClass('no-hero') and
  !$('body').hasClass('landing') and
  !$('body').hasClass('lesson') and
  !$('body').hasClass('post') and
  !$('body').hasClass('resource') and
  window.innerWidth > CONSTS.bpTablet
    $(window).on 'scroll', (e) ->
      if window.pageYOffset > 100
        $('body .site-header').removeClass 'at-top'
      else
        $('body .site-header').addClass 'at-top'
    $('body .site-header').addClass 'at-top'

  # Unhide body
  $('body').removeClass 'no-js'

  # KaTeX rendering
  __katexFail = false
  __renderKatex = (tex) ->
    try
      $(tex).after katex.renderToString $(tex).text().replace(/%.*/g, ''),
        throwOnError: true
        displayMode: ~tex.type.indexOf 'mode=display'
    catch e
      # Set up loading MathJax
      console.log e.message
      __katexFail = true

  __useMathJax = () ->
    mjSrc = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js'
    mjSRI = 'sha384-Ra6zh6uYMmH5ydwCqqMoykyf1T/+ZcnOQfFPhDrp2kI4OIxadnhsvvA2vv9A7xYv'

    script = document.createElement 'script'
    script.src = mjSrc
    script.integrity = mjSRI
    script.crossOrigin = 'anonymous'
    $('head').append script

  $('script[type*="math/tex"]').each __renderKatex

  window.renderMathInElement document.body,
    delimiters: [
      { left: "\\[", right: "\\]", display: true }
      { left: "\\(", right: "\\)", display: false }
    ]
    throwOnError: true
    errorCallback: () ->
      console.log 'KaTeX rendering failed! Loading MathJax'
      __useMathJax()

  if $('.katex').length
    $('head').append "<link
      rel='stylesheet'
      href='https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.8.3/katex.min.css'
      integrity='sha384-B41nY7vEWuDrE9Mr+J2nBL0Liu+nl/rBXTdpQal730oTHdlrlXHzYMOhDU60cwde'
      crossorigin='anonymous'>"

  if __katexFail
    console.log 'KaTeX rendering failed! Loading MathJax'
    __useMathJax()

  # Anchor-js
  anchors.options =
    visible: 'touch',
    icon: '§'
  anchors.add '#main-content h2, #main-content h3'

  # Run page scripts
  SCRIPTS.run()
