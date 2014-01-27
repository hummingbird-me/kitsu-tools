Hummingbird.UserIndexView = Ember.View.extend
  didInsertElement: ->
    @$(".status-form").focus (->
      @$(".status-form").autosize append: "\n"
      @$(".status-update-panel .panel-footer").slideDown(200)
    ).bind this

  willClearRender: ->
    @$(".status-form").trigger "autosize.destroy"
