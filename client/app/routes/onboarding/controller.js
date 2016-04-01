import Controller from 'ember-controller';
import controller from 'ember-controller/inject';
import get from 'ember-metal/get';
import computed, { alias } from 'ember-computed';

export default Controller.extend({
  application: controller(),
  currentPath: alias('application.currentPath'),
  steps: ['start', 'rating', 'categories', 'library', 'finish'],

  currentStep: computed('currentPath', {
    get() {
      const currentPage = get(this, 'currentPath').replace('onboarding.', '');
      return get(this, 'steps').indexOf(currentPage) + 1;
    }
  })
});
