import Route from 'ember-route';
import get from 'ember-metal/get';

export default Route.extend({
  titleToken() {
    const model = this.modelFor('users');
    const name = get(model, 'name');
    return `${name}'s Profile`;
  }
});
