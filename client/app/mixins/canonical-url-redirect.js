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
    const params = this.paramsFor(routeName);
    const [key] = Object.keys(params);
    const current = get(params, key);
    const correct = get(model, key);
    if (current !== correct) {
      this.replaceWith(routeName, correct);
    }
  }
});
