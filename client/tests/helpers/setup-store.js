import Ember from 'ember';
import DS from 'ember-data';

import ApplicationSerializer from 'client/routes/application/serializer';

export default function(options) {
  const registry = new Ember.Registry();
  const container = registry.container();

  DS._setupContainer(registry);
  for (const prop in options) {
    registry.register(`model:${prop}`, Ember.get(options, prop));
  }
  registry.register('adapter:application', DS.JSONAPIAdapter);
  registry.register('serializer:application', ApplicationSerializer);
  return container.lookup('service:store');
}
