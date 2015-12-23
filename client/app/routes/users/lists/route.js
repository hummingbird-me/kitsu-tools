import Ember from 'ember';

const {
  Route,
  get
} = Ember;

export default Route.extend({
  titleToken() {
    const model = this.modelFor('users');
    const name = get(model, 'name');
    return `${name}'s Lists`;
  }
});
