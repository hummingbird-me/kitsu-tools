@HB =
  utils:
    negateString: (str) ->
      str = _.map str.toLowerCase().split(""), (l) ->
        return String.fromCharCode(-(l.charCodeAt(0)));
      return str
  statusBar:
    text: (text) ->
      $(".status-bar").find("span").text text
    action: (label, callback) ->
      $(".status-bar").find("a").text(label + ".").click ->
        callback()
        clearTimeout HB.statusBar.internal.hideTimeout
        HB.statusBar.hide()
    show: ->
      if HB.statusBar.internal.visible
        clearTimeout HB.statusBar.internal.hideTimeout
        HB.statusBar.hide()
      $(".status-bar").slideDown()
      HB.statusBar.internal.visible = true
      HB.statusBar.internal.hideTimeout = setTimeout HB.statusBar.hide, 5000
    hide: ->
      $(".status-bar").slideUp()
      HB.statusBar.internal.visible = false
    internal:
      visible: false
      hideTimeout: null
