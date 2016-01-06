import Ember from 'ember';
import IsViewingSelfMixin from 'client/mixins/is-viewing-self';

const {
Controller,
computed,
computed: { alias },
inject: { service },
get
} = Ember;

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
