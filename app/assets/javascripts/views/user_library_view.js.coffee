Hummingbird.UserLibraryView = Ember.View.extend
  user: Ember.computed.alias 'controller.user'
  sections: Ember.computed.alias 'controller.sections'
  reactComponent: Ember.computed.alias 'controller.reactComponent'

  didInsertElement: ->
    @set 'reactComponent', LibrarySectionsReactComponent(
      content: @get('sections')
      view: this,
    )
    React.renderComponent @get('reactComponent'), @get('element').querySelector('#library-sections')

  willClearRender: ->
    React.unmountComponentAtNode @get('element').querySelector('#library-sections')
