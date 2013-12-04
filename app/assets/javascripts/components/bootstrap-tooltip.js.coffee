Hummingbird.BootstrapTooltipComponent = Ember.Component.extend
  tagName: 'span'
  didInsertElement: ->
    @$().tooltip
      placement: @get('placement')
      title: @get('title')
