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
      @show()
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

    scrollHandler: ->
      top = $(window).scrollTop()
      amount = Math.abs(top - @lastScroll)

      if top > @detachPoint
        @detach()

      if top <= @detachPoint
        @attach()

      if top > -1 and amount > @hideShowOffset
        if top > @lastScroll
          @hide()
        else
          @show()

      @lastScroll = top

    init: ->
      @el = $(".hummingbird-header-actual")
      $(window).bind 'scroll', _.throttle(_.bind(@scrollHandler, this), 250)

$ ->
  HB.header.init()
