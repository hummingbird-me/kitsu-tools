Hummingbird.WaifuSelectorComponent = Em.Component.extend({
  selectedChar: null,
  searchText: null,
  tagName: 'input',
  className: 'typeahead',


  waifuClearObserver: function() {
    var shouldClear = this.get('clearInput');
    if (shouldClear) {
      this.set('value', '');
      return this.$().val('Removed, save to make changes.').attr('disabled', true);
    }
  }.observes('clearInput'),

  didInsertElement: function() {
    var bloodhound, _this = this;
    this.$().val(this.get('value'));
    bloodhound = new Bloodhound({
      datumTokenizer: function(d) {
        return Bloodhound.tokenizers.whitespace(d.value);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/search.json?query=%QUERY&type=character',
        filter: function(characters) {
          return Ember.$.map(characters.search, function(character) {
            return {
              value: character.name,
              char_id: character.id
            };
          });
        }
      }
    });
    bloodhound.initialize();
    this.typeahead = this.$().typeahead(null, {
      displayKey: 'value',
      source: bloodhound.ttAdapter()
    });
    this.typeahead.on("typeahead:selected", function(event, item) {
      return _this.sendAction('action', item);
    });
    return this.typeahead.on("typeahead:autocompleted", function(event, item) {
      return _this.sendAction('action', item);
    });
  }
});