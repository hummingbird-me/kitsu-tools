Hummingbird.LibraryEntryView = Ember.View.extend
  templateName: "library/entry"
  showDropdown: false

  click: ->
    @set 'showDropdown', !@get('showDropdown')
