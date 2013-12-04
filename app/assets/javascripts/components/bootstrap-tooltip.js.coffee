Hummingbird.BootstrapTooltipComponent = Ember.Component.extend
  tagName: 'a'
  didInsertElement: ->
    @$().tooltip
      placement: @get('placement')
      title: @get('title')
