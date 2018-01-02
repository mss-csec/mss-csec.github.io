---
---

# Polyfills

# https://developer.mozilla.org/en-US/docs/Web/API/Element/closest#Polyfill
# unless Element.prototype.matches
#   Element.prototype.matches = Element.prototype.msMatchesSelector or
#                               Element.prototype.webkitMatchesSelector

# unless Element.prototype.closest
#   Element.prototype.closest = (s) ->
#     el = this
#     return null unless document.documentElement.contains el

#     loop
#       return el if el.matches s
#       el = el.parentElement or el.parentNode
#       break if el == null

#     null

# if DOMTokenList.prototype.add.length
#   DOMTokenList.prototype.oldAdd = DOMTokenList.prototype.add
#   DOMTokenList.prototype.add = () ->
#     this.oldAdd a for a in arguments

# if DOMTokenList.prototype.remove.length
#   DOMTokenList.prototype.oldRemove = DOMTokenList.prototype.remove
#   DOMTokenList.prototype.remove = () ->
#     this.oldRemove a for a in arguments

# Various utilities

UTILS = {}

# window.$  = UTILS.$  = (ctx, sel) ->
#   (if !sel then document else ctx).querySelector sel or ctx
# window.$$ = UTILS.$$ = (ctx, sel) ->
#   [].slice (if !sel then document else ctx).querySelectorAll sel or ctx

UTILS.intSort = (a, b) -> a - b
UTILS.reverseIntSort = (a, b) -> b - a

UTILS.spaceship = (a, b) ->
  a < b ? -1 : (a > b ? 1 : 0)

UTILS.setIndefiniteCookie = (key, value) ->
  Cookies.set key, value, expires: 365

# Truncate a string of text to at most <length> characters, without severing
# words
UTILS.fuzzyTruncate = (text, length = 250, clipper = '...') ->
  if text.length <= length then return text

  lastDelim = text.lastIndexOf " ", length

  return text.slice(0, if lastDelim > -1 then lastDelim else Infinity) + clipper

# Convert a number into a pixel string
UTILS.numToPx = (num) ->
  "#{num}px"

# Cash: add custom functionality (mostly sugar)
$.fn.extend
  # Hide each of the elements of a collection and return the collection
  hide: () ->
    this.each (e) -> e.style.display = 'none'
    this

  # Show each of the elements of a collection and return the collection
  show: () ->
    this.each (e) -> e.style.display = 'block'
    this



window.UTILS = UTILS
