import Ember from 'ember';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const {
  Component,
  inject: { controller },
  get,
  computed,
  computed: { alias }
} = Ember;

export default Component.extend(RoutableComponentMixin, {
  application: controller(),
  currentPath: alias('application.currentPath'),
  steps: ['start', 'rating', 'categories', 'library', 'finish'],

  currentStep: computed('currentPath', function() {
    const currentPage = get(this, 'currentPath').replace('onboarding.', '');
    return get(this, 'steps').indexOf(currentPage) + 1;
  })
});
