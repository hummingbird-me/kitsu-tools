//= require_tree ./react
//= require_self
//= require_tree ./lib
//= require hummingbird

Ember.LinkView.reopen({
  attributeBindings: ['href', 'title', 'rel', 'data-hover']
});
