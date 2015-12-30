import Ember from 'ember';
import libraryStatus from 'client/utils/library-status';

const REMOVE_KEY = 'Remove from Library';
const {
  Component,
  get,
  set,
  computed,
  run,
  inject: { service }
} = Ember;

export default Component.extend({
  entry: undefined,

  ajax: service(),

  status: computed('entry.status', {
    get() {
      return libraryStatus.enumToHuman(get(this, 'entry.status'));
    }
  }),

  statuses: computed('status', {
    get() {
      const statuses = [...libraryStatus.getHumanStatuses()];
      const status = get(this, 'status');
      statuses.splice(statuses.indexOf(status), 1);
      return statuses.concat([REMOVE_KEY]);
    }
  }),

  didInsertElement() {
    run.scheduleOnce('afterRender', this, () => {
      this.$(document).foundation();
    });
  },

  actions: {
    // TODO: Give feedback to the user (Toast?)
    updateStatus(status) {
      const entry = get(this, 'entry');
      if (status === REMOVE_KEY) {
        entry.destroyRecord();
      } else {
        status = libraryStatus.humanToEnum(status);
        set(entry, 'status', status);
        entry.save();
      }
    }
  }
});
