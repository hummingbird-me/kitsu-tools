import Ember from 'ember';

export default function computedPropertyEqual(p1, p2) {
  return Ember.computed(p1, p2, function() {
    return this.get(p1) === this.get(p2);
  });
}
