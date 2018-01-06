---
---

module.exports = (APP) ->
  # Opens a given sidebar
  #
  # $sidebar: The sidebar to open
  #
  # @private
  __openSidebar = ($sidebar) ->
    $sidebar.removeClass 'closed'
      .find '.collapse-el'
        .removeClass 'closed'
        .attr 'title', 'Collapse sidebar'
        .html '&laquo;'
    UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '0'

  # Collapses a given sidebar
  #
  # $sidebar: The sidebar to collapse
  #
  # @private
  __collapseSidebar = ($sidebar) ->
    $sidebar.addClass 'closed'
      .find '.collapse-el'
        .addClass 'closed'
        .attr 'title', 'Open sidebar'
        .html '&raquo;'
    UTILS.setIndefiniteCookie CONSTS.cookieCollapseSidebar, '1'

  # Toggles the sidebar that is the ancestor of the element this function is
  # bound to
  #
  # e: The event object passed to this handler
  APP.toggleSidebar = (e) ->
    e.preventDefault()

    $target = $(e.target)
    $sidebar = $target.closest '.sidebar-collapsible'
    isClosed = $target.hasClass 'closed'

    if isClosed
      # Open sidebar
      __openSidebar $sidebar
    else
      # Collapse sidebar
      __collapseSidebar $sidebar

    true

  $('.collapse-el').html '&laquo;'
  $('.collapse-el.closed').html '&raquo;'

  if '1' == Cookies.get CONSTS.cookieCollapseSidebar
    __collapseSidebar $('.sidebar-collapsible')
