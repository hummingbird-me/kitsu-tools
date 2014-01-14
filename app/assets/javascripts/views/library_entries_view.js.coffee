Hummingbird.LibraryEntriesView = Ember.View.extend
  user: Ember.computed.alias('controller.user')

  didInsertElement: ->
    @set 'reactComponent', LibraryEntrySectionReactComponent(
      content: @get('content')
      view: this
    )
    React.renderComponent @get('reactComponent'), @get('element')

  willClearRender: ->
    React.unmountComponentAtNode @get('element')
