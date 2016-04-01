import Route from 'ember-route';

export default Route.extend({
  redirect() {
    this.transitionTo('dashboard');
  }
});
