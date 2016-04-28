import Controller from 'ember-controller';
import computed, { alias } from 'ember-computed';
import service from 'ember-service/inject';
import get from 'ember-metal/get';
import IsOwnerMixin from 'client/mixins/is-owner';

export default Controller.extend(IsOwnerMixin, {
  user: alias('model'),
  currentSession: service(),

  coverImageStyle: computed('user.coverImage', {
    get() {
      const coverImage = get(this, 'user.coverImage');
      return `background-image: url('${coverImage}')`.htmlSafe();
    }
  })
});
