Hummingbird.Pollster = Em.Object.extend
  timer: null
  start: ->
    _this = @
    @set 'timer', setInterval(
      _this.onPoll.bind(_this)
    ), 30000
   stop: -> 
     timer = @get('timer')
     clearInterval(timer)
   onPoll: ->
