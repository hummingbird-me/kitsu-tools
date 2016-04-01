import Controller from 'ember-controller';
import computed, { alias } from 'ember-computed';
import service from 'ember-service/inject';
import get from 'ember-metal/get';
import IsViewingSelfMixin from 'client/mixins/is-viewing-self';

export default Controller.extend(IsViewingSelfMixin, {
  user: alias('model'),
  currentSession: service(),

  coverImageStyle: computed('user.coverImage', {
    get() {
      const coverImage = get(this, 'user.coverImage');
      return `background-image: url('${coverImage}')`.htmlSafe();
    }
  })
});
