import Ember from 'ember';

const {
  Mixin,
  get
} = Ember;

export default Mixin.create({
  // compare the params used for the route to the models `routeKey`,
  // if they don't match then redirect to the correct URL
  redirect(model) {
    const routeName = get(this, 'routeName');
    const routeKey = get(this, 'routeKey');

    const params = this.paramsFor(routeName);
    const current = get(params, routeKey);
    const correct = get(model, routeKey);
    if (current !== correct) {
      this.transitionTo(routeName, correct);
    }
  }
});
