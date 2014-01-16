Hummingbird.FileUpload = Ember.TextField.extend
  type: 'file'
  attributeBindings: ['name']
  classNames: ['hidden']

  change: (evt) ->
    input = evt.target
    if input.files && input.files[0]
      @sendAction 'action', input.files[0]
