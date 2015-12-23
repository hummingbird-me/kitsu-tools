import Ember from 'ember';

const {
  Controller,
  inject: { controller },
  get,
  computed,
  computed: { alias }
} = Ember;

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
