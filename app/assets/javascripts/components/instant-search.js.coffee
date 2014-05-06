Hummingbird.InstantSearchComponent = Ember.TextField.extend
  didInsertElement: ->
    @$().focus()

  focusOut: ->
    @sendAction('focusLost')