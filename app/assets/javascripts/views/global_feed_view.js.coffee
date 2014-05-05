Hummingbird.DashboardView = Ember.View.extend
  didInsertElement: ->
    @$(".status-form").focus (->
      @$(".status-form").autosize append: "\n"
      @$(".status-update-panel .panel-footer").slideDown(200)
    ).bind this
    @$(".status-form").blur (->
      if @$(".status-form").val().replace(/\s/g, '').length == 0
        @$(".status-form").val('')
        @$(".status-form").trigger "autosize.destroy"
        @$(".status-update-panel .panel-footer").slideUp(200)
    ).bind this

  willClearRender: ->
    @$(".status-form").trigger "autosize.destroy"