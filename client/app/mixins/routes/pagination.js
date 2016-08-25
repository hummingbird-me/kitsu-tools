import Mixin from 'ember-metal/mixin';
import get from 'ember-metal/get';
import set from 'ember-metal/set';

export default Mixin.create({
  actions: {
    updateNextPage(records, links) {
      const controller = this.controllerFor(get(this, 'routeName'));
      const content = get(controller, 'model').toArray();
      content.addObjects(records);
      set(controller, 'model', content);
      set(controller, 'model.links', links);
    }
  }
});
