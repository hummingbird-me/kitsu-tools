Hummingbird.TruncateTextComponent = Ember.Component.extend
  expanded: false

  isTruncated: (->
    @get('text').length > @get('length') + 10
  ).property('text', 'length')

  truncatedText: (->
    if @get('isTruncated') and not @get('expanded')
      jQuery.trim(@get('text')).substring(0, @get('length')).trim(this) + "..."
    else
      @get('text')
  ).property('text', 'length', 'expanded')

  actions:
    toggleExpansion: ->
      @toggleProperty 'expanded'
