HB.RadioButtonComponent = Ember.Component.extend({
  tagName: 'input',
  type: 'radio',
  attributeBindings: ['type', 'htmlChecked:checked', 'value', 'name'],

  htmlChecked: function(){
    return this.get('value') === this.get('checked');
  }.property('value', 'checked'),

  change: function(){
    this.set('checked', this.get('value'));
  }
});
