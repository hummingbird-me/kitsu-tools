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

  isViewingSelf: computed('user', 'currentSession.account', {
    get() {
      const user = get(this, 'user');
      return get(this, 'currentSession').isCurrentUser(user);
    }
  })
});
