Hummingbird.WaifuSelectorComponent = Em.Component.extend
  selectedChar: null
  searchText: null
  tagName: 'input'
  className: 'typeahead'
  waifuClearObserver: (->
    shouldClear = @get('clearInput')
    if shouldClear
      @set('value', '')
      @.$().val('Removing ...').attr('disabled', true)
  ).observes('clearInput')
  didInsertElement: ->
    @.$().val(@get('value'))
    bloodhound = new Bloodhound
      datumTokenizer: (d)->
        return Bloodhound.tokenizers.whitespace(d.value)
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: '/search.json?query=%QUERY&type=character'
        filter: (characters)->
          return Ember.$.map(characters.search, (character)->
            return {value: character.name, char_id: character.id}
          )
    bloodhound.initialize()

    _this = @
    this.typeahead = @.$().typeahead(null,{ displayKey: 'value', source: bloodhound.ttAdapter() })
    this.typeahead.on("typeahead:selected", (event, item)->
       _this.sendAction('action',item)
    )
    this.typeahead.on("typeahead:autocompleted", (event, item)->
      _this.sendAction('action', item)  
    )
