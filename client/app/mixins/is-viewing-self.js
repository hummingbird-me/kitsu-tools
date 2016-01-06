import Ember from 'ember';

const {
  Mixin,
  computed,
  get
} = Ember;

export default Mixin.create({
  isViewingSelf: computed('user', 'currentSession.account', {
    get() {
      const user = get(this, 'user');
      return get(this, 'currentSession').isCurrentUser(user);
    }
  })
});
