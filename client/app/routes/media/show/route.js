import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import { assert } from 'ember-metal/utils';
import service from 'ember-service/inject';
import LibraryEntryMixin from 'client/mixins/library-entry';

export default Route.extend(LibraryEntryMixin, {
  mediaType: undefined,
  templateName: 'media/show',
  currentSession: service(),

  init() {
    this._super(...arguments);
    const mediaType = get(this, 'mediaType');
    assert('Must provide a `mediaType` value', mediaType !== undefined);
  },

  model({ slug }) {
    const mediaType = get(this, 'mediaType');
    if (slug.match(/\D+/)) {
      return get(this, 'store').query(mediaType, { filter: { slug } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord(mediaType, slug);
    }
  },

  setupController(controller, model) {
    this._super(...arguments);
    if (get(this, 'currentSession.isAuthenticated') === true) {
      const promise = this._getLibraryEntry(model).then((results) => {
        set(controller, 'entry', get(results, 'firstObject'));
      });
      set(controller, 'entryPromise', promise);
    }
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  },

  serialize(model) {
    return { slug: get(model, 'slug') };
  },

  actions: {
    createEntry(status) {
      const controller = this.controllerFor(get(this, 'routeName'));
      const user = get(this, 'currentSession.account');
      const media = this.modelFor(get(this, 'routeName'));
      const entry = get(this, 'store').createRecord('library-entry', {
        status,
        user,
        media
      });
      return entry.save().then(() => {
        set(controller, 'entry', entry);
      });
    },

    updateEntry(entry, status) {
      set(entry, 'status', status);
      return entry.save().catch(() => entry.rollbackAttributes());
    },

    deleteEntry(entry) {
      const controller = this.controllerFor(get(this, 'routeName'));
      return entry.destroyRecord()
        .then(() => set(controller, 'entry', undefined))
        .catch(() => entry.rollbackAttributes());
    }
  }
});
