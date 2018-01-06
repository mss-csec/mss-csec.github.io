---
---

APP = {}

APP.SUBCLUB_END_HOUR = 17;

APP.currentTheme = 'light'

# Extensions
require('../components/theme')(APP)
require('../components/schedule')(APP)
require('../components/misc')(APP)

# Non-extensions
require('../components/pascha')()
require('../components/announcements')()

module.exports = APP
