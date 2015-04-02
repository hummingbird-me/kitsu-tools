import Ember from 'ember';
/* global Bloodhound */

export default Ember.Component.extend({
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
        url: '/search.json?scope=characters&depth=instant&query=%QUERY',
        filter: function(characters) {
          return Ember.$.map(characters.search, function(character) {
            return {
              name: character.title,
              title: character.get('primaryMedia.displayTitle'),
              char_id: character.link
            };
          });
        }
      }
    });
    bloodhound.initialize();
    this.typeahead = this.$().typeahead(null, {
      displayKey: 'name',
      source: bloodhound.ttAdapter(),
      templates: {
        empty: '<div class="empty-message">Nobody found :(</div>',
        suggestion: Ember.Handlebars.compile('<p><strong>{{name}}</strong> ({{title}})</p>')
      }
    });
    this.typeahead.on("typeahead:selected", function(event, item) {
      return _this.sendAction('action', item);
    });
    return this.typeahead.on("typeahead:autocompleted", function(event, item) {
      return _this.sendAction('action', item);
    });
  }
});
