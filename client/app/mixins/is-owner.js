import Mixin from 'ember-metal/mixin';
import computed from 'ember-computed';
import get from 'ember-metal/get';

/**
 * Returns true if the current session is the same user as the `user` property
 * or if that user has specific privileges such as admin. (NYI)
 *
 * Requires the object to import both the `current-session` service and an
 * instance of `user`.
 */
export default Mixin.create({
  isOwner: computed('user', 'currentSession.account', {
    get() {
      const user = get(this, 'user');
      return get(this, 'currentSession').isCurrentUser(user);
    }
  })
});
