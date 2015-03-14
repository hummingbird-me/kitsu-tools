import Ember from 'ember';
/* global React */
/* global LibrarySectionsReactComponent */

export default Ember.View.extend({
  user: Ember.computed.alias('controller.user'),
  sections: Ember.computed.alias('controller.sections'),
  reactComponent: Ember.computed.alias('controller.reactComponent'),

  didInsertElement: function() {
    this.set('reactComponent', LibrarySectionsReactComponent({
      content: this.get('sections'),
      view: this
    }));
    return React.renderComponent(this.get('reactComponent'), this.get('element').querySelector('#library-sections'));
  },

  willClearRender: function() {
    React.unmountComponentAtNode(this.get('element').querySelector('#library-sections'));
    return this.set('reactComponent', null);
  }
});
