Hummingbird.LibraryEntryView = Ember.View.extend
  templateName: "library/entry"
  showDropdown: false

  click: (event) ->
    if $(event.target).hasClass('list-item-left')
      that = this
      if @get('showDropdown')
        @$('.library-dropdown').slideUp 200, ->
          that.set 'showDropdown', false
      else
        @$('.library-dropdown').slideDown 200, ->
          that.set 'showDropdown', true
