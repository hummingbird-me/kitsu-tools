_.extend HB,
  header: 
    lastScroll: 0
    hideShowOffset: 20
    detachPoint: 500
    attached: true
    visible: true
    open: false
    el: null

    detach: ->
      if @attached and not @visible
        @el.removeClass("nav-attached")
        @attached = false

    attach: ->
      unless @attached
        @el.addClass("nav-attached")
        @attached = true

    show: ->
      unless @visible
        @el.removeClass("nav-hidden").addClass("nav-visible")
        @visible = true

    hide: ->
      if @visible
        @el.removeClass("nav-visible").addClass("nav-hidden")
        @visible = false

    scrollHander: ->
      top = $(window).scrollTop()
      direction = if top > @lastScroll then "down" else "up"
      amount = Math.abs(top - @lastScroll)

      if top > @detachPoint
        @detach()

      if top <= 0
        @attach()

      if top > -1 and amount > @hideShowOffset
        if direction == "down"
          @hide()
        else if direction == "up"
          @show()

      @lastScroll = top

    init: ->
      @el = $(".hummingbird-header-actual")
      $(window).bind "scroll", ($.throttle 300, $.proxy(@scrollHander, this))

$ ->
  HB.header.init()
