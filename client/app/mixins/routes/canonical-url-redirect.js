import Mixin from 'ember-metal/mixin';
import get from 'ember-metal/get';

/**
 * This mixin checks if the dynamic segment of a route does not match the
 * value of that key from the route's model. This forces us to match our route
 * segments to model attributes, for example:
 *
 *    `/anime/:slug` => { slug: 'cowboy-bebop' }
 *
 * If you requested `/anime/1`, this mixin would redirect you to
 * `/anime/cowboy-bebop`
 */
export default Mixin.create({
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
