Hummingbird.UserMangaLibraryView = Ember.View.extend
  user: Ember.computed.alias 'controller.user'
  sections: Ember.computed.alias 'controller.sections'
  reactComponent: Ember.computed.alias 'controller.reactComponent'

  didInsertElement: ->
    @set 'reactComponent', MangaLibrarySectionsReactComponent(
      content: @get('sections')
      view: this,
    )
    React.renderComponent @get('reactComponent'), @get('element').querySelector('#manga-library-sections')

  willClearRender: ->
    React.unmountComponentAtNode @get('element').querySelector('#manga-library-sections')
    @set 'reactComponent', null
