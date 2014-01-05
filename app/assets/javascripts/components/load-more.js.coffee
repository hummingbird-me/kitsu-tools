Hummingbird.LoadMoreComponent = Ember.Component.extend
  checkInView: ->
    elementBottom = @$().offset().top + @$().height()
    windowBottom = window.scrollY + $(window).height()
    if elementBottom < windowBottom + 200
      @sendAction()

  didInsertElement: ->
    $(window).bind 'scroll.loadmore', $.proxy(@checkInView, this)

  willClearRender: ->
    $(window).unbind 'scroll.loadmore'
