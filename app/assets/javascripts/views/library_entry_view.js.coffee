Hummingbird.LibraryEntryView = Ember.View.extend
  user: Ember.computed.alias('controller.user')

  didInsertElement: ->
    @set 'reactComponent', LibraryEntryReactComponent(
      content: @get('content')
      view: this
    )
    React.renderComponent @get('reactComponent'), @get('element')

  willClearRender: ->
    React.unmountComponentAtNode @get('element')
