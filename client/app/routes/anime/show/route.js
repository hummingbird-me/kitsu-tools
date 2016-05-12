import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

export default Route.extend(CanonicalUrlRedirect, {
  currentSession: service(),

  model({ slug }) {
    if (slug.match(/\D+/)) {
      return get(this, 'store').query('anime', { filter: { slug } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('anime', slug);
    }
  },

  setupController(controller, model) {
    this._super(...arguments);

    // Get the anime library entry for the current user
    const session = get(controller, 'currentSession');
    if (get(session, 'isAuthenticated')) {
      const userId = get(session, 'account.id');
      const animeId = get(model, 'id');
      const promise = get(this, 'store').query('library-entry', {
        filter: {
          // jscs:disable
          user_id: userId,
          anime_id: animeId
          // jscs:enable
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
      const anime = this.modelFor(get(this, 'routeName'));
      const entry = get(this, 'store').createRecord('library-entry', {
        status,
        user,
        anime
      });
      return entry.save().then(() => set(controller, 'entry', entry));
    },

    updateEntry(entry, status) {
      set(entry, 'status', status);
      return entry.save();
    },

    destroyEntry(entry) {
      const controller = get(this, 'controller');
      return entry.destroyEntry().then(() => set(controller, 'entry', undefined));
    }
  }
});
