---
---

###
Main coffeescript file
###

window.CONSTS = require './core/consts'
window.UTILS = require './core/utils'
window.APP = require './core/app'

# Feedback
window.FEEDBACK = require('./components/feedback')
#

require('./components/onload')()
