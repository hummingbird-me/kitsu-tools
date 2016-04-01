import Mixin from 'ember-metal/mixin';
import get from 'ember-metal/get';

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
