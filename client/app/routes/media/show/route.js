import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import { capitalize } from 'ember-string';
import { assert } from 'ember-metal/utils';

export default Route.extend({
  mediaType: undefined,
  currentSession: service(),
  templateName: 'media/show',

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

    // Get the library entry for the current user
    const session = get(this, 'currentSession');
    if (get(session, 'isAuthenticated')) {
      const userId = get(session, 'account.id');
      const mediaId = get(model, 'id');
      const mediaType = get(this, 'mediaType');
      const promise = get(this, 'store').query('library-entry', {
        filter: {
          user_id: userId,
          media_type: capitalize(mediaType),
          media_id: mediaId
        }
      }).then((data) => set(controller, 'entry', get(data, 'firstObject')));
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
      const controller = get(this, 'controller');
      const user = get(this, 'currentSession.account');
      const media = this.modelFor(get(this, 'routeName'));
      const entry = get(this, 'store').createRecord('library-entry', {
        status,
        user,
        media
      });
      return entry.save().then(() => set(controller, 'entry', entry));
    },

    updateEntry(entry, status) {
      set(entry, 'status', status);
      return entry.save();
    },

    destroyEntry(entry) {
      const controller = get(this, 'controller');
      return entry.destroyRecord().then(() => set(controller, 'entry', undefined));
    }
  }
});
