import Route from 'ember-route';
import get from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import CanonicalUrlRedirect from 'client/mixins/canonical-url-redirect';

export default Route.extend(CanonicalUrlRedirect, {
  currentSession: service(),

  model(params) {
    const { slug } = params;
    if (slug.match(/\D+/)) {
      return get(this, 'store').query('anime', { filter: { slug } })
        .then((records) => get(records, 'firstObject'));
    } else {
      return get(this, 'store').findRecord('anime', slug);
    }
  },

  setupController(controller, model) {
    this._super(...arguments);
    // Grab the library entry for this user & anime
    if (get(this, 'currentSession.isAuthenticated') === true) {
      const userId = get(this, 'currentSession.account.id');
      const animeId = get(model, 'id');
      set(controller, 'isLoadingEntry', true);
      get(this, 'store').query('library-entry', {
        filter: {
          // jscs:disable
          user_id: userId,
          anime_id: animeId
          // jscs:enable
        }
      }).then((records) => {
        const record = get(records, 'firstObject');
        if (record !== undefined) {
          set(controller, 'entry', record);
        } else {
          // TODO: Can be removed when we switch to routable components
          set(controller, 'entry', undefined);
        }
        set(controller, 'isLoadingEntry', false);
      });
    }
  },

  titleToken(model) {
    return get(model, 'canonicalTitle');
  },

  serialize(model) {
    return { slug: get(model, 'slug') };
  }
});
