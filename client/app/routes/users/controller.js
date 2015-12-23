import Ember from 'ember';

const {
Controller,
computed,
computed: { alias },
inject: { service },
get
} = Ember;

export default Controller.extend({
  user: alias('model'),
  currentSession: service(),

  isViewingSelf: computed('currentSession.account', {
    get() {
      const currentUser = get(this, 'currentSession.account');
      return currentUser && get(currentUser, 'id') === get(this, 'user.id');
    }
  })
});
