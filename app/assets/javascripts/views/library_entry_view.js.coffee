Hummingbird.LibraryEntryView = Ember.View.extend
  templateName: "library/entry"
  showDropdown: false

  click: (event) ->
    unless event.target.nodeName == "INPUT"
      if $(event.target).closest('.list-group-item').length == 1
        that = this
        if @get('showDropdown')
          @$('.library-dropdown').slideUp 200, ->
            that.set 'showDropdown', false
        else
          @$('.library-dropdown').slideDown 200, ->
            that.set 'showDropdown', true
