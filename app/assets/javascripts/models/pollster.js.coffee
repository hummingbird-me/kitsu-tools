Hummingbird.Pollster = Em.Object.extend
  timer: null
  start: ->
    _this = @
    @set 'timer', Ember.run.later(@, ->
      _this.onPoll()
      _this.start()
     , 120000)
  stop: -> 
     timer = @get('timer')
     Ember.run.cancel(timer)
  onPoll: ->
