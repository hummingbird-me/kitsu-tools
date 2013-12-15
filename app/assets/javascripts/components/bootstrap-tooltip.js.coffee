Hummingbird.BootstrapTooltipComponent = Ember.Component.extend
  tagName: 'a'

  initializeTooltip: (->
    @$().tooltip
      placement: @get('placement')
      title: @get('title')
  ).on('didInsertElement')

  updateTooltip: (->
    @$().tooltip 'destroy'
    @initializeTooltip()
  ).observes('title', 'placement')
