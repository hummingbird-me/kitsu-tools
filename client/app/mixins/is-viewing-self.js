import Mixin from 'ember-metal/mixin';
import computed from 'ember-computed';
import get from 'ember-metal/get';

export default Mixin.create({
  isViewingSelf: computed('user', 'currentSession.account', {
    get() {
      const user = get(this, 'user');
      return get(this, 'currentSession').isCurrentUser(user);
    }
  })
});
